import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:pickup_code_front/domain/apis/ai_extract_api.dart';
import 'package:pickup_code_front/domain/entities/app_mode.dart';
import 'package:pickup_code_front/domain/entities/pickup.dart';
import 'package:pickup_code_front/domain/entities/pickup_parse_result.dart';
import 'package:pickup_code_front/domain/repositories/pickup_repository.dart';
import 'package:pickup_code_front/modules/mode/mode_controller.dart';

class AiController extends GetxController {
  AiController({
    required AiExtractApi aiExtractApi,
    required PickupRepository pickupRepository,
    required ModeController modeController,
  }) : _aiExtractApi = aiExtractApi,
       _pickupRepository = pickupRepository,
       _modeController = modeController;

  final AiExtractApi _aiExtractApi;
  final PickupRepository _pickupRepository;
  final ModeController _modeController;

  final textController = TextEditingController();
  final RxBool isLoading = false.obs;
  final RxBool hasTried = false.obs;
  final Rxn<PickupParseResult> result = Rxn<PickupParseResult>();

  static const String sampleText =
      '【菜鸟驿站】取件码 A1B2C3，'
      '请于明天18:00前取件。';

  AppMode get mode => _modeController.current.value;
  bool get isAiMode => mode == AppMode.ai;

  @override
  void onClose() {
    textController.dispose();
    super.onClose();
  }

  void switchToAiMode() {
    _modeController.switchMode(AppMode.ai);
  }

  Future<void> pasteFromClipboard() async {
    final data = await Clipboard.getData('text/plain');
    final text = data?.text?.trim();
    if (text == null || text.isEmpty) {
      Get.snackbar('剪贴板为空', '请先复制短信内容');
      return;
    }
    textController.text = text;
    hasTried.value = false;
    result.value = null;
  }

  Future<void> fillSample() async {
    textController.text = sampleText;
    hasTried.value = false;
    result.value = null;
    await extract();
  }

  Future<void> extract() async {
    if (!isAiMode) {
      Get.snackbar('需要切换模式', '请先切换到 AI 模式');
      return;
    }
    final text = textController.text.trim();
    if (text.isEmpty) {
      Get.snackbar('内容为空', '请输入或粘贴短信内容');
      return;
    }
    isLoading.value = true;
    hasTried.value = true;
    try {
      final parsed = await _aiExtractApi.extract(text);
      result.value = parsed;
      if (parsed == null || !parsed.isValid) {
        Get.snackbar('识别失败', '请手动确认或调整内容');
      } else {
        Get.snackbar('识别成功', '已解析取件信息');
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> saveAsPickup() async {
    if (!isAiMode) {
      Get.snackbar('需要切换模式', '请先切换到 AI 模式');
      return;
    }
    final parsed = result.value;
    if (parsed == null || !parsed.isValid) {
      Get.snackbar('无法保存', '请先完成识别');
      return;
    }
    final pickup = Pickup(
      code: parsed.code!.trim(),
      stationName: parsed.stationName,
      expireAt: parsed.expireAt,
      status: PickupStatus.pending,
      source: PickupSource.pasteImport,
    );
    await _pickupRepository.upsertPickup(pickup, mode: AppMode.ai);
    Get.snackbar('已保存', '已保存到 AI 模式待取列表');
  }
}
