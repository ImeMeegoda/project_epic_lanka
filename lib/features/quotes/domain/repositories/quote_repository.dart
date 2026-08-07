import '../entities/quote_entity.dart';

// QuoteRepository kiyanne Contract ekak.
// Meke thiyenne data ganna ona functions wala nam tika wetharayi.
// Data enne API ekenda nathnam Database ekenda kiyala Domain layer eka danne na.
abstract class QuoteRepository {
  // Random quote ekak gannawa.
  Future<QuoteEntity> getRandomQuote();

  // ID eka anuwa specific quote ekak gannawa.
  Future<QuoteEntity> getQuoteById(int id);

  // Quotes list ekak gannawa (Pagination support karanawa).
  Future<List<QuoteEntity>> getQuotes({int limit = 30, int skip = 0});
  
  // Favorites management functions.
  // Favorite ekak widiyata save karanawa.
  Future<void> saveFavoriteQuote(QuoteEntity quote);

  // Save karapu okkoma favorites gannawa.
  Future<List<QuoteEntity>> getFavoriteQuotes();

  // Favorite eken ain karanawa.
  Future<void> removeFavoriteQuote(QuoteEntity quote);

  // Favorites gaana gannawa.
  Future<int> getFavoriteCount();
}
