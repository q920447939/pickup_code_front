import 'package:get/get.dart';
import 'package:pickup_code_front/app/routes/app_routes.dart';
import 'package:pickup_code_front/modules/ai/ai_binding.dart';
import 'package:pickup_code_front/modules/ai/ai_page.dart';
import 'package:pickup_code_front/modules/group/group_binding.dart';
import 'package:pickup_code_front/modules/group/group_page.dart';
import 'package:pickup_code_front/modules/mode/mode_binding.dart';
import 'package:pickup_code_front/modules/mode/mode_page.dart';
import 'package:pickup_code_front/modules/pickup/detail/pickup_detail_binding.dart';
import 'package:pickup_code_front/modules/pickup/detail/pickup_detail_page.dart';
import 'package:pickup_code_front/modules/pickup/list/pickup_list_binding.dart';
import 'package:pickup_code_front/modules/pickup/list/pickup_list_page.dart';
import 'package:pickup_code_front/modules/settings/settings_binding.dart';
import 'package:pickup_code_front/modules/settings/settings_page.dart';
import 'package:pickup_code_front/modules/templates/templates_binding.dart';
import 'package:pickup_code_front/modules/templates/templates_page.dart';

class AppPages {
  static const initial = Routes.pickupList;

  static final pages = <GetPage>[
    GetPage(
      name: Routes.pickupList,
      page: PickupListPage.new,
      binding: PickupListBinding(),
    ),
    GetPage(
      name: Routes.pickupDetail,
      page: PickupDetailPage.new,
      binding: PickupDetailBinding(),
    ),
    GetPage(
      name: Routes.templates,
      page: TemplatesPage.new,
      binding: TemplatesBinding(),
    ),
    GetPage(
      name: Routes.settings,
      page: SettingsPage.new,
      binding: SettingsBinding(),
    ),
    GetPage(name: Routes.mode, page: ModePage.new, binding: ModeBinding()),
    GetPage(name: Routes.ai, page: AiPage.new, binding: AiBinding()),
    GetPage(name: Routes.group, page: GroupPage.new, binding: GroupBinding()),
  ];
}
