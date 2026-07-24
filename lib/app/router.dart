import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../models/quote.dart';
import '../screens/main_screen.dart';
import '../screens/quote_detail_screen.dart';
import '../screens/splash_screen.dart';

class AppRouter {
  AppRouter();

  GoRouter buildRouter() {
    return GoRouter(
      routes: [
        GoRoute(path: '/', builder: (context, state) => const SplashScreen()),
        GoRoute(path: '/main', builder: (context, state) => const MainScreen()),
        GoRoute(
          path: '/quote/:id',
          builder: (context, state) {
            final quote = state.extra as Quote?;
            if (quote == null) {
              return const Scaffold(
                body: Center(child: Text('Quote not found')),
              );
            }

            return QuoteDetailScreen(quote: quote);
          },
        ),
      ],
    );
  }
}
