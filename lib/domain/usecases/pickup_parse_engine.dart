import 'package:pickup_code_front/domain/entities/pickup_parse_result.dart';
import 'package:pickup_code_front/domain/entities/template_rule.dart';
import 'package:pickup_code_front/domain/value_objects/template_rule_payload.dart';

class PickupParseEngine {
  PickupParseEngine({List<PickupParseRule>? builtinRules})
    : _builtinRules = builtinRules ?? _defaultBuiltinRules();

  final List<PickupParseRule> _builtinRules;
  final ExpireTimeParser _expireTimeParser = ExpireTimeParser();

  PickupParseResult? parse(
    String text, {
    DateTime? now,
    List<TemplateRule> templates = const [],
  }) {
    final currentTime = now ?? DateTime.now();
    final candidateRules = <PickupParseRule>[
      ..._compileTemplateRules(templates),
      ..._builtinRules,
    ];

    PickupParseResult? best;
    for (final rule in candidateRules) {
      final result = rule.apply(
        text,
        currentTime,
        expireTimeParser: _expireTimeParser,
      );
      if (result == null || !result.isValid) {
        continue;
      }
      if (best == null || result.confidence > best.confidence) {
        best = result;
      }
    }
    return best;
  }

  List<PickupParseRule> _compileTemplateRules(List<TemplateRule> templates) {
    return templates
        .where((rule) => rule.isEnabled)
        .map((rule) {
          final payload = TemplateRulePayload.tryParse(rule.rulePayload);
          if (payload == null) {
            return null;
          }
          return PickupParseRule(
            id: 'template-${rule.id ?? rule.sampleText.hashCode}',
            name: rule.name ?? '用户模板',
            pattern: payload.toRegExp(),
            keywords: payload.keywords,
            baseConfidence: 0.85,
            source: PickupParseRuleSource.template,
          );
        })
        .whereType<PickupParseRule>()
        .toList();
  }

  static List<PickupParseRule> _defaultBuiltinRules() {
    return [
      PickupParseRule(
        id: 'builtin-code-keyword',
        name: '取件码关键词',
        pattern: RegExp(
          r'(?:取件码|取货码|提货码|自提码)\D{0,6}(?<code>[A-Za-z0-9]{4,10})',
        ),
        keywords: const ['取件码', '取货码', '提货码', '自提码'],
        baseConfidence: 0.65,
        source: PickupParseRuleSource.builtin,
      ),
      PickupParseRule(
        id: 'builtin-password',
        name: '取件密码关键词',
        pattern: RegExp(r'(?:取件密码|取货密码|开柜码|验证码)\D{0,6}(?<code>\d{4,8})'),
        keywords: const ['取件密码', '取货密码', '开柜码', '验证码'],
        baseConfidence: 0.6,
        source: PickupParseRuleSource.builtin,
      ),
      PickupParseRule(
        id: 'builtin-letter-code',
        name: '字母数字取件码',
        pattern: RegExp(
          r'(?:取件|取货|提货|快递柜)[^A-Za-z0-9]{0,6}(?<code>[A-Za-z0-9]{4,8})',
        ),
        keywords: const ['取件', '取货', '提货', '快递柜'],
        baseConfidence: 0.55,
        source: PickupParseRuleSource.builtin,
      ),
    ];
  }
}

class PickupParseRule {
  PickupParseRule({
    required this.id,
    required this.name,
    required this.pattern,
    required this.keywords,
    required this.baseConfidence,
    required this.source,
  });

  final String id;
  final String name;
  final RegExp pattern;
  final List<String> keywords;
  final double baseConfidence;
  final PickupParseRuleSource source;

  PickupParseResult? apply(
    String text,
    DateTime now, {
    required ExpireTimeParser expireTimeParser,
  }) {
    if (keywords.isNotEmpty && !_containsKeyword(text, keywords)) {
      return null;
    }

    final match = pattern.firstMatch(text);
    if (match == null) {
      return null;
    }

    String? safeNamed(String name) {
      try {
        return match.namedGroup(name);
      } catch (_) {
        return null;
      }
    }

    final code = _sanitize(
      safeNamed('code') ?? (match.groupCount >= 1 ? match.group(1) : null),
    );
    if (code == null || code.isEmpty) {
      return null;
    }

    final station =
        _sanitize(safeNamed('station')) ?? _StationExtractor.extract(text);
    final expireText = safeNamed('expire');
    final expireAt = expireTimeParser.parse(expireText ?? text, now: now);

    var confidence = baseConfidence;
    if (station != null) {
      confidence += 0.1;
    }
    if (expireAt != null) {
      confidence += 0.1;
    }
    if (keywords.isNotEmpty && _containsKeyword(text, keywords)) {
      confidence += 0.05;
    }
    confidence = confidence.clamp(0.0, 1.0);

    return PickupParseResult(
      rawText: text,
      ruleId: id,
      ruleName: name,
      confidence: confidence,
      source: source,
      code: code,
      stationName: station,
      expireAt: expireAt,
    );
  }

