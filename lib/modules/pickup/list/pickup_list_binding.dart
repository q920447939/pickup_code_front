import 'package:get/get.dart';
import 'package:pickup_code_front/domain/repositories/pickup_repository.dart';
import 'package:pickup_code_front/modules/mode/mode_controller.dart';
import 'package:pickup_code_front/modules/pickup/list/pickup_list_controller.dart';

class PickupListBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
      () => PickupListController(
        pickupRepository: Get.find<PickupRepository>(),
        modeController: Get.find<ModeController>(),
      ),
    );
  }
}
