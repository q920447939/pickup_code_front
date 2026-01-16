import 'package:flutter_test/flutter_test.dart';
import 'package:pickup_code_front/domain/entities/template_rule.dart';
import 'package:pickup_code_front/domain/usecases/pickup_parse_engine.dart';
import 'package:pickup_code_front/domain/usecases/template_rule_builder.dart';

void main() {
  test('builtin rules parse code, station and expire', () {
    final engine = PickupParseEngine();
    final now = DateTime(2026, 1, 16, 9, 0);
    const text = '【菜鸟驿站】您的取件码1234，请于今天18:30前领取';

    final result = engine.parse(text, now: now);

    expect(result, isNotNull);
    expect(result!.code, '1234');
    expect(result.stationName, '菜鸟驿站');
    expect(result.expireAt, DateTime(2026, 1, 16, 18, 30));
  });

  test('builtin rules parse relative hours', () {
    final engine = PickupParseEngine();
    final now = DateTime(2026, 1, 16, 10, 0);
    const text = '取件码 8844，请在24小时内取件';

    final result = engine.parse(text, now: now);

    expect(result, isNotNull);
    expect(result!.code, '8844');
    expect(result.expireAt, DateTime(2026, 1, 17, 10, 0));
  });

  test('template rule builder generates usable pattern', () {
    final builder = TemplateRuleBuilder();
    const sample = '菜鸟驿站A站，取件码A123，请于1月18日18:00前取件';
    final payload = builder.buildFromSample(
      sampleText: sample,
      code: 'A123',
      station: '菜鸟驿站A站',
      expireText: '1月18日18:00',
    );
    final templateRule = TemplateRule(
      name: '用户模板',
      sampleText: sample,
      rulePayload: payload.toJsonString(),
    );

    final engine = PickupParseEngine();
    final result = engine.parse(
      sample,
      now: DateTime(2026, 1, 16, 9, 0),
      templates: [templateRule],
    );

    expect(result, isNotNull);
    expect(result!.code, 'A123');
    expect(result.stationName, '菜鸟驿站A站');
    expect(result.expireAt, DateTime(2026, 1, 18, 18, 0));
  });

  test('legacy template payload stays compatible', () {
    final templateRule = TemplateRule(
      name: 'legacy',
      sampleText: '取件码1234',
      rulePayload: '{"code":"\\\\d{4}"}',
    );
    final engine = PickupParseEngine();
    final result = engine.parse(
      '请凭取件码1234取件',
      now: DateTime(2026, 1, 16, 9, 0),
      templates: [templateRule],
    );

    expect(result, isNotNull);
    expect(result!.code, '1234');
  });
}
