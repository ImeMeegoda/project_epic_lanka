import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/errors/quote_failure.dart';
import '../../models/quote.dart';
import '../../services/quote_repository.dart';

abstract class QuoteListState extends Equatable {
  const QuoteListState();
}

class QuoteListInitial extends QuoteListState {
  const QuoteListInitial();

  @override
  List<Object?> get props => [];
}

class QuoteListLoading extends QuoteListState {
  const QuoteListLoading();

  @override
  List<Object?> get props => [];
}

class QuoteListLoaded extends QuoteListState {
  const QuoteListLoaded({required this.quotes});

  final List<Quote> quotes;

  @override
  List<Object?> get props => [quotes];
}

class QuoteListError extends QuoteListState {
  const QuoteListError({required this.message});

  final String message;

  @override
  List<Object?> get props => [message];
}

class QuoteListCubit extends Cubit<QuoteListState> {
  QuoteListCubit(this._repository) : super(const QuoteListInitial());

  final QuoteRepository _repository;

  Future<void> loadQuotes() async {
    emit(const QuoteListLoading());

    try {
      final quotes = await _repository.getQuotes();
      emit(QuoteListLoaded(quotes: quotes));
    } on QuoteFailure catch (error) {
      emit(QuoteListError(message: error.message));
    } catch (_) {
      emit(
        const QuoteListError(
          message: 'Failed to load quotes. Please try again.',
        ),
      );
    }
  }
}
