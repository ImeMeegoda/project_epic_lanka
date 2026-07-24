import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../models/quote.dart';
import '../repositories/quote_repository.dart';
import '../services/quote_storage_service.dart';

class QuoteDetailScreen extends StatefulWidget {
  const QuoteDetailScreen({super.key, required this.quote, this.fallbackId});

  final Quote quote;
  final int? fallbackId;

  @override
  State<QuoteDetailScreen> createState() => _QuoteDetailScreenState();
}

class _QuoteDetailScreenState extends State<QuoteDetailScreen> {
  late Quote _quote;
  bool _isFavorite = false;

  @override
  void initState() {
    super.initState();
    _quote = widget.quote;
    _loadFavoriteState();
    if (widget.fallbackId != null) {
      _loadQuoteById();
    }
  }

  Future<void> _loadFavoriteState() async {
    final favorites = await context
        .read<QuoteStorageService>()
        .getFavoriteQuotes();
    if (!mounted) {
      return;
    }
    setState(() {
      _isFavorite = favorites.any((favorite) => favorite.id == _quote.id);
    });
  }

  Future<void> _toggleFavorite() async {
    final storage = context.read<QuoteStorageService>();
    if (_isFavorite) {
      await storage.removeFavoriteQuote(_quote);
      setState(() {
        _isFavorite = false;
      });
      return;
    }
    await storage.saveFavoriteQuote(_quote);
    setState(() {
      _isFavorite = true;
    });
  }

  Future<void> _loadQuoteById() async {
    try {
      final repository = context.read<QuoteRepository>();
      final refreshedQuote = await repository.getQuoteById(_quote.id);
      if (!mounted) {
        return;
      }
      setState(() {
        _quote = refreshedQuote;
      });
    } catch (_) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Unable to refresh this quote right now.'),
        ),
      );
    }
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
                    onPressed: () => context.canPop()
                        ? context.pop()
                        : Navigator.pop(context),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: Icon(
                      _isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: Colors.red,
                    ),
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
                        '“${_quote.quote}”',
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        '- ${_quote.author}',
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.black54,
                        ),
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton.icon(
                        onPressed: _loadQuoteById,
                        icon: const Icon(Icons.refresh),
                        label: const Text('Refresh detail'),
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
