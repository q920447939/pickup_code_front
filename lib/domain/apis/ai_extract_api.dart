import 'package:pickup_code_front/domain/entities/pickup_parse_result.dart';

abstract class AiExtractApi {
  Future<PickupParseResult?> extract(String text, {DateTime? now});
}
