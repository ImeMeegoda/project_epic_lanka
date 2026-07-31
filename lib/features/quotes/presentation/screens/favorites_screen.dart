import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/quote_entity.dart';
import '../../domain/repositories/quote_repository.dart';
import 'quote_detail_screen.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  late Future<List<QuoteEntity>> _favoritesFuture;

  @override
  void initState() {
    super.initState();
    _favoritesFuture = context.read<QuoteRepository>().getFavoriteQuotes();
  }

  Future<void> _refreshFavorites() async {
    setState(() {
      _favoritesFuture = context
          .read<QuoteRepository>()
          .getFavoriteQuotes();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorites'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      // Repository eken save karapu favorites tika asynchronous widiyata ganna FutureBuilder use karanawa.
      body: FutureBuilder<List<QuoteEntity>>(
        future: _favoritesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No favorites saved yet.'));
          }

          final favorites = snapshot.data!;

          return RefreshIndicator(
            onRefresh: _refreshFavorites,
            child: ListView.builder(
              itemCount: favorites.length,
              itemBuilder: (context, index) {
                final quote = favorites[index];
                return ListTile(
                  title: Text('“${quote.quote}”'),
                  subtitle: Text('- ${quote.author}'),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => QuoteDetailScreen(quote: quote),
                      ),
                    );
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }
}
