import 'package:flutter/widgets.dart';
import 'package:pickup_code_front/app/app.dart';
// Ensures the background SMS entrypoint library is included in the app bundle
// so Android can launch it via a custom Dart entrypoint.
// ignore: unused_import
import 'package:pickup_code_front/background/sms_background.dart' show smsBackgroundMain;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // Keep the entrypoint reachable for AOT/tree-shaking.
  // ignore: unnecessary_statements
  smsBackgroundMain;
  runApp(const PickupApp());
}
