import 'package:drift/drift.dart';
import 'package:pickup_code_front/data/database/app_database.dart';
import 'package:pickup_code_front/domain/entities/app_mode.dart';
import 'package:pickup_code_front/domain/entities/reminder_setting.dart';
import 'package:pickup_code_front/domain/repositories/reminder_setting_repository.dart';

class DriftReminderSettingRepository implements ReminderSettingRepository {
  DriftReminderSettingRepository(this._db);

  final AppDatabase _db;

  @override
  Stream<ReminderSetting?> watch({AppMode mode = AppMode.offline}) {
    final query = _db.select(_db.reminderSettings)
      ..where((tbl) => tbl.mode.equalsValue(mode) & tbl.id.equals(1))
      ..limit(1);
    return query.watchSingleOrNull().map(_mapToDomain);
  }

  @override
  Future<ReminderSetting?> fetch({AppMode mode = AppMode.offline}) async {
    final query = _db.select(_db.reminderSettings)
      ..where((tbl) => tbl.mode.equalsValue(mode) & tbl.id.equals(1))
      ..limit(1);
    final row = await query.getSingleOrNull();
    return _mapToDomain(row);
  }

  @override
  Future<void> upsert(
    ReminderSetting setting, {
    AppMode mode = AppMode.offline,
  }) {
    final updatedAt = DateTime.now();
    return _db
        .into(_db.reminderSettings)
        .insert(
          _toCompanion(setting, mode: mode, updatedAt: updatedAt),
          mode: InsertMode.insertOrReplace,
        );
  }

  @override
  Future<void> clear({AppMode mode = AppMode.offline}) {
    return (_db.delete(
      _db.reminderSettings,
    )..where((tbl) => tbl.mode.equalsValue(mode) & tbl.id.equals(1))).go();
  }

  ReminderSetting? _mapToDomain(ReminderSettingRow? row) {
    if (row == null) {
      return null;
    }
    return ReminderSetting(
      id: row.id,
      isEnabled: row.isEnabled,
      remindBeforeMinutes: row.remindBeforeMinutes,
      fixedTimeMinutes: row.fixedTimeMinutes,
      quietHoursStartMinutes: row.quietHoursStartMinutes,
      quietHoursEndMinutes: row.quietHoursEndMinutes,
      mode: row.mode,
      updatedAt: row.updatedAt,
    );
  }

  ReminderSettingsCompanion _toCompanion(
    ReminderSetting setting, {
    required AppMode mode,
    required DateTime updatedAt,
  }) {
    return ReminderSettingsCompanion(
      id: Value(setting.id),
      isEnabled: Value(setting.isEnabled),
      remindBeforeMinutes: Value(setting.remindBeforeMinutes),
      fixedTimeMinutes: Value(setting.fixedTimeMinutes),
      quietHoursStartMinutes: Value(setting.quietHoursStartMinutes),
      quietHoursEndMinutes: Value(setting.quietHoursEndMinutes),
      mode: Value(mode),
      updatedAt: Value(updatedAt),
    );
  }
}
