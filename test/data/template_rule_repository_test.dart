import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pickup_code_front/data/database/app_database.dart';
import 'package:pickup_code_front/data/repositories/drift_template_rule_repository.dart';
import 'package:pickup_code_front/domain/entities/template_rule.dart';
import '../helpers/sqlite3_override.dart';

void main() {
  late AppDatabase db;
  late DriftTemplateRuleRepository repository;

  setUpAll(overrideSqlite3);

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    repository = DriftTemplateRuleRepository(db);
  });

  tearDown(() async {
    await db.close();
  });

  test('create, update and delete template rule', () async {
    const rule = TemplateRule(
      name: '默认规则',
      sampleText: '您的取件码1234，请至A站领取',
      rulePayload: '{"code":"\\d+"}',
    );

    final id = await repository.upsertRule(rule);
    expect(id, isPositive);

    final fetched = await repository.fetchById(id);
    expect(fetched, isNotNull);
    expect(fetched!.name, '默认规则');

    final updatedRule = fetched.copyWith(isEnabled: false);
    await repository.upsertRule(updatedRule);

    final updated = await repository.fetchById(id);
    expect(updated, isNotNull);
    expect(updated!.isEnabled, isFalse);

    await repository.deleteRule(id);
    final deleted = await repository.fetchById(id);
    expect(deleted, isNull);
  });
}
