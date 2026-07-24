import '../models/quote.dart';
import 'quote_service.dart';

abstract class QuoteRepository {
  // Repository contract keeps the UI away from the API details.
  Future<Quote> getRandomQuote();
  Future<Quote> getQuoteById(int id);
  Future<List<Quote>> getQuotes({int limit = 30, int skip = 0});
}

class QuoteRepositoryImpl implements QuoteRepository {
  // The concrete repo uses the service layer behind the scenes.
  QuoteRepositoryImpl({QuoteRemoteDataSource? remoteDataSource})
    : _remoteDataSource = remoteDataSource ?? QuoteService();

  final QuoteRemoteDataSource _remoteDataSource;

  @override
  Future<Quote> getRandomQuote() => _remoteDataSource.getRandomQuote();

  @override
  Future<Quote> getQuoteById(int id) => _remoteDataSource.getQuoteById(id);

  @override
  Future<List<Quote>> getQuotes({int limit = 30, int skip = 0}) =>
      _remoteDataSource.getQuotes(limit: limit, skip: skip);
}
