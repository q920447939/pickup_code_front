import 'package:pickup_code_front/domain/entities/app_mode.dart';

class TemplateRule {
  const TemplateRule({
    this.id,
    this.name,
    required this.sampleText,
    required this.rulePayload,
    this.isEnabled = true,
    this.mode = AppMode.offline,
    this.createdAt,
    this.updatedAt,
  });

  final int? id;
  final String? name;
  final String sampleText;
  final String rulePayload;
  final bool isEnabled;
  final AppMode mode;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  TemplateRule copyWith({
    int? id,
    String? name,
    String? sampleText,
    String? rulePayload,
    bool? isEnabled,
    AppMode? mode,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return TemplateRule(
      id: id ?? this.id,
      name: name ?? this.name,
      sampleText: sampleText ?? this.sampleText,
      rulePayload: rulePayload ?? this.rulePayload,
      isEnabled: isEnabled ?? this.isEnabled,
      mode: mode ?? this.mode,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
