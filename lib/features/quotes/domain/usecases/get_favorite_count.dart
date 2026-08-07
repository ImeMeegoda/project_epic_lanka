import '../../../../core/usecases/use_case.dart';
import '../repositories/quote_repository.dart';

// Favorites list eke quotes kiyak save wela thiyenawada kiyala hoyaganna use karana UseCase eka.
class GetFavoriteCount implements UseCase<int, NoParams> {
  final QuoteRepository repository;

  GetFavoriteCount(this.repository);

  @override
  Future<int> call(NoParams params) async {
    // Repository eka haraha favorites count eka gannawa.
    return await repository.getFavoriteCount();
  }
}
