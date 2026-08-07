import 'package:flutter/material.dart';
import '../../domain/entities/quote_entity.dart';

// QuoteCard kiyanne "Reusable Widget" ekak.
// List eke okkoma quotes pennanna use karanne me widget ekama thamai.
// Meka nisa code eka "DRY" (Don't Repeat Yourself) widiyata thiyan ganna puluwan.
class QuoteCard extends StatelessWidget {
  const QuoteCard({super.key, required this.quote, required this.onTap});

  final QuoteEntity quote;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Quote text eka. Max lines 4k dala thiyenawa card eka loku wadi wenne nathi wenna.
            Text(
              quote.quote,
              style: const TextStyle(
                fontSize: 15,
                color: Colors.black87,
                height: 1.4,
              ),
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
            // Author name eka pahasuwen dakinna puluwan widiyata damma.
            Text(
              '- ${quote.author}',
              style: const TextStyle(fontSize: 13, color: Colors.black45),
            ),
          ],
        ),
      ),
    );
  }
}
