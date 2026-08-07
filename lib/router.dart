import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'features/quotes/domain/entities/quote_entity.dart';
import 'features/quotes/presentation/screens/main_screen.dart';
import 'features/quotes/presentation/screens/quote_detail_screen.dart';
import 'features/quotes/presentation/screens/splash_screen.dart';

// App eke navigation system eka saha Deep Linking manage karanne me router eken.
class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/', // App eka open weddhima splash screen ekata yanna kiyanawa.
    routes: [
      // Root route - Splash Screen
      GoRoute(path: '/', builder: (context, state) => const SplashScreen()),
      
      // Home Screen - Bottom navigation thiyena main hub eka
      GoRoute(path: '/home', builder: (context, state) => const MainScreen()),
      
      // Detail Screen - Quote ekaka full details pennana page eka.
      // Dynamic route (:id) use karanawa deep linking support karanna.
      GoRoute(
        path: '/quote/:id',
        builder: (context, state) {
          // List eken detail ekata yanakota quote object eka 'extra' widiyata enawa.
          final quote = state.extra as QuoteEntity?;
          
          // Direct URL ekakin awoth path parameter eken ID eka gannawa.
          final id = int.tryParse(state.pathParameters['id'] ?? '');
          
          if (quote != null) {
            return QuoteDetailScreen(quote: quote);
          }
          
          // Quote eka nethuwa ID eka wetharak thiyenawa nam, placeholder ekak pennala data refresh karanawa.
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
