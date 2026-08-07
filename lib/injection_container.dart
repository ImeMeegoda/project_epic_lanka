import 'features/quotes/data/datasources/quote_local_data_source.dart';
import 'features/quotes/data/datasources/quote_remote_data_source.dart';
import 'features/quotes/data/repositories/quote_repository_impl.dart';
import 'features/quotes/domain/repositories/quote_repository.dart';

// App eke Dependency Injection (DI) okkoma manage karanne me file eken.
// Meka nisa main.dart eka pahasuwen kiyawanna puluwan.
class DependencyInjection {
  static late final QuoteRepository repository;

  static Future<void> init() async {
    // Remote saha Local data sources initialize karanawa.
    final remoteDataSource = QuoteRemoteDataSourceImpl();
    final localDataSource = QuoteLocalDataSourceImpl();

    //  Repository eka hadala, eka static widiyata save karagannawa.
    repository = QuoteRepositoryImpl(
      remoteDataSource: remoteDataSource,
      localDataSource: localDataSource,
    );
    
    // Note: Local data source ekata SharedPreferences ona nisa, eka internal initialize wenawa.
  }
}
