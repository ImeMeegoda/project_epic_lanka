class QuoteEntity {
  const QuoteEntity({
    required this.id,
    required this.quote,
    required this.author,
  });

  final int id;
  final String quote;
  final String author;

  factory QuoteEntity.fromJson(Map<String, dynamic> json) {
    return QuoteEntity(
      id: json['id'] as int,
      quote: json['quote'] as String,
      author: json['author'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'quote': quote, 'author': author};
  }
}
