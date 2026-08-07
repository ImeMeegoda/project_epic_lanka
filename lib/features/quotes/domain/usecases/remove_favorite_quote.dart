import '../../../../core/usecases/use_case.dart';
import '../entities/quote_entity.dart';
import '../repositories/quote_repository.dart';

// Favorite list eken quote ekak ain karanna use karana UseCase eka.
class RemoveFavoriteQuote implements UseCase<void, QuoteEntity> {
  final QuoteRepository repository;

  RemoveFavoriteQuote(this.repository);

  @override
  Future<void> call(QuoteEntity quote) async {
    // Repository eka haraha favorite eka remove karanawa.
    return await repository.removeFavoriteQuote(quote);
  }
}
