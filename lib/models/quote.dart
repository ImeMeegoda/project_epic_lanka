import '../features/quotes/domain/entities/quote_entity.dart';

class Quote extends QuoteEntity {
  const Quote({required super.id, required super.quote, required super.author});

  factory Quote.fromJson(Map<String, dynamic> json) {
    return Quote(
      id: json['id'] as int,
      quote: json['quote'] as String,
      author: json['author'] as String,
    );
  }

  factory Quote.fromEntity(QuoteEntity entity) {
    return Quote(id: entity.id, quote: entity.quote, author: entity.author);
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'quote': quote, 'author': author};
  }
}
