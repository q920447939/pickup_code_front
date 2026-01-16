import 'package:pickup_code_front/domain/value_objects/template_rule_payload.dart';

class TemplateRuleBuilder {
  TemplateRulePayload buildFromSample({
    required String sampleText,
    String? code,
    String? station,
    String? expireText,
  }) {
    var pattern = RegExp.escape(sampleText);
    pattern = _loosenWhitespace(pattern);

    if (code != null && code.trim().isNotEmpty) {
      pattern = _replaceFirst(pattern, code, _codePattern(code));
    }

    if (station != null && station.trim().isNotEmpty) {
      pattern = _replaceFirst(pattern, station, _stationPattern());
    }

    if (expireText != null && expireText.trim().isNotEmpty) {
      pattern = _replaceFirst(pattern, expireText, _expirePattern());
    }

    final keywords = _extractKeywords(sampleText);
    return TemplateRulePayload(pattern: pattern, keywords: keywords);
  }

  String _replaceFirst(
    String escapedSample,
    String rawValue,
    String replacement,
  ) {
    final escapedValue = RegExp.escape(rawValue);
    final index = escapedSample.indexOf(escapedValue);
    if (index == -1) {
      return escapedSample;
    }
    return escapedSample.replaceFirst(escapedValue, replacement);
  }

  String _codePattern(String code) {
    final normalized = code.trim();
    if (RegExp(r'^\d+$').hasMatch(normalized)) {
      final length = normalized.length.clamp(4, 10);
      return '(?<code>\\d{$length})';
    }
    if (RegExp(r'^[A-Za-z0-9]+$').hasMatch(normalized)) {
      final length = normalized.length.clamp(4, 12);
      return '(?<code>[A-Za-z0-9]{$length})';
    }
    return '(?<code>[A-Za-z0-9\\-]{4,12})';
  }

  String _stationPattern() {
    return '(?<station>[\\u4e00-\\u9fa5A-Za-z0-9\\-]{2,20})';
  }

  String _expirePattern() {
    return '(?<expire>[\\u4e00-\\u9fa5A-Za-z0-9:：\\-/\\.\\s]{2,30})';
  }

  List<String> _extractKeywords(String sampleText) {
    final keywords = <String>{};
    final keywordBank = [
      '取件码',
      '取货码',
      '提货码',
      '自提码',
      '驿站',
      '快递柜',
      '丰巢',
      '菜鸟',
      '妈妈驿站',
      '代取',
      '请于',
      '截止',
      '到期',
      '有效期',
    ];
    for (final keyword in keywordBank) {
      if (sampleText.contains(keyword)) {
        keywords.add(keyword);
      }
    }
    return keywords.toList();
  }

  String _loosenWhitespace(String input) {
    return input
        .replaceAll(r'\ ', r'\s*')
        .replaceAll(r'\n', r'\s*')
        .replaceAll(r'\r', r'\s*');
  }
}
