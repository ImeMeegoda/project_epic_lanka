import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/quote.dart';

class QuoteStorageService {
  QuoteStorageService();

  // Local storage handles favorites, recent history, and cached quotes.
  static const String _favoriteQuotesKey = 'favorite_quotes';
  static const String _recentQuotesKey = 'recent_quotes';
  static const String _cachedQuotesKey = 'cached_quotes';
  static const int _maxRecentQuotes = 8;

  // Secure storage is used for favorite quotes because this is user-specific saved data.
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  // Add or remove a quote from the secure favorites list.
  Future<void> toggleFavorite(Quote quote) async {
    final favorites = await getFavoriteQuotes();
    final existingIndex = favorites.indexWhere((item) => item.id == quote.id);

    if (existingIndex >= 0) {
      favorites.removeAt(existingIndex);
    } else {
      favorites.add(quote);
    }

    await _secureStorage.write(
      key: _favoriteQuotesKey,
      value: jsonEncode(favorites.map((item) => item.toJson()).toList()),
    );
  }

  // Returns whether the quote is currently marked as a favorite.
  Future<bool> isFavorite(int quoteId) async {
    final favorites = await getFavoriteQuotes();
    return favorites.any((item) => item.id == quoteId);
  }

  // Reads favorite quotes from secure storage.
  Future<List<Quote>> getFavoriteQuotes() async {
    final rawValue = await _secureStorage.read(key: _favoriteQuotesKey);
    if (rawValue == null || rawValue.isEmpty) {
      return <Quote>[];
    }

    final decoded = jsonDecode(rawValue) as List<dynamic>;
    return decoded
        .map((item) => Quote.fromJson(Map<String, dynamic>.from(item as Map)))
        .toList();
  }

  // Cache recently viewed quotes in shared preferences.
  Future<void> cacheRecentQuote(Quote quote) async {
    final prefs = await SharedPreferences.getInstance();
    final recentQuotes = await getRecentQuotes();
    final updated = <Quote>[quote];

    for (final item in recentQuotes) {
      if (item.id != quote.id) {
        updated.add(item);
      }
    }

    final trimmed = updated.take(_maxRecentQuotes).toList();
    await prefs.setString(
      _recentQuotesKey,
      jsonEncode(trimmed.map((item) => item.toJson()).toList()),
    );
  }

  // Reads recently viewed quotes from shared preferences.
  Future<List<Quote>> getRecentQuotes() async {
    final prefs = await SharedPreferences.getInstance();
    final rawValue = prefs.getString(_recentQuotesKey);
    if (rawValue == null || rawValue.isEmpty) {
      return <Quote>[];
    }

    final decoded = jsonDecode(rawValue) as List<dynamic>;
    return decoded
        .map((item) => Quote.fromJson(Map<String, dynamic>.from(item as Map)))
        .toList();
  }

  // Cache quote list data locally for faster access.
  Future<void> cacheQuotes(List<Quote> quotes) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _cachedQuotesKey,
      jsonEncode(quotes.map((item) => item.toJson()).toList()),
    );
  }

  // Reads cached quote list data from shared preferences.
  Future<List<Quote>> getCachedQuotes() async {
    final prefs = await SharedPreferences.getInstance();
    final rawValue = prefs.getString(_cachedQuotesKey);
    if (rawValue == null || rawValue.isEmpty) {
      return <Quote>[];
    }

    final decoded = jsonDecode(rawValue) as List<dynamic>;
    return decoded
        .map((item) => Quote.fromJson(Map<String, dynamic>.from(item as Map)))
        .toList();
  }

  // Clear all local session data used by the app.
  Future<void> clearSession() async {
    await _secureStorage.delete(key: _favoriteQuotesKey);
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_recentQuotesKey);
    await prefs.remove(_cachedQuotesKey);
  }
}
