enum QuoteFailureKind { timeout, server, network, unknown }

// App eka athule wena exceptions handle karanna use karana custom failure types.
class QuoteFailure implements Exception {
  const QuoteFailure(this.kind, [this.message = '']);

  final QuoteFailureKind kind;
  final String message;

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
