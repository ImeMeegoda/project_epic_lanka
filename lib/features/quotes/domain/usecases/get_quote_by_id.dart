import '../../../../core/usecases/use_case.dart';
import '../entities/quote_entity.dart';
import '../repositories/quote_repository.dart';

class GetQuoteById implements UseCase<QuoteEntity, int> {
  final QuoteRepository repository;

  GetQuoteById(this.repository);

  @override
  Future<QuoteEntity> call(int id) async {
    return await repository.getQuoteById(id);
  }
}
