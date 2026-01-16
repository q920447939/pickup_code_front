import 'package:drift/drift.dart';
import 'package:pickup_code_front/data/database/connection.dart';
import 'package:pickup_code_front/data/database/tables/pickup_items.dart';
import 'package:pickup_code_front/data/database/tables/reminder_settings.dart';
import 'package:pickup_code_front/data/database/tables/template_rules.dart';
import 'package:pickup_code_front/domain/entities/app_mode.dart';
import 'package:pickup_code_front/domain/entities/pickup.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [PickupItems, TemplateRules, ReminderSettings])
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor]) : super(executor ?? openConnection());

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (migrator) async {
      await migrator.createAll();
    },
    onUpgrade: (migrator, from, to) async {
      if (from < 2) {
        await migrator.addColumn(pickupItems, pickupItems.updatedAt);
        await migrator.addColumn(templateRules, templateRules.updatedAt);
        await migrator.addColumn(reminderSettings, reminderSettings.updatedAt);
      }
    },
  );
}
