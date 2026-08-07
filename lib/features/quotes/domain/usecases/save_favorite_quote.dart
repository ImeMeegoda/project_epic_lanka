import '../../../../core/usecases/use_case.dart';
import '../entities/quote_entity.dart';
import '../repositories/quote_repository.dart';

// Aluth quote ekak favorite list ekata save karanna use karana UseCase eka.
class SaveFavoriteQuote implements UseCase<void, QuoteEntity> {
  final QuoteRepository repository;

  SaveFavoriteQuote(this.repository);

  @override
  Future<void> call(QuoteEntity quote) async {
    // Repository eka haraha quote eka favorites wala save karanawa.
    return await repository.saveFavoriteQuote(quote);
  }
}
