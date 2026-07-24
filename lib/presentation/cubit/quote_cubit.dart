import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/errors/quote_failure.dart';
import '../../models/quote.dart';
import '../../services/quote_repository.dart';

abstract class QuoteState extends Equatable {
  const QuoteState();
}

class QuoteInitial extends QuoteState {
  const QuoteInitial();

  @override
  List<Object?> get props => [];
}

class QuoteLoading extends QuoteState {
  const QuoteLoading();

  @override
  List<Object?> get props => [];
}

class QuoteLoaded extends QuoteState {
  const QuoteLoaded({required this.quote});

  final Quote quote;

  @override
  List<Object?> get props => [quote];
}

class QuoteError extends QuoteState {
  const QuoteError({required this.message});

  final String message;

  @override
  List<Object?> get props => [message];
}

class QuoteCubit extends Cubit<QuoteState> {
  QuoteCubit(this._repository) : super(const QuoteInitial());

  final QuoteRepository _repository;

  Future<void> loadRandomQuote() async {
    emit(const QuoteLoading());

    try {
      final quote = await _repository.getRandomQuote();
      emit(QuoteLoaded(quote: quote));
    } on QuoteFailure catch (error) {
      emit(QuoteError(message: error.message));
    } catch (_) {
      emit(
        const QuoteError(message: 'Failed to load quote. Please try again.'),
      );
    }
  }
}
