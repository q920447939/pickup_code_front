import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pickup_code_front/app/routes/app_routes.dart';
import 'package:pickup_code_front/domain/apis/group_sync_api.dart';
import 'package:pickup_code_front/domain/entities/app_mode.dart';
import 'package:pickup_code_front/domain/entities/group.dart';
import 'package:pickup_code_front/domain/entities/pickup.dart';
import 'package:pickup_code_front/domain/entities/pickup_parse_result.dart';
import 'package:pickup_code_front/domain/repositories/pickup_repository.dart';
import 'package:pickup_code_front/domain/usecases/parse_pickup_message_usecase.dart';
import 'package:pickup_code_front/domain/usecases/save_template_rule_usecase.dart';
import 'package:pickup_code_front/modules/mode/mode_controller.dart';

class PickupDetailController extends GetxController {
  PickupDetailController({
    required PickupRepository pickupRepository,
    required ParsePickupMessageUseCase parseUseCase,
    required SaveTemplateRuleUseCase saveTemplateRuleUseCase,
    required ModeController modeController,
    required GroupSyncApi groupSyncApi,
  }) : _pickupRepository = pickupRepository,
       _parseUseCase = parseUseCase,
       _saveTemplateRuleUseCase = saveTemplateRuleUseCase,
       _modeController = modeController,
       _groupSyncApi = groupSyncApi;

  final PickupRepository _pickupRepository;
  final ParsePickupMessageUseCase _parseUseCase;
  final SaveTemplateRuleUseCase _saveTemplateRuleUseCase;
  final ModeController _modeController;
  final GroupSyncApi _groupSyncApi;

  final codeController = TextEditingController();
  final stationController = TextEditingController();
  final noteController = TextEditingController();
  final templateNameController = TextEditingController();

  final Rx<DateTime?> expireAt = Rx<DateTime?>(null);
  final Rx<PickupSource> source = PickupSource.manual.obs;
  final Rx<PickupStatus> status = PickupStatus.pending.obs;
  final RxBool isEditing = false.obs;
  final RxString importedText = ''.obs;
  final Rxn<PickupParseResult> parseResult = Rxn<PickupParseResult>();
  final RxBool saveAsTemplate = false.obs;

  String? _originalCode;

  @override
  void onInit() {
    super.onInit();
    final arg = Get.arguments;
    if (arg is Pickup) {
      isEditing.value = true;
      _originalCode = arg.code;
      codeController.text = arg.code;
      stationController.text = arg.stationName ?? '';
      noteController.text = arg.note ?? '';
      expireAt.value = arg.expireAt;
      status.value = arg.status;
      source.value = arg.source;
    }
  }

  @override
  void onClose() {
    codeController.dispose();
    stationController.dispose();
    noteController.dispose();
    templateNameController.dispose();
    super.onClose();
  }

  AppMode get mode => _modeController.current.value;

  String get expireAtLabel {
    final value = expireAt.value;
    if (value == null) {
      return '未设置';
    }
    final month = value.month.toString().padLeft(2, '0');
    final day = value.day.toString().padLeft(2, '0');
    final hour = value.hour.toString().padLeft(2, '0');
    final minute = value.minute.toString().padLeft(2, '0');
    return '$month-$day $hour:$minute';
  }

