import '../models/quote.dart';

abstract class QuoteRepository {
  Future<Quote> getRandomQuote();
  Future<Quote> getQuoteById(int id);
  Future<List<Quote>> getQuotes({int limit = 30, int skip = 0});
}
