import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/quote_entity.dart';
import '../../domain/repositories/quote_repository.dart';

abstract class QuoteListEvent {}

class LoadQuotesEvent extends QuoteListEvent {}

class RefreshQuotesEvent extends QuoteListEvent {}

class SearchQuotesEvent extends QuoteListEvent {
  SearchQuotesEvent(this.query);

  final String query;
}

class QuoteListState {
  const QuoteListState({
    this.quotes = const <QuoteEntity>[],
    this.isLoading = false,
    this.isRefreshing = false,
    this.error,
    this.hasLoaded = false,
    this.searchQuery = '',
  });

  final List<QuoteEntity> quotes;
  final bool isLoading;
  final bool isRefreshing;
  final String? error;
  final bool hasLoaded;
  final String searchQuery;

  // Immutable state ekak update karanne mehemai. 
  // Parana data tika thiyagena ona tika wetharak wenas karala aluth state ekak (Snapshot) dhenawa.
  QuoteListState copyWith({
    List<QuoteEntity>? quotes,
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
      error: error, // Note: error eka nullable nisa null dhenna nam methana podi wenasak ona, eth danata meka athi.
      hasLoaded: hasLoaded ?? this.hasLoaded,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }

  bool get isEmpty =>
      !isLoading && !isRefreshing && quotes.isEmpty && error == null;

  // API ekata ayeth yanne nethuwa memory eke thiyena list eka filter karala instant results UI ekata dena logic eka.
  // Meka getter ekak widiyata hadala thiyena nisa, state eka wenas wenakota auto run wela results pēnnanawa.
  List<QuoteEntity> get visibleQuotes {
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
    // Event listeners tika set karanawa.
    on<LoadQuotesEvent>(_onLoadQuotes);
    on<RefreshQuotesEvent>(_onRefreshQuotes);
    on<SearchQuotesEvent>(_onSearchQuotes);
  }

  final QuoteRepository _repository;

  Future<void> _onLoadQuotes(
    LoadQuotesEvent event,
    Emitter<QuoteListState> emit,
  ) async {
    // UI ekata Shimmer pēnnanna kiyanawa.
    emit(state.copyWith(isLoading: true, error: null, hasLoaded: false));

    try {
      // Repository eka haraha daththa illanawa.
      final quotes = await _repository.getQuotes();
      // Data labunu gaman, shimmer ain karala list eka UI ekata yawanawa.
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
      // Monawahari awulak unoth error state eka emit karanawa.
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
    // User type karana query eka state ekata save karanawa (Memory eken filter wenna).
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
