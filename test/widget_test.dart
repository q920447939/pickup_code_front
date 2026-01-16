import 'package:flutter_test/flutter_test.dart';
import 'package:pickup_code_front/app/app.dart';

void main() {
  testWidgets('Pickup list shows header and action', (WidgetTester tester) async {
    await tester.pumpWidget(const PickupApp());
    await tester.pumpAndSettle();

    expect(find.text('待取件'), findsOneWidget);
    expect(find.text('新建'), findsOneWidget);
  });
}
