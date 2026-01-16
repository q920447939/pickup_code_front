import 'dart:math';

import 'package:pickup_code_front/domain/apis/ai_extract_api.dart';
import 'package:pickup_code_front/domain/entities/app_mode.dart';
import 'package:pickup_code_front/domain/entities/pickup_parse_result.dart';
import 'package:pickup_code_front/domain/repositories/template_rule_repository.dart';
import 'package:pickup_code_front/domain/usecases/pickup_parse_engine.dart';

class FakeAiExtractApi implements AiExtractApi {
  FakeAiExtractApi({
    required TemplateRuleRepository templateRuleRepository,
    PickupParseEngine? engine,
  }) : _templateRuleRepository = templateRuleRepository,
       _engine = engine ?? PickupParseEngine();

  final TemplateRuleRepository _templateRuleRepository;
  final PickupParseEngine _engine;
  final ExpireTimeParser _expireTimeParser = ExpireTimeParser();

  @override
  Future<PickupParseResult?> extract(String text, {DateTime? now}) async {
    final trimmed = text.trim();
    if (trimmed.isEmpty) {
      return null;
    }

    final templates = await _templateRuleRepository
        .watchAll(mode: AppMode.ai)
        .first;
    final parsed = _engine.parse(trimmed, now: now, templates: templates);
    if (parsed != null && parsed.isValid) {
      return _wrapAsAi(parsed);
    }

    return _fallbackGuess(trimmed, now: now ?? DateTime.now());
  }

  PickupParseResult _wrapAsAi(PickupParseResult origin) {
    return PickupParseResult(
      rawText: origin.rawText,
      ruleId: 'ai-${origin.ruleId}',
      ruleName: 'AI 模拟识别',
      confidence: (origin.confidence + 0.1).clamp(0.0, 1.0),
      source: PickupParseRuleSource.ai,
      code: origin.code,
      stationName: origin.stationName,
      expireAt: origin.expireAt,
    );
  }

  PickupParseResult? _fallbackGuess(String text, {required DateTime now}) {
    final candidates = RegExp(r'[A-Za-z0-9]{4,10}')
        .allMatches(text)
        .map((match) => match.group(0) ?? '')
        .where((value) => value.isNotEmpty)
        .toList();

    if (candidates.isEmpty) {
      return null;
    }

    candidates.sort((a, b) => b.length.compareTo(a.length));
    String? code;
    for (final candidate in candidates) {
      if (_looksLikePhone(candidate)) {
        continue;
      }
      code = candidate;
      break;
    }
    code ??= candidates.first;

    final station = _extractStation(text);
    final expireAt = _expireTimeParser.parse(text, now: now);

    var confidence = 0.45 + Random().nextDouble() * 0.1;
    if (station != null) {
      confidence += 0.1;
    }
    if (expireAt != null) {
      confidence += 0.1;
    }
    confidence = confidence.clamp(0.0, 0.75);

    return PickupParseResult(
      rawText: text,
      ruleId: 'ai-fallback',
      ruleName: 'AI 猜测',
      confidence: confidence,
      source: PickupParseRuleSource.ai,
      code: code,
      stationName: station,
      expireAt: expireAt,
    );
  }

  bool _looksLikePhone(String value) {
    if (value.length != 11) {
      return false;
    }
    if (!RegExp(r'^\d{11}$').hasMatch(value)) {
      return false;
    }
    return value.startsWith('1');
  }

  String? _extractStation(String text) {
    const patterns = [
      r'【(?<station>[^】]{2,16})】',
      r'(?:驿站|站点|快递柜|自提点|取件点|代收点)[:：\s]*(?<station>[\u4e00-\u9fa5A-Za-z0-9\-]{2,20})',
      r'(?<station>[\u4e00-\u9fa5A-Za-z0-9\-]{2,20})(?:驿站|站点|快递柜|自提点|取件点)',
      r'(?<station>丰巢|菜鸟|妈妈驿站|邮政|京东快递|顺丰|中通|圆通|申通|韵达)[^，。]{0,10}',
    ];
    for (final pattern in patterns) {
      final match = RegExp(pattern).firstMatch(text);
      final station = match?.namedGroup('station');
      if (station != null && station.trim().isNotEmpty) {
        return station.trim();
      }
    }
    return null;
  }
}
