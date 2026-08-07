import '../entities/quote_entity.dart';

// QuoteRepository kiyanne "Contract" (Giwisuma) ekak.
// Meke thiyenne daththa ganna ona functions wala nam tika wetharayi.
// Daththa enne API ekendha nathnam Database ekendha kiyala Domain layer eka danne na.
abstract class QuoteRepository {
  Future<QuoteEntity> getRandomQuote();
  Future<QuoteEntity> getQuoteById(int id);
  Future<List<QuoteEntity>> getQuotes({int limit = 30, int skip = 0});
  
  // Favorites management functions.
  Future<void> saveFavoriteQuote(QuoteEntity quote);
  Future<List<QuoteEntity>> getFavoriteQuotes();
  Future<void> removeFavoriteQuote(QuoteEntity quote);
  Future<int> getFavoriteCount();
}
