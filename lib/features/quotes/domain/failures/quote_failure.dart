// App eke wenna puluwan errors lassanata warga karanna me enum eka use karanawa.
enum QuoteFailureKind { timeout, server, network, unknown }

// Custom Failure class eka. Meken raw error codes UI ekata therena messages bawata harawanawa.
class QuoteFailure implements Exception {
  const QuoteFailure(this.kind, [this.message = '']);

  final QuoteFailureKind kind;
  final String message;

  // HTTP status codes anuwa ena error eka mokakdha kiyala theeranaya karana factory method eka.
  factory QuoteFailure.fromStatusCode(int statusCode) {
    if (statusCode == 408) {
      return const QuoteFailure(
        QuoteFailureKind.timeout,
        'The request timed out. Please try again.',
      );
    }

    if (statusCode >= 500) {
      return const QuoteFailure(
        QuoteFailureKind.server,
        'The server could not complete the request right now.',
      );
    }

    if (statusCode == 0) {
      return const QuoteFailure(
        QuoteFailureKind.network,
        'No internet connection was detected.',
      );
    }

    return const QuoteFailure(
      QuoteFailureKind.unknown,
      'Something went wrong while loading the quote.',
    );
  }

  @override
  String toString() => message.isEmpty ? kind.toString() : message;
}
