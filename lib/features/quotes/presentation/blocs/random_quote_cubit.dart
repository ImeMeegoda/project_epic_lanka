import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/quote_entity.dart';
import '../../domain/repositories/quote_repository.dart';
import '../../domain/failures/quote_failure.dart';

class RandomQuoteState {
  const RandomQuoteState({
    this.quote,
    this.isLoading = false,
    this.error,
    this.failure,
  });

  final QuoteEntity? quote;
  final bool isLoading;
  final String? error;
  final QuoteFailure? failure;
}

class RandomQuoteCubit extends Cubit<RandomQuoteState> {
  RandomQuoteCubit({
    required QuoteRepository repository,
  }) : _repository = repository,
       super(const RandomQuoteState(isLoading: true));

  final QuoteRepository _repository;

  Future<void> loadRandomQuote() async {
    emit(const RandomQuoteState(isLoading: true, error: null));

    try {
      // API eken random quote ekak fetch karanawa.
      // Repository eka athulema caching handle wenawa (Clean Architecture).
      final quote = await _repository.getRandomQuote();
      emit(RandomQuoteState(quote: quote));
    } catch (error) {
      // Peththakin errors handle karanawa. 
      // Note: In Week 2 we will improve offline recovery logic here.
      final failure = error is QuoteFailure ? error : null;
      emit(
        RandomQuoteState(
          error: failure?.message ?? 'We could not load a quote right now.',
          failure: failure,
        ),
      );
    }
  }
}
