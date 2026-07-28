import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/quote.dart';
import '../repositories/quote_repository.dart';

abstract class QuoteListEvent {}

class LoadQuotesEvent extends QuoteListEvent {}

class RefreshQuotesEvent extends QuoteListEvent {}

class SearchQuotesEvent extends QuoteListEvent {
  SearchQuotesEvent(this.query);

  final String query;
}

class QuoteListState {
  const QuoteListState({
    this.quotes = const <Quote>[],
    this.isLoading = false,
    this.isRefreshing = false,
    this.error,
    this.hasLoaded = false,
    this.searchQuery = '',
  });

  final List<Quote> quotes;
  final bool isLoading;
  final bool isRefreshing;
  final String? error;
  final bool hasLoaded;
  final String searchQuery;

  QuoteListState copyWith({
    List<Quote>? quotes,
    bool? isLoading,
    bool? isRefreshing,
    String? error,
    bool? hasLoaded,
    String? searchQuery,
  }) {
    return QuoteListState(
      quotes: quotes ?? this.quotes,
      isLoading: isLoading ?? this.isLoading,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      error: error,
      hasLoaded: hasLoaded ?? this.hasLoaded,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }

  bool get isEmpty =>
      !isLoading && !isRefreshing && quotes.isEmpty && error == null;

  List<Quote> get visibleQuotes {
    final normalizedQuery = searchQuery.trim().toLowerCase();
    if (normalizedQuery.isEmpty) {
      return quotes;
    }
    return quotes.where((quote) {
      final text = '${quote.quote} ${quote.author}'.toLowerCase();
      return text.contains(normalizedQuery);
    }).toList();
  }
}

class QuoteListBloc extends Bloc<QuoteListEvent, QuoteListState> {
  QuoteListBloc({required QuoteRepository repository})
    : _repository = repository,
      super(const QuoteListState(isLoading: true)) {
    on<LoadQuotesEvent>(_onLoadQuotes);
    on<RefreshQuotesEvent>(_onRefreshQuotes);
    on<SearchQuotesEvent>(_onSearchQuotes);
  }

  final QuoteRepository _repository;

  Future<void> _onLoadQuotes(
    LoadQuotesEvent event,
    Emitter<QuoteListState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, error: null, hasLoaded: false));

    try {
      // The screen stays simple and just reacts to the state that comes back.
      final quotes = await _repository.getQuotes();
      emit(
        state.copyWith(
          quotes: quotes,
          isLoading: false,
          isRefreshing: false,
          error: null,
          hasLoaded: true,
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          isLoading: false,
          isRefreshing: false,
          error: 'We could not load the quote list right now.',
          hasLoaded: true,
        ),
      );
    }
  }

  Future<void> _onSearchQuotes(
    SearchQuotesEvent event,
    Emitter<QuoteListState> emit,
  ) async {
    emit(state.copyWith(searchQuery: event.query));
  }

  Future<void> _onRefreshQuotes(
    RefreshQuotesEvent event,
    Emitter<QuoteListState> emit,
  ) async {
    emit(state.copyWith(isRefreshing: true, error: null));

    try {
      final quotes = await _repository.getQuotes();
      emit(
        state.copyWith(
          quotes: quotes,
          isRefreshing: false,
          error: null,
          hasLoaded: true,
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          isRefreshing: false,
          error: 'We could not refresh the quote list right now.',
          hasLoaded: true,
        ),
      );
    }
  }
}
