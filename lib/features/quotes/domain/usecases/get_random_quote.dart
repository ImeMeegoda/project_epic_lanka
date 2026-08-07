import '../../../../core/usecases/use_case.dart';
import '../entities/quote_entity.dart';
import '../repositories/quote_repository.dart';

// API eken random quote ekak load karanna use karana use case eka.
class GetRandomQuote implements UseCase<QuoteEntity, NoParams> {
  final QuoteRepository repository;

  GetRandomQuote(this.repository);

  @override
  Future<QuoteEntity> call(NoParams params) async {
    // Repository eka haraha random quote eka illanawa.
    return await repository.getRandomQuote();
  }
}
