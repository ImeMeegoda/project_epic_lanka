import '../../../../core/usecases/use_case.dart';
import '../entities/quote_entity.dart';
import '../repositories/quote_repository.dart';

// UseCase kiyanne eka pradhana wedak (task) wenuwen wenwuņu class ekak.
// BLoC eka kelinma Repository ekata katha karanne nathiwa me GetQuotes class eka use karanawa.
class GetQuotes implements UseCase<List<QuoteEntity>, GetQuotesParams> {
  final QuoteRepository repository;

  GetQuotes(this.repository);

  @override
  Future<List<QuoteEntity>> call(GetQuotesParams params) async {
    // Repository eka haraha daththa fetch karala logic eka ewara karanawa.
    return await repository.getQuotes(limit: params.limit, skip: params.skip);
  }
}

class GetQuotesParams {
  final int limit;
  final int skip;

  GetQuotesParams({this.limit = 30, this.skip = 0});
}
