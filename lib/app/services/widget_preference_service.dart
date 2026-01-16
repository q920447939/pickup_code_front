import 'package:get/get.dart';
import 'package:home_widget/home_widget.dart';
import 'package:pickup_code_front/app/services/widget_constants.dart';

class WidgetPreferenceService extends GetxService {
  final RxBool hideCode = true.obs;
  bool _initialized = false;

  Future<WidgetPreferenceService> init() async {
    await _ensureInitialized();
    final stored = await HomeWidget.getWidgetData<bool>(
      WidgetConstants.hideCodeKey,
      defaultValue: true,
    );
    hideCode.value = stored ?? true;
    return this;
  }

  Future<void> setHideCode(bool value) async {
    await _ensureInitialized();
    hideCode.value = value;
    await HomeWidget.saveWidgetData<bool>(WidgetConstants.hideCodeKey, value);
  }

  Future<void> _ensureInitialized() async {
    if (_initialized) {
      return;
    }
    await HomeWidget.setAppGroupId(WidgetConstants.appGroupId);
    _initialized = true;
  }
}
