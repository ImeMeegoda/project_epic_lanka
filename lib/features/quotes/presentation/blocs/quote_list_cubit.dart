import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/quote_entity.dart';
import '../../domain/repositories/quote_repository.dart';

class QuoteListState {
  const QuoteListState({
    this.quotes = const <QuoteEntity>[],
    this.isLoading = false,
    this.isRefreshing = false,
    this.error,
    this.hasLoaded = false,
  });

  final List<QuoteEntity> quotes;
  final bool isLoading;
  final bool isRefreshing;
  final String? error;
  final bool hasLoaded;

  QuoteListState copyWith({
    List<QuoteEntity>? quotes,
    bool? isLoading,
    bool? isRefreshing,
    String? error,
    bool? hasLoaded,
  }) {
    return QuoteListState(
      quotes: quotes ?? this.quotes,
      isLoading: isLoading ?? this.isLoading,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      error: error,
      hasLoaded: hasLoaded ?? this.hasLoaded,
    );
  }

  bool get isEmpty =>
      !isLoading && !isRefreshing && quotes.isEmpty && error == null;
}

// Quotes list eke state eka handle karana Cubit eka (simple scenario walata).
class QuoteListCubit extends Cubit<QuoteListState> {
  QuoteListCubit({required QuoteRepository repository})
    : _repository = repository,
      super(const QuoteListState(isLoading: true));

  final QuoteRepository _repository;

  Future<void> loadQuotes({bool refresh = false}) async {
    if (!refresh) {
      emit(state.copyWith(isLoading: true, error: null, hasLoaded: false));
    } else {
      emit(state.copyWith(isRefreshing: true, error: null));
    }

    try {
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
}
