import 'package:flutter/material.dart';

import '../models/quote.dart';
import '../services/quote_storage_service.dart';

class QuoteDetailScreen extends StatefulWidget {
  const QuoteDetailScreen({super.key, required this.quote});

  final Quote quote;

  @override
  State<QuoteDetailScreen> createState() => _QuoteDetailScreenState();
}

class _QuoteDetailScreenState extends State<QuoteDetailScreen> {
  final QuoteStorageService _storageService = QuoteStorageService();

  // Local UI state for whether this quote is saved as a favorite.
  bool _isFavorite = false;

  @override
  void initState() {
    super.initState();
    _loadFavoriteState();
    _storageService.cacheRecentQuote(widget.quote);
  }

  // Load whether this quote is currently stored as a favorite.
  Future<void> _loadFavoriteState() async {
    final isFavorite = await _storageService.isFavorite(widget.quote.id);
    if (!mounted) return;
    setState(() {
      _isFavorite = isFavorite;
    });
  }

  // Toggle favorite state and persist the change in storage.
  Future<void> _toggleFavorite() async {
    await _storageService.toggleFavorite(widget.quote);
    final isFavorite = await _storageService.isFavorite(widget.quote.id);
    if (!mounted) return;
    setState(() {
      _isFavorite = isFavorite;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, size: 28),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  const Spacer(),
                  IconButton(
                    icon: Icon(
                      _isFavorite ? Icons.favorite : Icons.favorite_border,
                      size: 28,
                      color: _isFavorite ? Colors.red : Colors.black54,
                    ),
                    // Tapping this button updates storage and the UI state.
                    onPressed: _toggleFavorite,
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '“${widget.quote.quote}”',
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        '- ${widget.quote.author}',
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
