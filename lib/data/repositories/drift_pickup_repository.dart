import 'package:drift/drift.dart';
import 'package:pickup_code_front/data/database/app_database.dart';
import 'package:pickup_code_front/domain/entities/app_mode.dart';
import 'package:pickup_code_front/domain/entities/pickup.dart';
import 'package:pickup_code_front/domain/repositories/pickup_repository.dart';

class DriftPickupRepository implements PickupRepository {
  DriftPickupRepository(this._db);

  final AppDatabase _db;

  @override
  Stream<List<Pickup>> watchAll({AppMode mode = AppMode.offline}) {
    final query = _db.select(_db.pickupItems)
      ..where((tbl) => tbl.mode.equalsValue(mode))
      ..orderBy([
        (tbl) =>
            OrderingTerm(expression: tbl.createdAt, mode: OrderingMode.desc),
      ]);
    return query.watch().map((rows) => rows.map(_mapToDomain).toList());
  }

  @override
  Future<Pickup?> fetchByCode(String code, {AppMode mode = AppMode.offline}) {
    final query = _db.select(_db.pickupItems)
      ..where((tbl) => tbl.code.equals(code) & tbl.mode.equalsValue(mode))
      ..limit(1);
    return query.getSingleOrNull().then((row) {
      if (row == null) {
        return null;
      }
      return _mapToDomain(row);
    });
  }

  @override
  Future<void> upsertPickup(
    Pickup pickup, {
    AppMode mode = AppMode.offline,
  }) async {
    final updatedAt = DateTime.now();
    final updateCount =
        await (_db.update(_db.pickupItems)..where(
              (tbl) =>
                  tbl.code.equals(pickup.code) & tbl.mode.equalsValue(mode),
            ))
            .write(_toCompanion(pickup, mode: mode, updatedAt: updatedAt));

    if (updateCount == 0) {
      await _db
          .into(_db.pickupItems)
          .insert(
            _toCompanion(
              pickup,
              mode: mode,
              updatedAt: updatedAt,
              includeCreatedAt: true,
            ),
          );
    }
  }

  @override
  Future<void> deletePickup(String code, {AppMode mode = AppMode.offline}) {
    return (_db.delete(
      _db.pickupItems,
    )..where((tbl) => tbl.code.equals(code) & tbl.mode.equalsValue(mode))).go();
  }

  Pickup _mapToDomain(PickupItem row) {
    return Pickup(
      code: row.code,
      stationName: row.stationName,
      expireAt: row.expireAt,
      status: row.status,
      source: row.source,
      note: row.note,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
    );
  }

  PickupItemsCompanion _toCompanion(
    Pickup pickup, {
    required AppMode mode,
    required DateTime updatedAt,
    bool includeCreatedAt = false,
  }) {
    return PickupItemsCompanion(
      code: Value(pickup.code),
      stationName: Value(pickup.stationName),
      expireAt: Value(pickup.expireAt),
      status: Value(pickup.status),
      source: Value(pickup.source),
      note: Value(pickup.note),
      mode: Value(mode),
      updatedAt: Value(updatedAt),
      createdAt: includeCreatedAt ? Value(updatedAt) : const Value.absent(),
    );
  }
}
