import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/quote_model.dart';

abstract class QuoteRemoteDataSource {
  Future<QuoteModel> getRandomQuote();
  Future<QuoteModel> getQuoteById(int id);
  Future<List<QuoteModel>> getQuotes({int limit = 30, int skip = 0});
}

class QuoteRemoteDataSourceImpl implements QuoteRemoteDataSource {
  QuoteRemoteDataSourceImpl({http.Client? client})
    : _client = client ?? http.Client();

  static const String _baseUrl = 'https://dummyjson.com/quotes';
  final http.Client _client;

  @override
  Future<QuoteModel> getRandomQuote() async {
    final response = await _client.get(Uri.parse('$_baseUrl/random'));
    if (response.statusCode == 200) {
      return QuoteModel.fromJson(
        json.decode(response.body) as Map<String, dynamic>,
      );
    }
    throw Exception('Failed to load quote');
  }

  @override
  Future<QuoteModel> getQuoteById(int id) async {
    final response = await _client.get(Uri.parse('$_baseUrl/$id'));
    if (response.statusCode == 200) {
      return QuoteModel.fromJson(
        json.decode(response.body) as Map<String, dynamic>,
      );
    }
    throw Exception('Failed to load quote');
  }

  @override
  Future<List<QuoteModel>> getQuotes({int limit = 30, int skip = 0}) async {
    final response = await _client.get(
      Uri.parse('$_baseUrl?limit=$limit&skip=$skip'),
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body) as Map<String, dynamic>;
      final quotesJson = data['quotes'] as List<dynamic>;
      return quotesJson
          .map((quote) => QuoteModel.fromJson(quote as Map<String, dynamic>))
          .toList();
    }
    throw Exception('Failed to load quotes');
  }
}
