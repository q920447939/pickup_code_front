import 'dart:async';

import 'package:get/get.dart';
import 'package:home_widget/home_widget.dart';
import 'package:pickup_code_front/app/routes/app_routes.dart';
import 'package:pickup_code_front/app/services/widget_constants.dart';
import 'package:pickup_code_front/domain/repositories/pickup_repository.dart';
import 'package:pickup_code_front/modules/mode/mode_controller.dart';

class WidgetLinkService extends GetxService {
  WidgetLinkService({
    required PickupRepository pickupRepository,
    required ModeController modeController,
  }) : _pickupRepository = pickupRepository,
       _modeController = modeController;

  final PickupRepository _pickupRepository;
  final ModeController _modeController;
  StreamSubscription<Uri?>? _subscription;

  Future<WidgetLinkService> init() async {
    _handleLaunch();
    _subscription = HomeWidget.widgetClicked.listen(_handleUri);
    return this;
  }

  @override
  void onClose() {
    _subscription?.cancel();
    super.onClose();
  }

  void _handleLaunch() {
    HomeWidget.initiallyLaunchedFromHomeWidget().then(_handleUri);
  }

  void _handleUri(Uri? uri) {
    if (uri == null) {
      return;
    }
    if (uri.scheme != WidgetDeepLink.scheme) {
      return;
    }
    final host = uri.host;
    if (host == WidgetDeepLink.detailHost) {
      final code = uri.queryParameters['code'];
      if (code == null || code.isEmpty) {
        _openList();
        return;
      }
      _openDetail(code);
      return;
    }
    _openList();
  }

  Future<void> _openDetail(String code) async {
    final mode = _modeController.current.value;
    final pickup = await _pickupRepository.fetchByCode(code, mode: mode);
    if (pickup == null) {
      _openList();
      return;
    }
    await _ensureListRoute();
    await Future<void>.delayed(Duration.zero);
    Get.toNamed(Routes.pickupDetail, arguments: pickup);
  }

  Future<void> _openList() async {
    await _ensureListRoute();
  }

  Future<void> _ensureListRoute() async {
    if (Get.currentRoute != Routes.pickupList) {
      await Get.offAllNamed(Routes.pickupList);
    }
  }
}
