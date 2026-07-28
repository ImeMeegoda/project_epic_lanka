import '../../domain/entities/quote_entity.dart';
import '../../domain/repositories/quote_repository.dart';
import '../datasources/quote_local_data_source.dart';
import '../datasources/quote_remote_data_source.dart';

class QuoteRepositoryImpl implements QuoteRepository {
  QuoteRepositoryImpl({
    required QuoteRemoteDataSource remoteDataSource,
    required QuoteLocalDataSource localDataSource,
  }) : _remoteDataSource = remoteDataSource,
       _localDataSource = localDataSource;

  final QuoteRemoteDataSource _remoteDataSource;
  final QuoteLocalDataSource _localDataSource;

  @override
  Future<QuoteEntity> getRandomQuote() async {
    final remoteQuote = await _remoteDataSource.getRandomQuote();
    await _localDataSource.cacheQuote(remoteQuote);
    return remoteQuote.toEntity();
  }

  @override
  Future<QuoteEntity> getQuoteById(int id) async {
    final remoteQuote = await _remoteDataSource.getQuoteById(id);
    return remoteQuote.toEntity();
  }

  @override
  Future<List<QuoteEntity>> getQuotes({int limit = 30, int skip = 0}) async {
    final remoteQuotes = await _remoteDataSource.getQuotes(
      limit: limit,
      skip: skip,
    );
    return remoteQuotes.map((quote) => quote.toEntity()).toList();
  }
}
