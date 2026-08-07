import '../../../../core/usecases/use_case.dart';
import '../entities/quote_entity.dart';
import '../repositories/quote_repository.dart';

// ID eka anuwa specific quote ekak hoyala ganna use karana UseCase eka.
class GetQuoteById implements UseCase<QuoteEntity, int> {
  final QuoteRepository repository;

  GetQuoteById(this.repository);

  @override
  Future<QuoteEntity> call(int id) async {
    // Repository eka haraha specific quote eka fetch karanawa.
    return await repository.getQuoteById(id);
  }
}
