import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/quote.dart';

class QuoteService {
  static const String baseUrl = 'https://dummyjson.com/quotes';

  // Fetch a random quote for the home screen
  Future<Quote> getRandomQuote() async {
    final response = await http.get(Uri.parse('$baseUrl/random'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return Quote.fromJson(data);
    } else {
      throw Exception('Failed to load quote');
    }
  }

  // Fetch a single quote by ID
  Future<Quote> getQuoteById(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/$id'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return Quote.fromJson(data);
    } else {
      throw Exception('Failed to load quote');
    }
  }

  // Fetch all quotes with pagination
  Future<List<Quote>> getQuotes({int limit = 30, int skip = 0}) async {
    final response = await http.get(
      Uri.parse('$baseUrl?limit=$limit&skip=$skip'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List quotesJson = data['quotes'];
      return quotesJson.map((q) => Quote.fromJson(q)).toList();
    } else {
      throw Exception('Failed to load quotes');
    }
  }
}
