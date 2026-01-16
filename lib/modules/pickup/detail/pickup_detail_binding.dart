import 'package:get/get.dart';
import 'package:pickup_code_front/domain/repositories/pickup_repository.dart';
import 'package:pickup_code_front/domain/usecases/parse_pickup_message_usecase.dart';
import 'package:pickup_code_front/domain/usecases/save_template_rule_usecase.dart';
import 'package:pickup_code_front/modules/mode/mode_controller.dart';
import 'package:pickup_code_front/modules/pickup/detail/pickup_detail_controller.dart';
import 'package:pickup_code_front/domain/apis/group_sync_api.dart';

class PickupDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
      () => PickupDetailController(
        pickupRepository: Get.find<PickupRepository>(),
        parseUseCase: Get.find<ParsePickupMessageUseCase>(),
        saveTemplateRuleUseCase: Get.find<SaveTemplateRuleUseCase>(),
        modeController: Get.find<ModeController>(),
        groupSyncApi: Get.find<GroupSyncApi>(),
      ),
    );
  }
}
