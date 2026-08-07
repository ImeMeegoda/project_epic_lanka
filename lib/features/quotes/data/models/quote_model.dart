import '../../domain/entities/quote_entity.dart';

// API data tika Flutter objects widiyata handle karanna use karana model eka.
class QuoteModel extends QuoteEntity {
  const QuoteModel({
    required super.id,
    required super.quote,
    required super.author,
  });

  // JSON data object ekak QuoteModel ekakata convert karana factory eka.
  factory QuoteModel.fromJson(Map<String, dynamic> json) {
    return QuoteModel(
      id: json['id'] as int,
      quote: json['quote'] as String,
      author: json['author'] as String,
    );
  }

  // Domain Entity ekak Model ekakata harawana factory eka (Repository layer eke use wenawa).
  factory QuoteModel.fromEntity(QuoteEntity entity) {
    return QuoteModel(
      id: entity.id ,
      quote: entity.quote,
      author: entity.author,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    // Model eka JSON Map ekakata harawanawa (Local storage save karanna).
    return {'id': id, 'quote': quote, 'author': author};
  }

  // Model eka Domain layer ekata adala Entity ekak bawata harawanawa.
  QuoteEntity toEntity() => QuoteEntity(id: id, quote: quote, author: author);
}
