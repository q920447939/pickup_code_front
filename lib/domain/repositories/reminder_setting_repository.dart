import 'package:pickup_code_front/domain/entities/app_mode.dart';
import 'package:pickup_code_front/domain/entities/reminder_setting.dart';

abstract class ReminderSettingRepository {
  Stream<ReminderSetting?> watch({AppMode mode = AppMode.offline});
  Future<ReminderSetting?> fetch({AppMode mode = AppMode.offline});
  Future<void> upsert(
    ReminderSetting setting, {
    AppMode mode = AppMode.offline,
  });
  Future<void> clear({AppMode mode = AppMode.offline});
}
