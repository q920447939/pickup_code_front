import 'dart:async';

import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pickup_code_front/domain/apis/group_sync_api.dart';
import 'package:pickup_code_front/domain/entities/app_mode.dart';
import 'package:pickup_code_front/domain/entities/group.dart';
import 'package:pickup_code_front/modules/mode/mode_controller.dart';

class GroupController extends GetxController {
  GroupController({
    required GroupSyncApi groupSyncApi,
    required ModeController modeController,
  }) : _groupSyncApi = groupSyncApi,
       _modeController = modeController;

  final GroupSyncApi _groupSyncApi;
  final ModeController _modeController;

  final nicknameController = TextEditingController();
  final groupNameController = TextEditingController();
  final inviteCodeController = TextEditingController();

  final Rxn<GroupSession> session = Rxn<GroupSession>();
  final RxList<GroupInfo> groups = <GroupInfo>[].obs;
  final Rxn<GroupInfo> selectedGroup = Rxn<GroupInfo>();
  final RxList<GroupShareRecord> shares = <GroupShareRecord>[].obs;

  StreamSubscription<GroupSession?>? _sessionSub;
  StreamSubscription<List<GroupInfo>>? _groupSub;
  StreamSubscription<List<GroupShareRecord>>? _shareSub;

  AppMode get mode => _modeController.current.value;
  bool get isAiMode => mode == AppMode.ai;

  @override
  void onInit() {
    super.onInit();
    _sessionSub = _groupSyncApi.watchSession().listen((value) {
      session.value = value;
    });
    _groupSub = _groupSyncApi.watchGroups().listen((items) {
      groups.assignAll(items);
      _syncSelection(items);
    });
  }

  @override
  void onClose() {
    _sessionSub?.cancel();
    _groupSub?.cancel();
    _shareSub?.cancel();
    nicknameController.dispose();
    groupNameController.dispose();
    inviteCodeController.dispose();
    super.onClose();
  }

  void switchToAiMode() {
    _modeController.switchMode(AppMode.ai);
  }

  Future<void> signIn() async {
    if (!isAiMode) {
      Get.snackbar('需要切换模式', '请先切换到 AI 模式');
      return;
    }
    final nickname = nicknameController.text.trim();
    final signed = await _groupSyncApi.signIn(nickname: nickname);
    session.value = signed;
    Get.snackbar('登录成功', '欢迎你，${signed.nickname}');
  }

  Future<void> signOut() async {
    await _groupSyncApi.signOut();
    session.value = null;
    shares.clear();
    Get.snackbar('已退出', '已退出当前账号');
  }

  Future<void> createGroup() async {
    if (!_ensureReady()) {
      return;
    }
    final name = groupNameController.text.trim();
    final group = await _groupSyncApi.createGroup(name);
    groupNameController.clear();
    _selectGroup(group);
    Get.snackbar('创建成功', '已创建 ${group.name}');
  }

  Future<void> joinGroup() async {
    if (!_ensureReady()) {
      return;
    }
    final code = inviteCodeController.text.trim();
    if (code.isEmpty) {
      Get.snackbar('邀请码为空', '请输入小组邀请码');
      return;
    }
    final group = await _groupSyncApi.joinGroup(code);
    if (group == null) {
      Get.snackbar('加入失败', '未找到对应小组');
      return;
    }
    inviteCodeController.clear();
    _selectGroup(group);
    Get.snackbar('加入成功', '已加入 ${group.name}');
  }

  Future<void> copyInviteCode(String code) async {
    await Clipboard.setData(ClipboardData(text: code));
    Get.snackbar('已复制', '邀请码 $code');
  }

  void selectGroup(GroupInfo group) {
    _selectGroup(group);
  }

  void _selectGroup(GroupInfo group) {
    selectedGroup.value = group;
    _shareSub?.cancel();
    _shareSub = _groupSyncApi.watchShares(group.id).listen((records) {
      shares.assignAll(records);
    });
  }

  void _syncSelection(List<GroupInfo> items) {
    final current = selectedGroup.value;
    if (current == null) {
      if (items.isNotEmpty) {
        _selectGroup(items.first);
      }
      return;
    }
    GroupInfo? match;
    for (final item in items) {
      if (item.id == current.id) {
        match = item;
        break;
      }
    }
    if (match == null) {
      selectedGroup.value = null;
      shares.clear();
      if (items.isNotEmpty) {
        _selectGroup(items.first);
      }
      return;
    }
    selectedGroup.value = match;
  }

  bool _ensureReady() {
    if (!isAiMode) {
      Get.snackbar('需要切换模式', '请先切换到 AI 模式');
      return false;
    }
    if (session.value == null) {
      Get.snackbar('请先登录', '登录后才能创建或加入小组');
      return false;
    }
    return true;
  }
}
