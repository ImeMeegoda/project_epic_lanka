import '../../../../core/usecases/use_case.dart';
import '../entities/quote_entity.dart';
import '../repositories/quote_repository.dart';

class SaveFavoriteQuote implements UseCase<void, QuoteEntity> {
  final QuoteRepository repository;

  SaveFavoriteQuote(this.repository);

  @override
  Future<void> call(QuoteEntity quote) async {
    return await repository.saveFavoriteQuote(quote);
  }
}
