import 'package:flutter_test/flutter_test.dart';
import 'package:quotes_app/models/quote.dart';
import 'package:quotes_app/presentation/cubit/quote_cubit.dart';
import 'package:quotes_app/services/quote_repository.dart';

class FakeQuoteRepository implements QuoteRepository {
  const FakeQuoteRepository();

  @override
  Future<Quote> getRandomQuote() async {
    return const Quote(id: 1, quote: 'Stay curious.', author: 'Test');
  }

  @override
  Future<Quote> getQuoteById(int id) async {
    return Quote(id: id, quote: 'Detail quote', author: 'Test');
  }

  @override
  Future<List<Quote>> getQuotes({int limit = 30, int skip = 0}) async {
    return const [
      Quote(id: 1, quote: 'Quote A', author: 'A'),
      Quote(id: 2, quote: 'Quote B', author: 'B'),
    ];
  }
}

void main() {
  group('QuoteCubit', () {
    test('emits loading then success for a random quote', () async {
      final cubit = QuoteCubit(FakeQuoteRepository());

      expect(cubit.state, isA<QuoteInitial>());

      await cubit.loadRandomQuote();

      expect(cubit.state, isA<QuoteLoaded>());
      expect((cubit.state as QuoteLoaded).quote.quote, 'Stay curious.');
    });
  });
}
