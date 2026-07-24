class Quote {
  const Quote({required this.id, required this.quote, required this.author});

  final int id;
  final String quote;
  final String author;

  factory Quote.fromJson(Map<String, dynamic> json) {
    return Quote(id: json['id'], quote: json['quote'], author: json['author']);
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'quote': quote, 'author': author};
  }
}
