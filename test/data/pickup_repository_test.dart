import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pickup_code_front/data/database/app_database.dart';
import 'package:pickup_code_front/data/repositories/drift_pickup_repository.dart';
import 'package:pickup_code_front/domain/entities/pickup.dart';
import '../helpers/sqlite3_override.dart';

void main() {
  late AppDatabase db;
  late DriftPickupRepository repository;

  setUpAll(overrideSqlite3);

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    repository = DriftPickupRepository(db);
  });

  tearDown(() async {
    await db.close();
  });

  test('upsert and fetch pickup', () async {
    const pickup = Pickup(
      code: 'A123',
      stationName: '菜鸟北门',
      source: PickupSource.manual,
    );

    await repository.upsertPickup(pickup);

    final fetched = await repository.fetchByCode('A123');
    expect(fetched, isNotNull);
    expect(fetched!.stationName, '菜鸟北门');
    expect(fetched.status, PickupStatus.pending);

    await repository.upsertPickup(
      pickup.copyWith(status: PickupStatus.picked),
    );

    final updated = await repository.fetchByCode('A123');
    expect(updated, isNotNull);
    expect(updated!.status, PickupStatus.picked);
  });

  test('delete pickup by code', () async {
    const pickup = Pickup(code: 'B456');
    await repository.upsertPickup(pickup);

    await repository.deletePickup('B456');

    final fetched = await repository.fetchByCode('B456');
    expect(fetched, isNull);
  });
}
