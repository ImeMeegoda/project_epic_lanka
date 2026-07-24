import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/quote.dart';

class QuoteStorageService {
  static const String _cachedQuoteKey = 'cached_quote';
  static const String _favoriteQuotesKey = 'favorite_quotes';

  Future<void> cacheQuote(Quote quote) async {
    final prefs = await SharedPreferences.getInstance();
    // Persist the latest quote so the app can recover gracefully when the API fails.
    await prefs.setString(_cachedQuoteKey, json.encode(quote.toJson()));
  }

  Future<Quote?> getCachedQuote() async {
    final prefs = await SharedPreferences.getInstance();
    final rawValue = prefs.getString(_cachedQuoteKey);
    if (rawValue == null) {
      return null;
    }
    return Quote.fromJson(json.decode(rawValue) as Map<String, dynamic>);
  }

  Future<void> saveFavoriteQuote(Quote quote) async {
    final prefs = await SharedPreferences.getInstance();
    final favorites = prefs.getStringList(_favoriteQuotesKey) ?? <String>[];
    if (!favorites.contains(json.encode(quote.toJson()))) {
      favorites.add(json.encode(quote.toJson()));
      await prefs.setStringList(_favoriteQuotesKey, favorites);
    }
  }

  Future<List<Quote>> getFavoriteQuotes() async {
    final prefs = await SharedPreferences.getInstance();
    final favorites = prefs.getStringList(_favoriteQuotesKey) ?? <String>[];
    return favorites
        .map(
          (value) => Quote.fromJson(json.decode(value) as Map<String, dynamic>),
        )
        .toList();
  }

  Future<void> removeFavoriteQuote(Quote quote) async {
    final prefs = await SharedPreferences.getInstance();
    final favorites = prefs.getStringList(_favoriteQuotesKey) ?? <String>[];
    final serializedQuote = json.encode(quote.toJson());
    favorites.removeWhere((value) => value == serializedQuote);
    await prefs.setStringList(_favoriteQuotesKey, favorites);
  }

  Future<int> getFavoriteCount() async {
    final prefs = await SharedPreferences.getInstance();
    final favorites = prefs.getStringList(_favoriteQuotesKey) ?? <String>[];
    return favorites.length;
  }

  Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_cachedQuoteKey);
    await prefs.remove(_favoriteQuotesKey);
  }
}
