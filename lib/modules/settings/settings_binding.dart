import 'package:get/get.dart';
import 'package:pickup_code_front/app/services/widget_preference_service.dart';
import 'package:pickup_code_front/modules/settings/settings_controller.dart';

class SettingsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
      () => SettingsController(
        widgetPreferenceService: Get.find<WidgetPreferenceService>(),
      ),
    );
  }
}
