import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'features/quotes/domain/entities/quote_entity.dart';
import 'features/quotes/presentation/screens/main_screen.dart';
import 'features/quotes/presentation/screens/quote_detail_screen.dart';
import 'features/quotes/presentation/screens/splash_screen.dart';

// App eke navigation system eka saha Deep Linking manage karanne me router eken.
class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(path: '/', builder: (context, state) => const SplashScreen()),
      GoRoute(path: '/home', builder: (context, state) => const MainScreen()),
      GoRoute(
        path: '/quote/:id',
        builder: (context, state) {
          final quote = state.extra as QuoteEntity?;
          final id = int.tryParse(state.pathParameters['id'] ?? '');
          if (quote != null) {
            return QuoteDetailScreen(quote: quote);
          }
          if (id != null) {
            return QuoteDetailScreen(
              quote: QuoteEntity(id: id, quote: 'Loading quote…', author: 'Loading'),
              fallbackId: id,
            );
          }
          return const Scaffold(body: Center(child: Text('Quote not found')));
        },
      ),
    ],
  );
}
