import 'package:pickup_code_front/domain/entities/app_mode.dart';
import 'package:pickup_code_front/domain/entities/template_rule.dart';

abstract class TemplateRuleRepository {
  Stream<List<TemplateRule>> watchAll({AppMode mode = AppMode.offline});
  Future<TemplateRule?> fetchById(int id, {AppMode mode = AppMode.offline});
  Future<int> upsertRule(TemplateRule rule, {AppMode mode = AppMode.offline});
  Future<void> deleteRule(int id, {AppMode mode = AppMode.offline});
}
