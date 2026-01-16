import 'package:pickup_code_front/domain/entities/app_mode.dart';
import 'package:pickup_code_front/domain/entities/template_rule.dart';
import 'package:pickup_code_front/domain/repositories/template_rule_repository.dart';
import 'package:pickup_code_front/domain/usecases/template_rule_builder.dart';

class SaveTemplateRuleUseCase {
  SaveTemplateRuleUseCase({
    required TemplateRuleRepository templateRuleRepository,
    TemplateRuleBuilder? builder,
  }) : _templateRuleRepository = templateRuleRepository,
       _builder = builder ?? TemplateRuleBuilder();

  final TemplateRuleRepository _templateRuleRepository;
  final TemplateRuleBuilder _builder;

  Future<int?> execute({
    required String sampleText,
    required String code,
    String? station,
    String? expireText,
    String? name,
    bool enabled = true,
    AppMode mode = AppMode.offline,
  }) async {
    final trimmedSample = sampleText.trim();
    final trimmedCode = code.trim();
    if (trimmedSample.isEmpty || trimmedCode.isEmpty) {
      return null;
    }

    final payload = _builder.buildFromSample(
      sampleText: trimmedSample,
      code: trimmedCode,
      station: station,
      expireText: expireText,
    );

    if (!payload.pattern.contains('(?<code>')) {
      return null;
    }

    final rule = TemplateRule(
      name: name,
      sampleText: trimmedSample,
      rulePayload: payload.toJsonString(),
      isEnabled: enabled,
      mode: mode,
    );

    return _templateRuleRepository.upsertRule(rule, mode: mode);
  }
}
