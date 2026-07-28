import '../../domain/entities/quote_entity.dart';

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

  @override
  Map<String, dynamic> toJson() {
    return {'id': id, 'quote': quote, 'author': author};
  }

  QuoteEntity toEntity() => QuoteEntity(id: id, quote: quote, author: author);
}
