import 'package:get/get.dart';
import 'package:pickup_code_front/domain/apis/group_sync_api.dart';
import 'package:pickup_code_front/modules/group/group_controller.dart';
import 'package:pickup_code_front/modules/mode/mode_controller.dart';

class GroupBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
      () => GroupController(
        groupSyncApi: Get.find<GroupSyncApi>(),
        modeController: Get.find<ModeController>(),
      ),
    );
  }
}
