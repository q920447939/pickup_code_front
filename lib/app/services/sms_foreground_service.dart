import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pickup_code_front/domain/entities/app_mode.dart';
import 'package:pickup_code_front/domain/entities/pickup.dart';
import 'package:pickup_code_front/domain/repositories/pickup_repository.dart';
import 'package:pickup_code_front/domain/repositories/template_rule_repository.dart';
import 'package:pickup_code_front/domain/usecases/ingest_pickup_message_usecase.dart';
import 'package:pickup_code_front/modules/mode/mode_controller.dart';

class SmsForegroundService {
  static const MethodChannel _channel = MethodChannel(
    'pickup_code_front/sms_foreground',
  );

  static bool _initialized = false;

  Future<void> init() async {
    if (_initialized) {
      return;
    }
    _initialized = true;

    if (kIsWeb || defaultTargetPlatform != TargetPlatform.android) {
      return;
    }

    final pickupRepository = Get.find<PickupRepository>();
    final templateRepository = Get.find<TemplateRuleRepository>();
    final modeController = Get.find<ModeController>();
    final ingestUseCase = IngestPickupMessageUseCase(
      pickupRepository: pickupRepository,
      templateRuleRepository: templateRepository,
    );

    _channel.setMethodCallHandler((call) async {
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
        return false;
      }

      try {
        await ingestUseCase.execute(
          trimmed,
          mode: modeController.current.value,
          source: PickupSource.smsAuto,
        );
        return true;
      } catch (e, st) {
        debugPrint('SmsForegroundService ingest failed: $e\n$st');
        return false;
      }
    });
  }
}

