import 'package:pickup_code_front/domain/entities/app_mode.dart';
import 'package:pickup_code_front/domain/entities/pickup_parse_result.dart';
import 'package:pickup_code_front/domain/repositories/template_rule_repository.dart';
import 'package:pickup_code_front/domain/usecases/pickup_parse_engine.dart';

class ParsePickupMessageUseCase {
  ParsePickupMessageUseCase({
    required TemplateRuleRepository templateRuleRepository,
    PickupParseEngine? engine,
  }) : _templateRuleRepository = templateRuleRepository,
       _engine = engine ?? PickupParseEngine();

  final TemplateRuleRepository _templateRuleRepository;
  final PickupParseEngine _engine;

  Future<PickupParseResult?> execute(
    String text, {
    AppMode mode = AppMode.offline,
    DateTime? now,
  }) async {
    final templates = await _templateRuleRepository.watchAll(mode: mode).first;
    return _engine.parse(text, now: now, templates: templates);
  }
}
