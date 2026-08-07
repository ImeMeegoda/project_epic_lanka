import '../../../../core/usecases/use_case.dart';
import '../entities/quote_entity.dart';
import '../repositories/quote_repository.dart';

// Save karapu favorite quotes okkoma list ekak widiyata ganna use karana UseCase eka.
class GetFavoriteQuotes implements UseCase<List<QuoteEntity>, NoParams> {
  final QuoteRepository repository;

  GetFavoriteQuotes(this.repository);

  @override
  Future<List<QuoteEntity>> call(NoParams params) async {
    // Repository eka haraha favorites list eka load karanawa.
    return await repository.getFavoriteQuotes();
  }
}
