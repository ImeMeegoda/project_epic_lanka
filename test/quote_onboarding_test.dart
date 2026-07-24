import 'package:flutter_test/flutter_test.dart';
import 'package:quotes_app/blocs/quote_list_bloc.dart';
import 'package:quotes_app/cubits/random_quote_cubit.dart';
import 'package:quotes_app/models/quote.dart';
import 'package:quotes_app/repositories/quote_repository.dart';
import 'package:quotes_app/repositories/quote_failure.dart';
import 'package:quotes_app/services/quote_storage_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FakeQuoteRepository implements QuoteRepository {
  // This fake repository gives us a predictable quote so the Cubit logic can be tested.
  @override
  Future<Quote> getRandomQuote() async {
    return const Quote(id: 42, quote: 'Stay curious', author: 'Intern');
  }

  @override
  Future<Quote> getQuoteById(int id) async {
    return Quote(id: id, quote: 'Detail', author: 'Author');
  }

  @override
  Future<List<Quote>> getQuotes({int limit = 30, int skip = 0}) async {
    return [
      const Quote(id: 1, quote: 'One', author: 'Author 1'),
      const Quote(id: 2, quote: 'Two', author: 'Author 2'),
    ];
  }
}

class FailingQuoteRepository implements QuoteRepository {
  // This one simulates a real network failure so we can verify the fallback path.
  @override
  Future<Quote> getRandomQuote() async {
    throw Exception('network failed');
  }

  @override
  Future<Quote> getQuoteById(int id) async {
    throw Exception('network failed');
  }

  @override
  Future<List<Quote>> getQuotes({int limit = 30, int skip = 0}) async {
    throw Exception('network failed');
  }
}

class TypedFailureRepository implements QuoteRepository {
  @override
  Future<Quote> getRandomQuote() async {
    throw const QuoteFailure(
      QuoteFailureKind.timeout,
      'The request timed out.',
    );
  }

  @override
  Future<Quote> getQuoteById(int id) async {
    throw const QuoteFailure(
      QuoteFailureKind.timeout,
      'The request timed out.',
    );
  }

  @override
  Future<List<Quote>> getQuotes({int limit = 30, int skip = 0}) async {
    throw const QuoteFailure(
      QuoteFailureKind.timeout,
      'The request timed out.',
    );
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('RandomQuoteCubit', () {
    late QuoteStorageService storageService;

    setUp(() async {
      // Reset the storage before each test so the results stay clean and predictable.
      SharedPreferences.setMockInitialValues({});
      storageService = QuoteStorageService();
      await storageService.clearAll();
    });

    test('loads a quote and clears the loading state', () async {
      final cubit = RandomQuoteCubit(
        repository: FakeQuoteRepository(),
        storageService: storageService,
      );

      await cubit.loadRandomQuote();

      expect(cubit.state.isLoading, isFalse);
      expect(cubit.state.quote?.quote, 'Stay curious');
      expect(cubit.state.error, isNull);
    });

    test('falls back to cached storage when the API fails', () async {
      await storageService.cacheQuote(
        const Quote(id: 7, quote: 'Cached quote', author: 'Cache'),
      );

      final cubit = RandomQuoteCubit(
        repository: FailingQuoteRepository(),
        storageService: storageService,
      );

      await cubit.loadRandomQuote();

      expect(cubit.state.quote?.quote, 'Cached quote');
      expect(cubit.state.error, isNotNull);
    });

    test('surfaces typed failures from the repository', () async {
      final cubit = RandomQuoteCubit(
        repository: TypedFailureRepository(),
        storageService: storageService,
      );

      await cubit.loadRandomQuote();

      expect(cubit.state.error, contains('timed out'));
    });

    test('removes a favorite quote from persistent storage', () async {
      const favorite = Quote(id: 9, quote: 'Be brave', author: 'Mentor');
      await storageService.saveFavoriteQuote(favorite);

      await storageService.removeFavoriteQuote(favorite);

      final favorites = await storageService.getFavoriteQuotes();
      expect(favorites, isEmpty);
    });

    test('returns the current favorite count from storage', () async {
      await storageService.saveFavoriteQuote(
        const Quote(id: 10, quote: 'Keep going', author: 'Coach'),
      );

      final count = await storageService.getFavoriteCount();
      expect(count, 1);
    });
  });

  group('QuoteListBloc', () {
    test('filters quotes by the current search query', () async {
      final bloc = QuoteListBloc(repository: FakeQuoteRepository());

      bloc.add(LoadQuotesEvent());
      await bloc.stream.firstWhere((state) => state.hasLoaded);
      bloc.add(SearchQuotesEvent('two'));
      await Future<void>.delayed(Duration.zero);

      expect(bloc.state.visibleQuotes, hasLength(1));
      expect(bloc.state.visibleQuotes.single.quote, contains('Two'));
    });
  });
}
