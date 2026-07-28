import '../entities/quote_entity.dart';

abstract class QuoteRepository {
  Future<QuoteEntity> getRandomQuote();
  Future<QuoteEntity> getQuoteById(int id);
  Future<List<QuoteEntity>> getQuotes({int limit = 30, int skip = 0});
}
