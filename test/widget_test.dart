import 'package:flutter_test/flutter_test.dart';
import 'package:quotes_app/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('App should render splash screen', (WidgetTester tester) async {
    await tester.pumpWidget(const QuotesApp());
    expect(find.text('Quotes'), findsOneWidget);

    await tester.pumpAndSettle(const Duration(seconds: 8));
  });

  testWidgets('Favorites tab shows empty state when nothing is saved', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const QuotesApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Favorites'));
    await tester.pumpAndSettle();

    expect(find.text('No favorites saved yet.'), findsOneWidget);
  });
}
