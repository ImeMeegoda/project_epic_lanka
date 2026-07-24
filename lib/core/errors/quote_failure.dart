class QuoteFailure implements Exception {
  const QuoteFailure({
    required this.message,
    this.type = QuoteFailureType.unknown,
  });

  final String message;
  final QuoteFailureType type;

  @override
  String toString() => 'QuoteFailure(message: $message, type: $type)';
}

enum QuoteFailureType { network, server, parsing, unknown }
