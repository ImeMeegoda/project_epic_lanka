import '../../../../core/usecases/use_case.dart';
import '../entities/quote_entity.dart';
import '../repositories/quote_repository.dart';

// Random quote ekak load karanna use karana use case eka.
class GetRandomQuote implements UseCase<QuoteEntity, NoParams> {
  final QuoteRepository repository;

  GetRandomQuote(this.repository);

  @override
  Future<QuoteEntity> call(NoParams params) async {
    return await repository.getRandomQuote();
  }
}
