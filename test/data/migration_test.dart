import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pickup_code_front/data/database/app_database.dart';
import 'package:pickup_code_front/data/repositories/drift_pickup_repository.dart';
import '../helpers/sqlite3_override.dart';
import 'package:sqlite3/sqlite3.dart';

void main() {
  setUpAll(overrideSqlite3);

  test('migrates from v1 to v2', () async {
    final sqlite = sqlite3.openInMemory();

    sqlite.execute('''
CREATE TABLE pickup_items (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  code TEXT NOT NULL,
  station_name TEXT NULL,
  expire_at INTEGER NULL,
  status INTEGER NOT NULL DEFAULT 0,
  source INTEGER NOT NULL DEFAULT 2,
  note TEXT NULL,
  mode INTEGER NOT NULL DEFAULT 0,
  created_at INTEGER NOT NULL DEFAULT (strftime('%s','now') * 1000)
);
''');

    sqlite.execute(
        'CREATE UNIQUE INDEX pickup_items_code_mode ON pickup_items (code, mode);');

    sqlite.execute('''
CREATE TABLE template_rules (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  name TEXT NULL,
  sample_text TEXT NOT NULL,
  rule_payload TEXT NOT NULL,
  is_enabled INTEGER NOT NULL DEFAULT 1,
  mode INTEGER NOT NULL DEFAULT 0,
  created_at INTEGER NOT NULL DEFAULT (strftime('%s','now') * 1000)
);
''');

    sqlite.execute('''
CREATE TABLE reminder_settings (
  id INTEGER NOT NULL DEFAULT 1,
  is_enabled INTEGER NOT NULL DEFAULT 1,
  remind_before_minutes INTEGER NULL,
  fixed_time_minutes INTEGER NULL,
  quiet_hours_start_minutes INTEGER NULL,
  quiet_hours_end_minutes INTEGER NULL,
  mode INTEGER NOT NULL DEFAULT 0,
  PRIMARY KEY (id, mode)
);
''');

    sqlite.execute('PRAGMA user_version = 1;');

    sqlite.execute(
        "INSERT INTO pickup_items (code, status, source, mode, created_at) VALUES ('A1', 0, 2, 0, 0);");

    final executor = NativeDatabase.opened(sqlite);
    final db = AppDatabase(executor);
    final repository = DriftPickupRepository(db);

    final userVersion =
        await db.customSelect('PRAGMA user_version').getSingle();
    expect(userVersion.read<int>('user_version'), 2);

    final columns = await db
        .customSelect("PRAGMA table_info('pickup_items')")
        .get();
    final hasUpdatedAt =
        columns.any((row) => row.read<String>('name') == 'updated_at');
    expect(hasUpdatedAt, isTrue);

    final fetched = await repository.fetchByCode('A1');
    expect(fetched, isNotNull);

    await db.close();
  });
}
