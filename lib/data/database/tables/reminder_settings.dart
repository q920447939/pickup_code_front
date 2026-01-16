import 'package:drift/drift.dart';
import 'package:pickup_code_front/domain/entities/app_mode.dart';

@DataClassName('ReminderSettingRow')
class ReminderSettings extends Table {
  IntColumn get id => integer().withDefault(const Constant(1))();
  BoolColumn get isEnabled => boolean().withDefault(const Constant(true))();
  IntColumn get remindBeforeMinutes => integer().nullable()();
  IntColumn get fixedTimeMinutes => integer().nullable()();
  IntColumn get quietHoursStartMinutes => integer().nullable()();
  IntColumn get quietHoursEndMinutes => integer().nullable()();
  IntColumn get mode => intEnum<AppMode>().withDefault(const Constant(0))();
  DateTimeColumn get updatedAt =>
      dateTime().withDefault(Constant(DateTime(1970)))();

  @override
  Set<Column> get primaryKey => {id, mode};
}
