class WidgetConstants {
  static const String appGroupId = 'group.com.example.pickupCodeFront';
  static const String iOSWidgetName = 'PickupWidget';
  static const String androidWidgetName = 'PickupWidgetProvider';

  static const String pendingCountKey = 'widget_pending_count';
  static const String hideCodeKey = 'widget_hide_code';

  static const int maxItems = 3;

  static String codeDisplayKey(int index) =>
      'widget_item_${index}_code_display';
  static String codeRawKey(int index) => 'widget_item_${index}_code_raw';
  static String stationKey(int index) => 'widget_item_${index}_station';
  static String expireKey(int index) => 'widget_item_${index}_expire';
}

class WidgetDeepLink {
  static const String scheme = 'pickup';
  static const String listHost = 'list';
  static const String detailHost = 'detail';

  static Uri listUri() => Uri(scheme: scheme, host: listHost);

  static Uri detailUri(String code) =>
      Uri(scheme: scheme, host: detailHost, queryParameters: {'code': code});
}
