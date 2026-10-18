import 'package:flutter_test/flutter_test.dart';
import 'package:kaizen/main.dart';

void main() {
  testWidgets('Kaizen app renders', (WidgetTester tester) async {
    await tester.pumpWidget(const KaizenApp());
    expect(find.text('Kaizen'), findsOneWidget);
  });
}
