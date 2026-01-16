import 'package:get/get.dart';
import 'package:pickup_code_front/modules/mode/mode_controller.dart';

class ModeBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<ModeController>()) {
      Get.put(ModeController(), permanent: true);
    }
  }
}
