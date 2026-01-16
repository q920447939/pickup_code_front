import 'dart:async';

import 'package:get/get.dart';
import 'package:pickup_code_front/app/services/widget_preference_service.dart';
import 'package:pickup_code_front/app/services/widget_service.dart';
import 'package:pickup_code_front/domain/entities/app_mode.dart';
import 'package:pickup_code_front/domain/entities/pickup.dart';
import 'package:pickup_code_front/domain/repositories/pickup_repository.dart';
import 'package:pickup_code_front/modules/mode/mode_controller.dart';

class WidgetSyncService extends GetxService {
  WidgetSyncService({
    required PickupRepository pickupRepository,
    required ModeController modeController,
    required WidgetService widgetService,
    required WidgetPreferenceService widgetPreferenceService,
  }) : _pickupRepository = pickupRepository,
       _modeController = modeController,
       _widgetService = widgetService,
       _widgetPreferenceService = widgetPreferenceService;

  final PickupRepository _pickupRepository;
  final ModeController _modeController;
  final WidgetService _widgetService;
  final WidgetPreferenceService _widgetPreferenceService;

  StreamSubscription<List<Pickup>>? _subscription;
  Worker? _modeWorker;
  Worker? _privacyWorker;
  List<Pickup> _latestPending = <Pickup>[];

  Future<WidgetSyncService> init() async {
    _subscribe(_modeController.current.value);
    _modeWorker = ever<AppMode>(_modeController.current, _subscribe);
    _privacyWorker = ever<bool>(
      _widgetPreferenceService.hideCode,
      (_) => _pushUpdate(),
    );
    return this;
  }

  @override
  void onClose() {
    _subscription?.cancel();
    _modeWorker?.dispose();
    _privacyWorker?.dispose();
    super.onClose();
  }

  void _subscribe(AppMode mode) {
    _subscription?.cancel();
    _subscription = _pickupRepository.watchAll(mode: mode).listen((items) {
      _latestPending = _filterPending(items);
      _pushUpdate();
    });
  }

  void _pushUpdate() {
    unawaited(
      _widgetService.updatePickupSummary(
        pendingItems: _latestPending,
        hideCode: _widgetPreferenceService.hideCode.value,
      ),
    );
  }

  List<Pickup> _filterPending(List<Pickup> items) {
    final now = DateTime.now();
    final pending = items
        .where((item) => _effectiveStatus(item, now) == PickupStatus.pending)
        .toList();
    pending.sort((a, b) {
      final expireA = a.expireAt ?? DateTime(2999);
      final expireB = b.expireAt ?? DateTime(2999);
      final expireCompare = expireA.compareTo(expireB);
      if (expireCompare != 0) {
        return expireCompare;
      }
      final createdA = a.createdAt ?? DateTime(1970);
      final createdB = b.createdAt ?? DateTime(1970);
      return createdB.compareTo(createdA);
    });
    return pending;
  }

  PickupStatus _effectiveStatus(Pickup pickup, DateTime now) {
    if (pickup.status == PickupStatus.pending &&
        pickup.expireAt != null &&
        pickup.expireAt!.isBefore(now)) {
      return PickupStatus.expired;
    }
    return pickup.status;
  }
}
