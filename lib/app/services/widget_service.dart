import 'package:get/get.dart';
import 'package:home_widget/home_widget.dart';
import 'package:pickup_code_front/app/services/widget_constants.dart';
import 'package:pickup_code_front/domain/entities/pickup.dart';

class WidgetService extends GetxService {
  bool _initialized = false;

  Future<WidgetService> init() async {
    await _ensureInitialized();
    return this;
  }

  Future<void> updatePickupSummary({
    required List<Pickup> pendingItems,
    required bool hideCode,
  }) async {
    await _ensureInitialized();
    final items = pendingItems.take(WidgetConstants.maxItems).toList();
    await HomeWidget.saveWidgetData<int>(
      WidgetConstants.pendingCountKey,
      pendingItems.length,
    );
    await HomeWidget.saveWidgetData<bool>(
      WidgetConstants.hideCodeKey,
      hideCode,
    );
    for (var i = 0; i < WidgetConstants.maxItems; i += 1) {
      if (i < items.length) {
        final item = items[i];
        final displayCode = hideCode ? _maskedCode(item.code) : item.code;
        await HomeWidget.saveWidgetData<String>(
          WidgetConstants.codeDisplayKey(i),
          displayCode,
        );
        await HomeWidget.saveWidgetData<String>(
          WidgetConstants.codeRawKey(i),
          item.code,
        );
        await HomeWidget.saveWidgetData<String>(
          WidgetConstants.stationKey(i),
          item.stationName ?? '',
        );
        await HomeWidget.saveWidgetData<String>(
          WidgetConstants.expireKey(i),
          _formatExpire(item.expireAt),
        );
      } else {
        await HomeWidget.saveWidgetData<String>(
          WidgetConstants.codeDisplayKey(i),
          '',
        );
        await HomeWidget.saveWidgetData<String>(
          WidgetConstants.codeRawKey(i),
          '',
        );
        await HomeWidget.saveWidgetData<String>(
          WidgetConstants.stationKey(i),
          '',
        );
        await HomeWidget.saveWidgetData<String>(
          WidgetConstants.expireKey(i),
          '',
        );
      }
    }
    await _refreshWidget();
  }

  String _maskedCode(String code) {
    if (code.isEmpty) {
      return '';
    }
    if (code.length <= 4) {
      return '****';
    }
    return '****${code.substring(code.length - 4)}';
  }

  String _formatExpire(DateTime? expireAt) {
    if (expireAt == null) {
      return '';
    }
    final month = expireAt.month.toString().padLeft(2, '0');
    final day = expireAt.day.toString().padLeft(2, '0');
    final hour = expireAt.hour.toString().padLeft(2, '0');
    final minute = expireAt.minute.toString().padLeft(2, '0');
    return '$month-$day $hour:$minute';
  }

  Future<void> _refreshWidget() async {
    await HomeWidget.updateWidget(
      name: WidgetConstants.androidWidgetName,
      iOSName: WidgetConstants.iOSWidgetName,
    );
  }

  Future<void> _ensureInitialized() async {
    if (_initialized) {
      return;
    }
    await HomeWidget.setAppGroupId(WidgetConstants.appGroupId);
    _initialized = true;
  }
}
