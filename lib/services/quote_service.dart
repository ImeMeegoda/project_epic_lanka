import 'dart:convert';

import 'package:http/http.dart' as http;

import '../core/errors/quote_failure.dart';
import '../models/quote.dart';

abstract class QuoteRemoteDataSource {
  Future<Quote> getRandomQuote();
  Future<Quote> getQuoteById(int id);
  Future<List<Quote>> getQuotes({int limit = 30, int skip = 0});
}

class QuoteService implements QuoteRemoteDataSource {
  QuoteService({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;

  static const String baseUrl = 'https://dummyjson.com/quotes';

  @override
  Future<Quote> getRandomQuote() async {
    try {
      final response = await _client.get(Uri.parse('$baseUrl/random'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return Quote.fromJson(data);
      }

      throw const QuoteFailure(
        message: 'Failed to load quote.',
        type: QuoteFailureType.server,
      );
    } on QuoteFailure {
      rethrow;
    } on http.ClientException {
      throw const QuoteFailure(
        message: 'Unable to reach the quote service.',
        type: QuoteFailureType.network,
      );
    } catch (_) {
      throw const QuoteFailure(
        message: 'Failed to load quote.',
        type: QuoteFailureType.unknown,
      );
    }
  }

  @override
  Future<Quote> getQuoteById(int id) async {
    try {
      final response = await _client.get(Uri.parse('$baseUrl/$id'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return Quote.fromJson(data);
      }

      throw const QuoteFailure(
        message: 'Failed to load quote details.',
        type: QuoteFailureType.server,
      );
    } on QuoteFailure {
      rethrow;
    } on http.ClientException {
      throw const QuoteFailure(
        message: 'Unable to reach the quote service.',
        type: QuoteFailureType.network,
      );
    } catch (_) {
      throw const QuoteFailure(
        message: 'Failed to load quote details.',
        type: QuoteFailureType.unknown,
      );
    }
  }

  @override
  Future<List<Quote>> getQuotes({int limit = 30, int skip = 0}) async {
    try {
      final response = await _client.get(
        Uri.parse('$baseUrl?limit=$limit&skip=$skip'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List quotesJson = data['quotes'];
        return quotesJson.map((q) => Quote.fromJson(q)).toList();
      }

      throw const QuoteFailure(
        message: 'Failed to load quotes.',
        type: QuoteFailureType.server,
      );
    } on QuoteFailure {
      rethrow;
    } on http.ClientException {
      throw const QuoteFailure(
        message: 'Unable to reach the quote service.',
        type: QuoteFailureType.network,
      );
    } catch (_) {
      throw const QuoteFailure(
        message: 'Failed to load quotes.',
        type: QuoteFailureType.unknown,
      );
    }
  }
}
