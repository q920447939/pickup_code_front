import 'package:drift/drift.dart';
import 'package:pickup_code_front/data/database/app_database.dart';
import 'package:pickup_code_front/domain/entities/app_mode.dart';
import 'package:pickup_code_front/domain/entities/template_rule.dart';
import 'package:pickup_code_front/domain/repositories/template_rule_repository.dart';

class DriftTemplateRuleRepository implements TemplateRuleRepository {
  DriftTemplateRuleRepository(this._db);

  final AppDatabase _db;

  @override
  Stream<List<TemplateRule>> watchAll({AppMode mode = AppMode.offline}) {
    final query = _db.select(_db.templateRules)
      ..where((tbl) => tbl.mode.equalsValue(mode))
      ..orderBy([
        (tbl) =>
            OrderingTerm(expression: tbl.createdAt, mode: OrderingMode.desc),
      ]);
    return query.watch().map((rows) => rows.map(_mapToDomain).toList());
  }

  @override
  Future<TemplateRule?> fetchById(int id, {AppMode mode = AppMode.offline}) {
    final query = _db.select(_db.templateRules)
      ..where((tbl) => tbl.id.equals(id) & tbl.mode.equalsValue(mode))
      ..limit(1);
    return query.getSingleOrNull().then((row) {
      if (row == null) {
        return null;
      }
      return _mapToDomain(row);
    });
  }

  @override
  Future<int> upsertRule(
    TemplateRule rule, {
    AppMode mode = AppMode.offline,
  }) async {
    final updatedAt = DateTime.now();
    if (rule.id == null) {
      return _db
          .into(_db.templateRules)
          .insert(
            _toCompanion(
              rule,
              mode: mode,
              updatedAt: updatedAt,
              includeCreatedAt: true,
            ),
          );
    }

    await (_db.update(
          _db.templateRules,
        )..where((tbl) => tbl.id.equals(rule.id!) & tbl.mode.equalsValue(mode)))
        .write(_toCompanion(rule, mode: mode, updatedAt: updatedAt));
    return rule.id!;
  }

  @override
  Future<void> deleteRule(int id, {AppMode mode = AppMode.offline}) {
    return (_db.delete(
      _db.templateRules,
    )..where((tbl) => tbl.id.equals(id) & tbl.mode.equalsValue(mode))).go();
  }

  TemplateRule _mapToDomain(TemplateRuleRow row) {
    return TemplateRule(
      id: row.id,
      name: row.name,
      sampleText: row.sampleText,
      rulePayload: row.rulePayload,
      isEnabled: row.isEnabled,
      mode: row.mode,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
    );
  }

  TemplateRulesCompanion _toCompanion(
    TemplateRule rule, {
    required AppMode mode,
    required DateTime updatedAt,
    bool includeCreatedAt = false,
  }) {
    return TemplateRulesCompanion(
      name: Value(rule.name),
      sampleText: Value(rule.sampleText),
      rulePayload: Value(rule.rulePayload),
      isEnabled: Value(rule.isEnabled),
      mode: Value(mode),
      updatedAt: Value(updatedAt),
      createdAt: includeCreatedAt ? Value(updatedAt) : const Value.absent(),
    );
  }
}
