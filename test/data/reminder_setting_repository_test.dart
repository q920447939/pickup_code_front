import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pickup_code_front/data/database/app_database.dart';
import 'package:pickup_code_front/data/repositories/drift_reminder_setting_repository.dart';
import 'package:pickup_code_front/domain/entities/reminder_setting.dart';
import '../helpers/sqlite3_override.dart';

void main() {
  late AppDatabase db;
  late DriftReminderSettingRepository repository;

  setUpAll(overrideSqlite3);

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    repository = DriftReminderSettingRepository(db);
  });

  tearDown(() async {
    await db.close();
  });

  test('upsert and fetch reminder setting', () async {
    const setting = ReminderSetting(
      isEnabled: true,
      remindBeforeMinutes: 120,
      fixedTimeMinutes: 540,
      quietHoursStartMinutes: 1320,
      quietHoursEndMinutes: 420,
    );

    await repository.upsert(setting);

    final fetched = await repository.fetch();
    expect(fetched, isNotNull);
    expect(fetched!.remindBeforeMinutes, 120);

    await repository.clear();
    final cleared = await repository.fetch();
    expect(cleared, isNull);
  });
}
