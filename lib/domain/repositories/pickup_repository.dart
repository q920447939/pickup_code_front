import 'package:pickup_code_front/domain/entities/app_mode.dart';
import 'package:pickup_code_front/domain/entities/pickup.dart';

abstract class PickupRepository {
  Stream<List<Pickup>> watchAll({AppMode mode = AppMode.offline});
  Future<Pickup?> fetchByCode(String code, {AppMode mode = AppMode.offline});
  Future<void> upsertPickup(Pickup pickup, {AppMode mode = AppMode.offline});
  Future<void> deletePickup(String code, {AppMode mode = AppMode.offline});
}
