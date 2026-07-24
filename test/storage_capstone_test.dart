import 'package:flutter_test/flutter_test.dart';
import 'package:quotes_app/models/quote.dart';
import 'package:quotes_app/services/quote_storage_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('QuoteStorageService', () {
    test('persists favorites and recent quotes across reads', () async {
      final storage = QuoteStorageService();
      const quote = Quote(id: 7, quote: 'Test quote', author: 'Tester');

      await storage.toggleFavorite(quote);
      final isFavorite = await storage.isFavorite(quote.id);
      await storage.cacheRecentQuote(quote);
      final recent = await storage.getRecentQuotes();

      expect(isFavorite, isTrue);
      expect(recent.first.id, 7);
    });
  });
}
