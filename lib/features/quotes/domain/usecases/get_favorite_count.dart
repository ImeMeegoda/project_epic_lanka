import '../../../../core/usecases/use_case.dart';
import '../repositories/quote_repository.dart';

class GetFavoriteCount implements UseCase<int, NoParams> {
  final QuoteRepository repository;

  GetFavoriteCount(this.repository);

  @override
  Future<int> call(NoParams params) async {
    return await repository.getFavoriteCount();
  }
}
