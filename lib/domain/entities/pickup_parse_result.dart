enum PickupParseRuleSource { builtin, template, ai }

class PickupParseResult {
  const PickupParseResult({
    required this.rawText,
    required this.ruleId,
    required this.ruleName,
    required this.confidence,
    required this.source,
    this.code,
    this.stationName,
    this.expireAt,
  });

  final String rawText;
  final String ruleId;
  final String ruleName;
  final double confidence;
  final PickupParseRuleSource source;
  final String? code;
  final String? stationName;
  final DateTime? expireAt;

  bool get isValid => code != null && code!.trim().isNotEmpty;
}
