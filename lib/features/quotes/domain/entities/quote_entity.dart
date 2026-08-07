// QuoteEntity kiyanne app eke thiyena "Purest" data object eka.
// Meke thiyenne business logic walata ona pradhana daththa wetharayi (id, quote, author).
// API details (Models) saha UI (Widgets) walin meka sampurnayenma wen wela thiyenne.
class QuoteEntity {
  const QuoteEntity({
    required this.id,
    required this.quote,
    required this.author,
  });

  final int id;
  final String quote;
  final String author;

  // JSON daththa Entity ekakata harawanna use karana factory constructor eka.
  factory QuoteEntity.fromJson(Map<String, dynamic> json) {
    return QuoteEntity(
      id: json['id'] as int,
      quote: json['quote'] as String,
      author: json['author'] as String,
    );
  }

  // Entity ekak JSON (Map) ekakata harawana method eka (Local storage sēv karanna wage ona wenawa).
  Map<String, dynamic> toJson() {
    return {'id': id, 'quote': quote, 'author': author};
  }
}
