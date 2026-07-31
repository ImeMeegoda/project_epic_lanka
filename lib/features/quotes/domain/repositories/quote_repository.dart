import '../entities/quote_entity.dart';

// Domain layer eke data fetch karanna ona widiya define karana interface eka.
abstract class QuoteRepository {
  Future<QuoteEntity> getRandomQuote();
  Future<QuoteEntity> getQuoteById(int id);
  Future<List<QuoteEntity>> getQuotes({int limit = 30, int skip = 0});
  
  // Favorites management
  Future<void> saveFavoriteQuote(QuoteEntity quote);
  Future<List<QuoteEntity>> getFavoriteQuotes();
  Future<void> removeFavoriteQuote(QuoteEntity quote);
  Future<int> getFavoriteCount();
}
