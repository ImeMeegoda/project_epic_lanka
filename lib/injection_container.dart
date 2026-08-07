import 'features/quotes/data/datasources/quote_local_data_source.dart';
import 'features/quotes/data/datasources/quote_remote_data_source.dart';
import 'features/quotes/data/repositories/quote_repository_impl.dart';
import 'features/quotes/domain/repositories/quote_repository.dart';
import 'features/quotes/domain/usecases/get_favorite_count.dart';
import 'features/quotes/domain/usecases/get_favorite_quotes.dart';
import 'features/quotes/domain/usecases/get_quote_by_id.dart';
import 'features/quotes/domain/usecases/get_quotes.dart';
import 'features/quotes/domain/usecases/get_random_quote.dart';
import 'features/quotes/domain/usecases/remove_favorite_quote.dart';
import 'features/quotes/domain/usecases/save_favorite_quote.dart';

// App eke Dependency Injection (DI) okkoma manage karanne me file eken.
// Meka nisa main.dart eka pahasuwen kiyawanna puluwan.
class DependencyInjection {
  static late final QuoteRepository repository;
  static late final GetQuotes getQuotes;
  static late final GetRandomQuote getRandomQuote;
  static late final GetQuoteById getQuoteById;
  static late final SaveFavoriteQuote saveFavoriteQuote;
  static late final GetFavoriteQuotes getFavoriteQuotes;
  static late final RemoveFavoriteQuote removeFavoriteQuote;
  static late final GetFavoriteCount getFavoriteCount;

  static Future<void> init() async {
    // Remote saha Local data sources initialize karanawa.
    final remoteDataSource = QuoteRemoteDataSourceImpl();
    final localDataSource = QuoteLocalDataSourceImpl();

    //  Repository eka hadala, eka static widiyata save karagannawa.
    repository = QuoteRepositoryImpl(
      remoteDataSource: remoteDataSource,
      localDataSource: localDataSource,
    );
    
    // Use Cases initialize karanawa.
    getQuotes = GetQuotes(repository);
    getRandomQuote = GetRandomQuote(repository);
    getQuoteById = GetQuoteById(repository);
    saveFavoriteQuote = SaveFavoriteQuote(repository);
    getFavoriteQuotes = GetFavoriteQuotes(repository);
    removeFavoriteQuote = RemoveFavoriteQuote(repository);
    getFavoriteCount = GetFavoriteCount(repository);
    
    // Note: Local data source ekata SharedPreferences ona nisa, eka internal initialize wenawa.
  }
}
