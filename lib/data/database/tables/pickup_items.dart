import 'package:drift/drift.dart';
import 'package:pickup_code_front/domain/entities/app_mode.dart';
import 'package:pickup_code_front/domain/entities/pickup.dart';

class PickupItems extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get code => text()();
  TextColumn get stationName => text().nullable()();
  DateTimeColumn get expireAt => dateTime().nullable()();
  IntColumn get status =>
      intEnum<PickupStatus>().withDefault(const Constant(0))();
  IntColumn get source =>
      intEnum<PickupSource>().withDefault(const Constant(2))();
  TextColumn get note => text().nullable()();
  IntColumn get mode => intEnum<AppMode>().withDefault(const Constant(0))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt =>
      dateTime().withDefault(Constant(DateTime(1970)))();

  @override
  List<Set<Column>> get uniqueKeys => [
    {code, mode},
  ];
}
