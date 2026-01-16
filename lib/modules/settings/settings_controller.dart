import 'package:get/get.dart';
import 'package:pickup_code_front/app/services/widget_preference_service.dart';

class SettingsController extends GetxController {
  SettingsController({required WidgetPreferenceService widgetPreferenceService})
    : _widgetPreferenceService = widgetPreferenceService;

  final WidgetPreferenceService _widgetPreferenceService;

  final RxBool hideWidgetCode = true.obs;
  Worker? _worker;

  @override
  void onInit() {
    super.onInit();
    hideWidgetCode.value = _widgetPreferenceService.hideCode.value;
    _worker = ever<bool>(
      _widgetPreferenceService.hideCode,
      (value) => hideWidgetCode.value = value,
    );
  }

  @override
  void onClose() {
    _worker?.dispose();
    super.onClose();
  }

  Future<void> updateHideWidgetCode(bool value) async {
    await _widgetPreferenceService.setHideCode(value);
  }
}
