import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/quote_model.dart';

abstract class QuoteLocalDataSource {
  Future<void> cacheQuote(QuoteModel quote);
  Future<QuoteModel?> getCachedQuote();
  Future<void> saveFavoriteQuote(QuoteModel quote);
  Future<List<QuoteModel>> getFavoriteQuotes();
  Future<void> removeFavoriteQuote(QuoteModel quote);
  Future<int> getFavoriteCount();
  Future<void> clearAll();
}

// Local storage eka ekka katha karana logic eka thiyena data source eka.
// Meke SharedPreferences use karala data phone memory eke save karanawa.
class QuoteLocalDataSourceImpl implements QuoteLocalDataSource {
  static const String _cachedQuoteKey = 'cached_quote';
  static const String _favoriteQuotesKey = 'favorite_quotes';

  @override
  Future<void> cacheQuote(QuoteModel quote) async {
    // Anthimata API eken gaththu quote eka JSON widiyata cache karanawa.
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_cachedQuoteKey, json.encode(quote.toJson()));
  }

  @override
  Future<QuoteModel?> getCachedQuote() async {
    // Save karapu cache quote eka apahu gannawa.
    final prefs = await SharedPreferences.getInstance();
    final rawValue = prefs.getString(_cachedQuoteKey);
    if (rawValue == null) {
      return null;
    }
    return QuoteModel.fromJson(json.decode(rawValue) as Map<String, dynamic>);
  }

  @override
  Future<void> saveFavoriteQuote(QuoteModel quote) async {
    // User heart icon eka click kalama, list ekak widiyata favorites save karanawa.
    final prefs = await SharedPreferences.getInstance();
    final favorites = prefs.getStringList(_favoriteQuotesKey) ?? <String>[];
    final serializedQuote = json.encode(quote.toJson());
    // Eka quote eka dheparak save wenne nathi wenna check karanawa.
    if (!favorites.contains(serializedQuote)) {
      favorites.add(serializedQuote);
      await prefs.setStringList(_favoriteQuotesKey, favorites);
    }
  }

  @override
  Future<List<QuoteModel>> getFavoriteQuotes() async {
    // Okkoma save karapu favorites list ekama gannawa.
    final prefs = await SharedPreferences.getInstance();
    final favorites = prefs.getStringList(_favoriteQuotesKey) ?? <String>[];
    return favorites
        .map(
          (value) =>
              QuoteModel.fromJson(json.decode(value) as Map<String, dynamic>),
        )
        .toList();
  }

  @override
  Future<void> removeFavoriteQuote(QuoteModel quote) async {
    // Favorite eken ain karanna ona quote eka hoyala ain karanawa.
    final prefs = await SharedPreferences.getInstance();
    final favorites = prefs.getStringList(_favoriteQuotesKey) ?? <String>[];
    final serializedQuote = json.encode(quote.toJson());
    favorites.removeWhere((value) => value == serializedQuote);
    await prefs.setStringList(_favoriteQuotesKey, favorites);
  }

  @override
  Future<int> getFavoriteCount() async {
    // Current favorites gaana badge eka update karanna gannawa.
    final prefs = await SharedPreferences.getInstance();
    final favorites = prefs.getStringList(_favoriteQuotesKey) ?? <String>[];
    return favorites.length;
  }

  @override
  Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_cachedQuoteKey);
    await prefs.remove(_favoriteQuotesKey);
  }
}
