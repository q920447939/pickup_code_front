import 'dart:async';

import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pickup_code_front/domain/entities/app_mode.dart';
import 'package:pickup_code_front/domain/entities/pickup.dart';
import 'package:pickup_code_front/domain/repositories/pickup_repository.dart';
import 'package:pickup_code_front/modules/mode/mode_controller.dart';

class PickupListController extends GetxController {
  PickupListController({
    required PickupRepository pickupRepository,
    required ModeController modeController,
  }) : _pickupRepository = pickupRepository,
       _modeController = modeController;

  final PickupRepository _pickupRepository;
  final ModeController _modeController;
  StreamSubscription<List<Pickup>>? _subscription;
  late final Worker _modeWorker;

  final RxList<Pickup> _allPickups = <Pickup>[].obs;
  final RxString keyword = ''.obs;
  final Rx<PickupFilter> filter = PickupFilter.all.obs;
  final RxBool selectionMode = false.obs;
  final RxSet<String> selectedCodes = <String>{}.obs;

  List<Pickup> get pickups => _applyFilters(_allPickups);

  int get pendingCount => _allPickups
      .where(
        (item) =>
            _effectiveStatus(item, DateTime.now()) == PickupStatus.pending,
      )
      .length;

  int get selectedCount => selectedCodes.length;

  @override
  void onInit() {
    super.onInit();
    _subscribe(_modeController.current.value);
    _modeWorker = ever<AppMode>(_modeController.current, _subscribe);
  }

  @override
  void onClose() {
    _subscription?.cancel();
    _modeWorker.dispose();
    super.onClose();
  }

  void updateKeyword(String value) {
    keyword.value = value.trim();
  }

  void clearKeyword() {
    keyword.value = '';
  }

  void enterSelectionMode() {
    selectionMode.value = true;
  }

  void exitSelectionMode() {
    selectionMode.value = false;
    selectedCodes.clear();
  }

  void toggleSelected(Pickup pickup) {
    final code = pickup.code;
    if (selectedCodes.contains(code)) {
      selectedCodes.remove(code);
    } else {
      selectedCodes.add(code);
    }
  }

  void selectAllFiltered() {
    selectedCodes
      ..clear()
      ..addAll(pickups.map((item) => item.code));
  }

  Future<void> deleteSelected() async {
    final codes = selectedCodes.toList();
    if (codes.isEmpty) {
      return;
    }
    for (final code in codes) {
      await _pickupRepository.deletePickup(
        code,
        mode: _modeController.current.value,
      );
    }
    exitSelectionMode();
  }

  void changeFilter(PickupFilter value) {
    filter.value = value;
  }

  int countForFilter(PickupFilter value) {
    final now = DateTime.now();
    return _allPickups.where((item) {
      final status = _effectiveStatus(item, now);
      if (value == PickupFilter.all) {
        return true;
      }
      return status == value.status;
    }).length;
  }

  Future<void> markPicked(Pickup pickup) async {
    final updated = pickup.copyWith(status: PickupStatus.picked);
    await _pickupRepository.upsertPickup(
      updated,
      mode: _modeController.current.value,
    );
  }

  Future<void> markAbnormal(Pickup pickup) async {
    final updated = pickup.copyWith(status: PickupStatus.abnormal);
    await _pickupRepository.upsertPickup(
      updated,
      mode: _modeController.current.value,
    );
  }

  Future<void> copyCode(Pickup pickup) async {
    await Clipboard.setData(ClipboardData(text: pickup.code));
    Get.snackbar('已复制', '取件码 ${pickup.code}');
  }

  PickupStatus effectiveStatus(Pickup pickup, DateTime now) {
    return _effectiveStatus(pickup, now);
  }

  void _subscribe(AppMode mode) {
    _subscription?.cancel();
    _subscription = _pickupRepository.watchAll(mode: mode).listen((items) {
      _allPickups.assignAll(items);
      selectedCodes.removeWhere(
        (code) => !_allPickups.any((pickup) => pickup.code == code),
      );
    });
  }

  List<Pickup> _applyFilters(List<Pickup> input) {
    final now = DateTime.now();
    final keywordValue = keyword.value.trim().toLowerCase();
    final activeFilter = filter.value;
    final filtered = input.where((item) {
      final status = _effectiveStatus(item, now);
      if (activeFilter != PickupFilter.all && status != activeFilter.status) {
        return false;
      }
      if (keywordValue.isEmpty) {
        return true;
      }
      final station = item.stationName ?? '';
      final note = item.note ?? '';
      return item.code.toLowerCase().contains(keywordValue) ||
          station.toLowerCase().contains(keywordValue) ||
          note.toLowerCase().contains(keywordValue);
    }).toList();
    filtered.sort((a, b) {
      final statusA = _effectiveStatus(a, now);
      final statusB = _effectiveStatus(b, now);
      final rank = _statusRank(statusA).compareTo(_statusRank(statusB));
      if (rank != 0) {
        return rank;
      }
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
    return filtered;
  }

  PickupStatus _effectiveStatus(Pickup pickup, DateTime now) {
    if (pickup.status == PickupStatus.pending &&
        pickup.expireAt != null &&
        pickup.expireAt!.isBefore(now)) {
      return PickupStatus.expired;
    }
    return pickup.status;
  }

  int _statusRank(PickupStatus status) {
    switch (status) {
      case PickupStatus.pending:
        return 0;
      case PickupStatus.expired:
        return 1;
      case PickupStatus.abnormal:
        return 2;
      case PickupStatus.picked:
        return 3;
    }
  }
}

enum PickupFilter {
  all,
  pending,
  picked,
  expired,
  abnormal;

  PickupStatus? get status {
    switch (this) {
      case PickupFilter.all:
        return null;
      case PickupFilter.pending:
        return PickupStatus.pending;
      case PickupFilter.picked:
        return PickupStatus.picked;
      case PickupFilter.expired:
        return PickupStatus.expired;
      case PickupFilter.abnormal:
        return PickupStatus.abnormal;
    }
  }
}
