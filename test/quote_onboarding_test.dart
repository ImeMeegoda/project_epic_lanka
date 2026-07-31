import 'package:flutter_test/flutter_test.dart';
import 'package:quotes_app/features/quotes/domain/entities/quote_entity.dart';
import 'package:quotes_app/features/quotes/domain/repositories/quote_repository.dart';
import 'package:quotes_app/features/quotes/domain/failures/quote_failure.dart';
import 'package:quotes_app/features/quotes/presentation/blocs/quote_list_bloc.dart';
import 'package:quotes_app/features/quotes/presentation/blocs/random_quote_cubit.dart';

class FakeQuoteRepository implements QuoteRepository {
  @override
  Future<QuoteEntity> getRandomQuote() async {
    return const QuoteEntity(id: 42, quote: 'Stay curious', author: 'Intern');
  }

  @override
  Future<QuoteEntity> getQuoteById(int id) async {
    return QuoteEntity(id: id, quote: 'Detail', author: 'Author');
  }

  @override
  Future<List<QuoteEntity>> getQuotes({int limit = 30, int skip = 0}) async {
    return [
      const QuoteEntity(id: 1, quote: 'One', author: 'Author 1'),
      const QuoteEntity(id: 2, quote: 'Two', author: 'Author 2'),
    ];
  }

  @override
  Future<int> getFavoriteCount() async => 0;

  @override
  Future<List<QuoteEntity>> getFavoriteQuotes() async => [];

  @override
  Future<void> removeFavoriteQuote(QuoteEntity quote) async {}

  @override
  Future<void> saveFavoriteQuote(QuoteEntity quote) async {}
}

class FailingQuoteRepository implements QuoteRepository {
  @override
  Future<QuoteEntity> getRandomQuote() async {
    throw Exception('network failed');
  }

  @override
  Future<QuoteEntity> getQuoteById(int id) async {
    throw Exception('network failed');
  }

  @override
  Future<List<QuoteEntity>> getQuotes({int limit = 30, int skip = 0}) async {
    throw Exception('network failed');
  }

  @override
  Future<int> getFavoriteCount() async => 0;

  @override
  Future<List<QuoteEntity>> getFavoriteQuotes() async => [];

  @override
  Future<void> removeFavoriteQuote(QuoteEntity quote) async {}

  @override
  Future<void> saveFavoriteQuote(QuoteEntity quote) async {}
}

class TypedFailureRepository implements QuoteRepository {
  @override
  Future<QuoteEntity> getRandomQuote() async {
    throw const QuoteFailure(
      QuoteFailureKind.timeout,
      'The request timed out.',
    );
  }

  @override
  Future<QuoteEntity> getQuoteById(int id) async {
    throw const QuoteFailure(
      QuoteFailureKind.timeout,
      'The request timed out.',
    );
  }

  @override
  Future<List<QuoteEntity>> getQuotes({int limit = 30, int skip = 0}) async {
    throw const QuoteFailure(
      QuoteFailureKind.timeout,
      'The request timed out.',
    );
  }

  @override
  Future<int> getFavoriteCount() async => 0;

  @override
  Future<List<QuoteEntity>> getFavoriteQuotes() async => [];

  @override
  Future<void> removeFavoriteQuote(QuoteEntity quote) async {}

  @override
  Future<void> saveFavoriteQuote(QuoteEntity quote) async {}
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('RandomQuoteCubit', () {
    test('loads a quote and clears the loading state', () async {
      final cubit = RandomQuoteCubit(
        repository: FakeQuoteRepository(),
      );

      await cubit.loadRandomQuote();

      expect(cubit.state.isLoading, isFalse);
      expect(cubit.state.quote?.quote, 'Stay curious');
      expect(cubit.state.error, isNull);
    });

    test('surfaces typed failures from the repository', () async {
      final cubit = RandomQuoteCubit(
        repository: TypedFailureRepository(),
      );

      await cubit.loadRandomQuote();

      expect(cubit.state.error, contains('timed out'));
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
