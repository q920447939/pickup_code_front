import 'package:get/get.dart';
import 'package:pickup_code_front/domain/entities/app_mode.dart';

class ModeController extends GetxController {
  final Rx<AppMode> current = AppMode.offline.obs;

  void switchMode(AppMode mode) {
    current.value = mode;
  }
}
