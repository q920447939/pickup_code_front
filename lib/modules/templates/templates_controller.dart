import 'dart:async';

import 'package:get/get.dart';
import 'package:pickup_code_front/domain/entities/app_mode.dart';
import 'package:pickup_code_front/domain/entities/template_rule.dart';
import 'package:pickup_code_front/domain/repositories/template_rule_repository.dart';
import 'package:pickup_code_front/modules/mode/mode_controller.dart';

class TemplatesController extends GetxController {
  TemplatesController({
    required TemplateRuleRepository templateRuleRepository,
    required ModeController modeController,
  }) : _templateRuleRepository = templateRuleRepository,
       _modeController = modeController;

  final TemplateRuleRepository _templateRuleRepository;
  final ModeController _modeController;

  final RxList<TemplateRule> rules = <TemplateRule>[].obs;
  StreamSubscription<List<TemplateRule>>? _subscription;
  late final Worker _modeWorker;

  @override
  void onInit() {
    super.onInit();
    _subscribe(_modeController.current.value);
    _modeWorker = ever<AppMode>(_modeController.current, _subscribe);
  }

  @override
  void onClose() {
    _subscription?.cancel();
    _modeWorker.dispose();
    super.onClose();
  }

  AppMode get mode => _modeController.current.value;

  Future<void> toggleEnabled(TemplateRule rule, bool enabled) async {
    final updated = rule.copyWith(isEnabled: enabled);
    await _templateRuleRepository.upsertRule(updated, mode: mode);
  }

  Future<void> deleteRule(TemplateRule rule) async {
    if (rule.id == null) {
      return;
    }
    await _templateRuleRepository.deleteRule(rule.id!, mode: mode);
  }

  void _subscribe(AppMode mode) {
    _subscription?.cancel();
    _subscription = _templateRuleRepository.watchAll(mode: mode).listen((
      items,
    ) {
      rules.assignAll(items);
    });
  }
}
