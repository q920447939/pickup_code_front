import 'package:get/get.dart';
import 'package:pickup_code_front/domain/repositories/template_rule_repository.dart';
import 'package:pickup_code_front/modules/mode/mode_controller.dart';
import 'package:pickup_code_front/modules/templates/templates_controller.dart';

class TemplatesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
      () => TemplatesController(
        templateRuleRepository: Get.find<TemplateRuleRepository>(),
        modeController: Get.find<ModeController>(),
      ),
    );
  }
}
