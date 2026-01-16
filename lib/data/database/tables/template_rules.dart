import 'package:drift/drift.dart';
import 'package:pickup_code_front/domain/entities/app_mode.dart';

@DataClassName('TemplateRuleRow')
class TemplateRules extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().nullable()();
  TextColumn get sampleText => text()();
  TextColumn get rulePayload => text()();
  BoolColumn get isEnabled => boolean().withDefault(const Constant(true))();
  IntColumn get mode => intEnum<AppMode>().withDefault(const Constant(0))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt =>
      dateTime().withDefault(Constant(DateTime(1970)))();
}
