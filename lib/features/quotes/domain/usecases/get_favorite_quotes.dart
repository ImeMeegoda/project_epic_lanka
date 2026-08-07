import '../../../../core/usecases/use_case.dart';
import '../entities/quote_entity.dart';
import '../repositories/quote_repository.dart';

class GetFavoriteQuotes implements UseCase<List<QuoteEntity>, NoParams> {
  final QuoteRepository repository;

  GetFavoriteQuotes(this.repository);

  @override
  Future<List<QuoteEntity>> call(NoParams params) async {
    return await repository.getFavoriteQuotes();
  }
}