  bool _containsKeyword(String text, List<String> keywords) {
    for (final keyword in keywords) {
      if (text.contains(keyword)) {
        return true;
      }
    }
    return false;
  }

  String? _sanitize(String? value) {
    if (value == null) {
      return null;
    }
    final trimmed = value.trim();
    if (trimmed.isEmpty) {
      return null;
    }
    return trimmed;
  }
}

class _StationExtractor {
  static String? extract(String text) {
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

class ExpireTimeParser {
  DateTime? parse(String text, {required DateTime now}) {
    final normalized = text.replaceAll('：', ':').replaceAll('／', '/');

    final absoluteYear = RegExp(
      r'(20\d{2})[年\-/\.](\d{1,2})[月\-/\.](\d{1,2})[日号]?(?:\s*(\d{1,2})[:：](\d{1,2}))?',
    );
    final matchYear = absoluteYear.firstMatch(normalized);
    if (matchYear != null) {
      return _safeDate(
        _toInt(matchYear.group(1)),
        _toInt(matchYear.group(2)),
        _toInt(matchYear.group(3)),
        _toInt(matchYear.group(4), fallback: 23),
        _toInt(matchYear.group(5), fallback: 59),
      );
    }

    final absoluteMonthDay = RegExp(
      r'(\d{1,2})[月\-/\.](\d{1,2})[日号]?(?:\s*(\d{1,2})[:：](\d{1,2}))?',
    );
    final matchMonthDay = absoluteMonthDay.firstMatch(normalized);
    if (matchMonthDay != null) {
      final year = now.year;
      final hour = _toInt(matchMonthDay.group(3), fallback: 23);
      final minute = _toInt(matchMonthDay.group(4), fallback: 59);
      var candidate = _safeDate(
        year,
        _toInt(matchMonthDay.group(1)),
        _toInt(matchMonthDay.group(2)),
        hour,
        minute,
      );
      if (candidate != null &&
          candidate.isBefore(now.subtract(const Duration(days: 1)))) {
        candidate = _safeDate(
          year + 1,
          candidate.month,
          candidate.day,
          candidate.hour,
          candidate.minute,
        );
      }
      return candidate;
    }

    final relativeDay = RegExp(
      r'(今天|今日|今晚|明天|后天)[^0-9]*(\d{1,2})?[:：]?(\d{0,2})?',
    );
    final matchRelative = relativeDay.firstMatch(normalized);
    if (matchRelative != null) {
      final tag = matchRelative.group(1);
      final hour = _toInt(matchRelative.group(2), fallback: 23);
      final minute = _toInt(matchRelative.group(3), fallback: 59);
      var offset = 0;
      if (tag == '明天') {
        offset = 1;
      } else if (tag == '后天') {
        offset = 2;
      }
      final base = DateTime(
        now.year,
        now.month,
        now.day,
      ).add(Duration(days: offset));
      return _safeDate(base.year, base.month, base.day, hour, minute);
    }

    final withinHours = RegExp(r'(\d{1,2})\s*小时内');
    final matchHours = withinHours.firstMatch(normalized);
    if (matchHours != null) {
      final hours = _toInt(matchHours.group(1));
      return now.add(Duration(hours: hours));
    }

    final withinDays = RegExp(r'(\d{1,2})\s*天内');
    final matchDays = withinDays.firstMatch(normalized);
    if (matchDays != null) {
      final days = _toInt(matchDays.group(1));
      return now.add(Duration(days: days));
    }

    final timeOnly = RegExp(
      r'(?:截止|截至|到期|请于|前|有效期)\D{0,6}(\d{1,2})[:：](\d{1,2})',
    );
    final matchTimeOnly = timeOnly.firstMatch(normalized);
    if (matchTimeOnly != null) {
      final hour = _toInt(matchTimeOnly.group(1));
      final minute = _toInt(matchTimeOnly.group(2));
      var candidate = _safeDate(now.year, now.month, now.day, hour, minute);
      if (candidate != null && candidate.isBefore(now)) {
        candidate = candidate.add(const Duration(days: 1));
      }
      return candidate;
    }

    return null;
  }

  int _toInt(String? value, {int fallback = 0}) {
    if (value == null) {
      return fallback;
    }
    return int.tryParse(value) ?? fallback;
  }

  DateTime? _safeDate(int year, int month, int day, int hour, int minute) {
    if (month < 1 || month > 12 || day < 1 || day > 31) {
      return null;
    }
    try {
      return DateTime(year, month, day, hour, minute);
    } catch (_) {
      return null;
    }
  }
}
