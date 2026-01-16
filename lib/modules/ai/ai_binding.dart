import 'package:get/get.dart';
import 'package:pickup_code_front/domain/apis/ai_extract_api.dart';
import 'package:pickup_code_front/domain/repositories/pickup_repository.dart';
import 'package:pickup_code_front/modules/ai/ai_controller.dart';
import 'package:pickup_code_front/modules/mode/mode_controller.dart';

class AiBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
      () => AiController(
        aiExtractApi: Get.find<AiExtractApi>(),
        pickupRepository: Get.find<PickupRepository>(),
        modeController: Get.find<ModeController>(),
      ),
    );
  }
}
