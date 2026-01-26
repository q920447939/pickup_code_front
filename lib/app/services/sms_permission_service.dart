import 'package:flutter/foundation.dart';
import 'package:permission_handler/permission_handler.dart';

class SmsPermissionService {
  Future<void> init() async {
    if (kIsWeb || defaultTargetPlatform != TargetPlatform.android) {
      return;
    }

    final status = await Permission.sms.status;
    if (status.isGranted) {
      return;
    }

    // Requests all SMS-group permissions declared in AndroidManifest.xml
    // (e.g. RECEIVE_SMS / READ_SMS) via permission_handler's Android plugin.
    await Permission.sms.request();
  }
}

