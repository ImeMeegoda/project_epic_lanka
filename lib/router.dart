import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'models/quote.dart';
import 'screens/main_screen.dart';
import 'screens/quote_detail_screen.dart';
import 'screens/splash_screen.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(path: '/', builder: (context, state) => const SplashScreen()),
      GoRoute(path: '/home', builder: (context, state) => const MainScreen()),
      GoRoute(
        path: '/quote/:id',
        builder: (context, state) {
          final quote = state.extra as Quote?;
          final id = int.tryParse(state.pathParameters['id'] ?? '');
          if (quote != null) {
            return QuoteDetailScreen(quote: quote);
          }
          if (id != null) {
            return QuoteDetailScreen(
              quote: Quote(id: id, quote: 'Loading quote…', author: 'Loading'),
              fallbackId: id,
            );
          }
          return const Scaffold(body: Center(child: Text('Quote not found')));
        },
      ),
    ],
  );
}
