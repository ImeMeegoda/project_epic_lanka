import '../../../../core/usecases/use_case.dart';
import '../entities/quote_entity.dart';
import '../repositories/quote_repository.dart';

class RemoveFavoriteQuote implements UseCase<void, QuoteEntity> {
  final QuoteRepository repository;

  RemoveFavoriteQuote(this.repository);

  @override
  Future<void> call(QuoteEntity quote) async {
    return await repository.removeFavoriteQuote(quote);
  }
}
