import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/quote_entity.dart';
import '../../domain/usecases/get_random_quote.dart';
import '../../../../core/usecases/use_case.dart';
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

// RandomQuoteCubit kiyanne sarala state changes handle karanna use karana logic component ekak.
// BLoC ekata wadha meka lightweight (Events ona na).
class RandomQuoteCubit extends Cubit<RandomQuoteState> {
  RandomQuoteCubit({
    required GetRandomQuote getRandomQuote,
  }) : _getRandomQuote = getRandomQuote,
       super(const RandomQuoteState(isLoading: true));

  final GetRandomQuote _getRandomQuote;

  // UI eken me function eka call kalama aluth state ekak 'emit' karanawa.
  Future<void> loadRandomQuote() async {
    // 1. Mulinma loading state eka yawanawa UI eka refresh wenna.
    emit(const RandomQuoteState(isLoading: true, error: null));

    try {
      // 2. UseCase eken daththa gannawa.
      final quote = await _getRandomQuote(const NoParams());
      // 3. Daththa labunu gaman Loaded state eka yawanawa.
      emit(RandomQuoteState(quote: quote));
    } catch (error) {
      // 4. Error ekak unoth eka handle karala error state eka UI ekata yawanawa.
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
