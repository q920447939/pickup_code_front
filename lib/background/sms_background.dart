import 'dart:ui';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:pickup_code_front/data/database/app_database.dart';
import 'package:pickup_code_front/data/repositories/drift_pickup_repository.dart';
import 'package:pickup_code_front/data/repositories/drift_template_rule_repository.dart';
import 'package:pickup_code_front/domain/entities/app_mode.dart';
import 'package:pickup_code_front/domain/entities/pickup.dart';
import 'package:pickup_code_front/domain/usecases/ingest_pickup_message_usecase.dart';

const String _smsChannel = 'pickup_code_front/sms_background';

@pragma('vm:entry-point')
Future<void> smsBackgroundMain() async {
  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();

  final channel = MethodChannel(_smsChannel);
  final database = AppDatabase();
  final pickupRepository = DriftPickupRepository(database);
  final templateRepository = DriftTemplateRuleRepository(database);
  final ingestUseCase = IngestPickupMessageUseCase(
    pickupRepository: pickupRepository,
    templateRuleRepository: templateRepository,
  );

  channel.setMethodCallHandler((call) async {
    if (call.method != 'onSmsReceived') {
      return false;
    }
    final args = call.arguments;
    String? message;
    if (args is Map) {
      message = args['message'] as String?;
    } else if (args is String) {
      message = args;
    }
    final trimmed = message?.trim() ?? '';
    if (trimmed.isEmpty) {
      await database.close();
      return false;
    }
    await ingestUseCase.execute(
      trimmed,
      mode: AppMode.offline,
      source: PickupSource.smsAuto,
    );
    await database.close();
    return true;
  });

  try {
    await channel.invokeMethod<void>('ready');
  } catch (_) {
    await database.close();
  }
}
