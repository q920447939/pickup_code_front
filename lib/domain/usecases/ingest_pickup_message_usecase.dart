import 'package:pickup_code_front/domain/entities/app_mode.dart';
import 'package:pickup_code_front/domain/entities/pickup.dart';
import 'package:pickup_code_front/domain/repositories/pickup_repository.dart';
import 'package:pickup_code_front/domain/repositories/template_rule_repository.dart';
import 'package:pickup_code_front/domain/usecases/parse_pickup_message_usecase.dart';

class IngestPickupMessageUseCase {
  IngestPickupMessageUseCase({
    required PickupRepository pickupRepository,
    required TemplateRuleRepository templateRuleRepository,
    Duration? dedupWindow,
  }) : _pickupRepository = pickupRepository,
       _parseUseCase = ParsePickupMessageUseCase(
         templateRuleRepository: templateRuleRepository,
       ),
       _dedupWindow = dedupWindow ?? const Duration(minutes: 5);

  final PickupRepository _pickupRepository;
  final ParsePickupMessageUseCase _parseUseCase;
  final Duration _dedupWindow;

  Future<Pickup?> execute(
    String text, {
    AppMode mode = AppMode.offline,
    PickupSource source = PickupSource.smsAuto,
    DateTime? now,
  }) async {
    final currentTime = now ?? DateTime.now();
    final parseResult = await _parseUseCase.execute(
      text,
      mode: mode,
      now: currentTime,
    );
    if (parseResult == null || !parseResult.isValid) {
      return null;
    }

    final existing = await _pickupRepository.fetchByCode(
      parseResult.code!,
      mode: mode,
    );
    if (existing?.updatedAt != null) {
      final difference = currentTime.difference(existing!.updatedAt!).abs();
      if (difference <= _dedupWindow) {
        return existing;
      }
    }

    final pickup = Pickup(
      code: parseResult.code!,
      stationName: parseResult.stationName,
      expireAt: parseResult.expireAt,
      status: PickupStatus.pending,
      source: source,
    );
    await _pickupRepository.upsertPickup(pickup, mode: mode);
    return pickup;
  }
}
