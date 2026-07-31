import '../../domain/entities/quote_entity.dart';
import '../../domain/repositories/quote_repository.dart';
import '../datasources/quote_local_data_source.dart';
import '../datasources/quote_remote_data_source.dart';
import '../models/quote_model.dart';

// Data sources (Remote/Local) saha Domain layer eka connect karana repository implementation eka.
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

  @override
  Future<void> saveFavoriteQuote(QuoteEntity quote) async {
    await _localDataSource.saveFavoriteQuote(QuoteModel.fromEntity(quote));
  }

  @override
  Future<List<QuoteEntity>> getFavoriteQuotes() async {
    final favorites = await _localDataSource.getFavoriteQuotes();
    return favorites.map((model) => model.toEntity()).toList();
  }

  @override
  Future<void> removeFavoriteQuote(QuoteEntity quote) async {
    await _localDataSource.removeFavoriteQuote(QuoteModel.fromEntity(quote));
  }

  @override
  Future<int> getFavoriteCount() async {
    return await _localDataSource.getFavoriteCount();
  }
}
