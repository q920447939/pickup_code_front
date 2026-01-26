import 'dart:async';

import 'package:get/get.dart';
import 'package:pickup_code_front/domain/apis/ai_extract_api.dart';
import 'package:pickup_code_front/domain/apis/group_sync_api.dart';
import 'package:pickup_code_front/data/database/app_database.dart';
import 'package:pickup_code_front/data/fake/fake_ai_extract_api.dart';
import 'package:pickup_code_front/data/fake/fake_group_sync_api.dart';
import 'package:pickup_code_front/data/repositories/drift_pickup_repository.dart';
import 'package:pickup_code_front/data/repositories/drift_reminder_setting_repository.dart';
import 'package:pickup_code_front/data/repositories/drift_template_rule_repository.dart';
import 'package:pickup_code_front/app/services/widget_link_service.dart';
import 'package:pickup_code_front/app/services/widget_preference_service.dart';
import 'package:pickup_code_front/app/services/widget_service.dart';
import 'package:pickup_code_front/app/services/widget_sync_service.dart';
import 'package:pickup_code_front/app/services/sms_permission_service.dart';
import 'package:pickup_code_front/app/services/sms_foreground_service.dart';
import 'package:pickup_code_front/domain/repositories/pickup_repository.dart';
import 'package:pickup_code_front/domain/repositories/reminder_setting_repository.dart';
import 'package:pickup_code_front/domain/repositories/template_rule_repository.dart';
import 'package:pickup_code_front/domain/usecases/parse_pickup_message_usecase.dart';
import 'package:pickup_code_front/domain/usecases/save_template_rule_usecase.dart';
import 'package:pickup_code_front/modules/mode/mode_controller.dart';

class AppBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(ModeController(), permanent: true);
    Get.put(AppDatabase(), permanent: true);

    Get.put<PickupRepository>(
      DriftPickupRepository(Get.find<AppDatabase>()),
      permanent: true,
    );
    Get.put<TemplateRuleRepository>(
      DriftTemplateRuleRepository(Get.find<AppDatabase>()),
      permanent: true,
    );
    Get.put<ReminderSettingRepository>(
      DriftReminderSettingRepository(Get.find<AppDatabase>()),
      permanent: true,
    );

    Get.put<AiExtractApi>(
      FakeAiExtractApi(
        templateRuleRepository: Get.find<TemplateRuleRepository>(),
      ),
      permanent: true,
    );
    Get.put<GroupSyncApi>(FakeGroupSyncApi(), permanent: true);

    Get.put(
      ParsePickupMessageUseCase(
        templateRuleRepository: Get.find<TemplateRuleRepository>(),
      ),
      permanent: true,
    );

    Get.put(
      SaveTemplateRuleUseCase(
        templateRuleRepository: Get.find<TemplateRuleRepository>(),
      ),
      permanent: true,
    );

    final widgetService = Get.put(WidgetService(), permanent: true);
    unawaited(widgetService.init());
    final widgetPreferenceService = Get.put(
      WidgetPreferenceService(),
      permanent: true,
    );
    unawaited(widgetPreferenceService.init());
    final widgetSyncService = Get.put(
      WidgetSyncService(
        pickupRepository: Get.find<PickupRepository>(),
        modeController: Get.find<ModeController>(),
        widgetService: widgetService,
        widgetPreferenceService: widgetPreferenceService,
      ),
      permanent: true,
    );
    unawaited(widgetSyncService.init());
    final widgetLinkService = Get.put(
      WidgetLinkService(
        pickupRepository: Get.find<PickupRepository>(),
        modeController: Get.find<ModeController>(),
      ),
      permanent: true,
    );
    unawaited(widgetLinkService.init());

    unawaited(SmsPermissionService().init());
    unawaited(SmsForegroundService().init());
  }
}
