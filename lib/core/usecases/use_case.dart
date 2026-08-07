// UseCase kiyanne app eke business logic eka standarize karanna use karana abstract class ekak.
// Meken BLoC saha Repository athara clear pattern ekak hadenawa.
abstract class UseCase<T, Params> {
  Future<T> call(Params params);
}

// Params nethi welawaka use karanna hadapu empty class ekak.
class NoParams {
  const NoParams();
}
