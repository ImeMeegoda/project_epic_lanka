import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/quote.dart';
import 'quote_repository.dart';

class QuoteRepositoryImpl implements QuoteRepository {
  QuoteRepositoryImpl({http.Client? client})
    : _client = client ?? http.Client();

  static const String _baseUrl = 'https://dummyjson.com/quotes';
  final http.Client _client;

  @override
  Future<Quote> getRandomQuote() async {
    final response = await _client.get(Uri.parse('$_baseUrl/random'));
    if (response.statusCode == 200) {
      return Quote.fromJson(json.decode(response.body));
    }
    throw Exception('Failed to load quote');
  }

  @override
  Future<Quote> getQuoteById(int id) async {
    final response = await _client.get(Uri.parse('$_baseUrl/$id'));
    if (response.statusCode == 200) {
      return Quote.fromJson(json.decode(response.body));
    }
    throw Exception('Failed to load quote');
  }

  @override
  Future<List<Quote>> getQuotes({int limit = 30, int skip = 0}) async {
    final response = await _client.get(
      Uri.parse('$_baseUrl?limit=$limit&skip=$skip'),
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body) as Map<String, dynamic>;
      final quotesJson = data['quotes'] as List<dynamic>;
      return quotesJson
          .map((quote) => Quote.fromJson(quote as Map<String, dynamic>))
          .toList();
    }
    throw Exception('Failed to load quotes');
  }
}
