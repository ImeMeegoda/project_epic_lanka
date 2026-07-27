import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/quote.dart';
import '../repositories/quote_repository.dart';
import '../repositories/quote_failure.dart';
import '../services/quote_storage_service.dart';

class RandomQuoteState {
  const RandomQuoteState({
    this.quote,
    this.isLoading = false,
    this.error,
    this.failure,
  });

  final Quote? quote;
  final bool isLoading;
  final String? error;
  final QuoteFailure? failure;
}

class RandomQuoteCubit extends Cubit<RandomQuoteState> {
  RandomQuoteCubit({
    required QuoteRepository repository,
    required QuoteStorageService storageService,
  }) : _repository = repository,
       _storageService = storageService,
       super(const RandomQuoteState(isLoading: true));

  final QuoteRepository _repository;
  final QuoteStorageService _storageService;

  Future<void> loadRandomQuote() async {
    emit(const RandomQuoteState(isLoading: true, error: null));

    try {
      // Keep the UI layer simple by resolving the quote through the repository
      // and then storing the successful result for offline fallback.
      final quote = await _repository.getRandomQuote();
      await _storageService.cacheQuote(quote);
      emit(RandomQuoteState(quote: quote));
    } catch (error) {
      final failure = error is QuoteFailure ? error : null;
      final cachedQuote = await _storageService.getCachedQuote();
      if (cachedQuote != null) {
        emit(
          RandomQuoteState(
            quote: cachedQuote,
            error:
                failure?.message ??
                'Showing cached quote while the network is unavailable.',
            failure: failure,
          ),
        );
      } else {
        emit(
          RandomQuoteState(
            error: failure?.message ?? 'We could not load a quote right now.',
            failure: failure,
          ),
        );
      }
    }
  }
}
