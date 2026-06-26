import 'package:flutter_test/flutter_test.dart';
import 'package:quotes_app/main.dart';

void main() {
  testWidgets('App should render splash screen', (WidgetTester tester) async {
    await tester.pumpWidget(const QuotesApp());
    expect(find.text('Quotes'), findsOneWidget);

    await tester.pumpAndSettle(const Duration(seconds: 8));
  });
}
