import '../../domain/entities/quote_entity.dart';

// API data tika Flutter objects widiyata handle karanna use karana model eka.
class QuoteModel extends QuoteEntity {
  const QuoteModel({
    required super.id,
    required super.quote,
    required super.author,
  });

  factory QuoteModel.fromJson(Map<String, dynamic> json) {
    return QuoteModel(
      id: json['id'] as int,
      quote: json['quote'] as String,
      author: json['author'] as String,
    );
  }

  factory QuoteModel.fromEntity(QuoteEntity entity) {
    return QuoteModel(
      id: entity.id,
      quote: entity.quote,
      author: entity.author,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {'id': id, 'quote': quote, 'author': author};
  }

  QuoteEntity toEntity() => QuoteEntity(id: id, quote: quote, author: author);
}