  Future<void> selectExpireAt(BuildContext context) async {
    final now = DateTime.now();
    final initial = expireAt.value ?? now;
    final date = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: now.subtract(const Duration(days: 365 * 2)),
      lastDate: now.add(const Duration(days: 365 * 2)),
    );
    if (date == null || !context.mounted) {
      return;
    }
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(initial),
    );
    if (!context.mounted) {
      return;
    }
    final finalTime = time ?? const TimeOfDay(hour: 23, minute: 59);
    expireAt.value = DateTime(
      date.year,
      date.month,
      date.day,
      finalTime.hour,
      finalTime.minute,
    );
  }

  void clearExpireAt() {
    expireAt.value = null;
  }

  Future<void> pasteImport() async {
    final data = await Clipboard.getData('text/plain');
    final text = data?.text?.trim();
    if (text == null || text.isEmpty) {
      Get.snackbar('剪贴板为空', '请先复制短信内容');
      return;
    }
    importedText.value = text;
    saveAsTemplate.value = false;
    final result = await _parseUseCase.execute(text, mode: mode);
    parseResult.value = result;
    source.value = PickupSource.pasteImport;
    if (result == null || !result.isValid) {
      Get.snackbar('识别失败', '已保留短信内容，请手动修正');
      return;
    }
    codeController.text = result.code ?? '';
    stationController.text = result.stationName ?? '';
    expireAt.value = result.expireAt;
    Get.snackbar('已识别', '已填充取件信息');
  }

  Future<void> copyCode() async {
    final code = codeController.text.trim();
    if (code.isEmpty) {
      Get.snackbar('暂无取件码', '请先填写取件码');
      return;
    }
    await Clipboard.setData(ClipboardData(text: code));
    Get.snackbar('已复制', '取件码 $code');
  }

  Future<void> quickMark(PickupStatus newStatus) async {
    status.value = newStatus;
    await save();
  }

  Future<void> save() async {
    final code = codeController.text.trim();
    if (code.isEmpty) {
      Get.snackbar('校验失败', '取件码不能为空');
      return;
    }
    final station = stationController.text.trim();
    final note = noteController.text.trim();
    final pickup = Pickup(
      code: code,
      stationName: station.isEmpty ? null : station,
      expireAt: expireAt.value,
      status: status.value,
      source: source.value,
      note: note.isEmpty ? null : note,
    );
    await _pickupRepository.upsertPickup(pickup, mode: mode);
    if (_originalCode != null && _originalCode != code) {
      await _pickupRepository.deletePickup(_originalCode!, mode: mode);
    }
    await _saveTemplateIfNeeded(
      sampleText: importedText.value,
      code: code,
      station: station,
    );
    Get.back();
  }

  Future<void> shareToGroup() async {
    if (mode != AppMode.ai) {
      Get.snackbar('暂不可用', '请切换到 AI 模式后分享');
      return;
    }
    final code = codeController.text.trim();
    if (code.isEmpty) {
      Get.snackbar('无法分享', '请先填写取件码');
      return;
    }
    final session = await _groupSyncApi.fetchSession();
    if (session == null) {
      Get.snackbar('需要登录', '请先在代取协作中登录');
      await Get.toNamed(Routes.group);
      return;
    }
    final groups = await _groupSyncApi.fetchGroups();
    if (groups.isEmpty) {
      Get.snackbar('暂无小组', '请先创建或加入小组');
      await Get.toNamed(Routes.group);
      return;
    }
    final selected = await _pickGroup(groups);
    if (selected == null) {
      return;
    }
    final pickup = _buildPickupForShare();
    await _groupSyncApi.sharePickup(selected.id, pickup);
    Get.snackbar('已分享', '已分享到 ${selected.name}');
  }

  Future<void> deletePickup() async {
    if (_originalCode == null) {
      return;
    }
    await _pickupRepository.deletePickup(_originalCode!, mode: mode);
    Get.back();
  }

  Future<void> _saveTemplateIfNeeded({
    required String sampleText,
    required String code,
    String? station,
  }) async {
    if (!saveAsTemplate.value) {
      return;
    }
    if (sampleText.trim().isEmpty) {
      Get.snackbar('模板未保存', '请先粘贴短信内容');
      return;
    }
    final ruleId = await _saveTemplateRuleUseCase.execute(
      sampleText: sampleText,
      code: code,
      station: station,
      name: templateNameController.text.trim().isEmpty
          ? null
          : templateNameController.text.trim(),
      mode: mode,
    );
    if (ruleId == null) {
      Get.snackbar('模板未保存', '请确认短信示例与取件码内容');
    } else {
      Get.snackbar('模板已保存', '可在模板管理中启用/调整');
    }
  }

  Pickup _buildPickupForShare() {
    final station = stationController.text.trim();
    final note = noteController.text.trim();
    return Pickup(
      code: codeController.text.trim(),
      stationName: station.isEmpty ? null : station,
      expireAt: expireAt.value,
      status: status.value,
      source: source.value,
      note: note.isEmpty ? null : note,
    );
  }

  Future<GroupInfo?> _pickGroup(List<GroupInfo> groups) async {
    return Get.bottomSheet<GroupInfo>(
      Container(
        padding: const EdgeInsets.only(top: 12, bottom: 24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: Colors.black12,
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            const Text('选择小组', style: TextStyle(fontSize: 16)),
            const SizedBox(height: 12),
            SizedBox(
              height: 280,
              child: ListView.separated(
                itemBuilder: (context, index) {
                  final group = groups[index];
                  return ListTile(
                    title: Text(group.name),
                    subtitle: Text('邀请码 ${group.inviteCode}'),
                    onTap: () => Get.back(result: group),
                  );
                },
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemCount: groups.length,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
