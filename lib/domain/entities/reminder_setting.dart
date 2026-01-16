import 'package:pickup_code_front/domain/entities/app_mode.dart';

class ReminderSetting {
  const ReminderSetting({
    this.id = 1,
    this.isEnabled = true,
    this.remindBeforeMinutes,
    this.fixedTimeMinutes,
    this.quietHoursStartMinutes,
    this.quietHoursEndMinutes,
    this.mode = AppMode.offline,
    this.updatedAt,
  });

  final int id;
  final bool isEnabled;
  final int? remindBeforeMinutes;
  final int? fixedTimeMinutes;
  final int? quietHoursStartMinutes;
  final int? quietHoursEndMinutes;
  final AppMode mode;
  final DateTime? updatedAt;

  ReminderSetting copyWith({
    int? id,
    bool? isEnabled,
    int? remindBeforeMinutes,
    int? fixedTimeMinutes,
    int? quietHoursStartMinutes,
    int? quietHoursEndMinutes,
    AppMode? mode,
    DateTime? updatedAt,
  }) {
    return ReminderSetting(
      id: id ?? this.id,
      isEnabled: isEnabled ?? this.isEnabled,
      remindBeforeMinutes: remindBeforeMinutes ?? this.remindBeforeMinutes,
      fixedTimeMinutes: fixedTimeMinutes ?? this.fixedTimeMinutes,
      quietHoursStartMinutes:
          quietHoursStartMinutes ?? this.quietHoursStartMinutes,
      quietHoursEndMinutes: quietHoursEndMinutes ?? this.quietHoursEndMinutes,
      mode: mode ?? this.mode,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
