import '../../domain/entities/quote_entity.dart';
import '../../domain/repositories/quote_repository.dart';
import '../datasources/quote_local_data_source.dart';
import '../datasources/quote_remote_data_source.dart';
import '../models/quote_model.dart';

// Data sources (Remote/Local) saha Domain layer eka connect karana repository implementation eka.
// Meka thami theerana ganne data ganne kohenda kiyla  (API vs Cache)
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
    // Mulinma API call karala random quote ekak gannawa.
    final remoteQuote = await _remoteDataSource.getRandomQuote();
    // Gaththu quote eka offline use karanna cache karanawa.
    await _localDataSource.cacheQuote(remoteQuote);
    // QuoteModel (Data) eka QuoteEntity (Domain) ekakata convert karala UI ekata dhenawa.
    return remoteQuote.toEntity();
  }

  @override
  Future<QuoteEntity> getQuoteById(int id) async {
    // ID eken specific quote ekak API eken fetch karanawa.
    final remoteQuote = await _remoteDataSource.getQuoteById(id);
    return remoteQuote.toEntity();
  }

  @override
  Future<List<QuoteEntity>> getQuotes({int limit = 30, int skip = 0}) async {
    // API eken quotes list ekak fetch karanawa.
    final remoteQuotes = await _remoteDataSource.getQuotes(
      limit: limit,
      skip: skip,
    );
    // List ekak mapping haraha Entities bawata harawanawa (UI ekata sudusu widiyata).
    return remoteQuotes.map((quote) => quote.toEntity()).toList();
  }

  @override
  Future<void> saveFavoriteQuote(QuoteEntity quote) async {
    // Domain entity eka model ekakata harawala local storage save karanawa.
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
