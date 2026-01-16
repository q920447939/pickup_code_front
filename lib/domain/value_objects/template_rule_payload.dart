import 'dart:convert';

class TemplateRulePayload {
  const TemplateRulePayload({
    required this.pattern,
    this.keywords = const [],
    this.caseSensitive = false,
    this.version = 1,
  });

  final String pattern;
  final List<String> keywords;
  final bool caseSensitive;
  final int version;

  RegExp toRegExp() {
    return RegExp(
      pattern,
      caseSensitive: caseSensitive,
      dotAll: true,
      multiLine: true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'version': version,
      'pattern': pattern,
      'keywords': keywords,
      'caseSensitive': caseSensitive,
    };
  }

  String toJsonString() => jsonEncode(toJson());

  static TemplateRulePayload? tryParse(String payload) {
    try {
      final dynamic decoded = jsonDecode(payload);
      if (decoded is! Map<String, dynamic>) {
        return null;
      }
      final version = decoded['version'];
      final pattern = decoded['pattern'];
      if (pattern is String) {
        return TemplateRulePayload(
          pattern: pattern,
          keywords: _decodeStringList(decoded['keywords']),
          caseSensitive: decoded['caseSensitive'] == true,
          version: version is int ? version : 1,
        );
      }

      final legacyCode = decoded['code'];
      if (legacyCode is String) {
        final legacyPattern = '(?<code>$legacyCode)';
        return TemplateRulePayload(
          pattern: legacyPattern,
          keywords: const [],
          caseSensitive: false,
          version: 1,
        );
      }
    } catch (_) {
      return null;
    }
    return null;
  }

  static List<String> _decodeStringList(dynamic value) {
    if (value is List) {
      return value.whereType<String>().toList();
    }
    return const [];
  }
}
