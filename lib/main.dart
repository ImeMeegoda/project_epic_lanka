import 'package:flutter/material.dart';

import 'app/router.dart';

void main() {
  // App starts here and hands off to the typed router flow.
  runApp(const QuotesApp());
}

class QuotesApp extends StatelessWidget {
  const QuotesApp({super.key});

  @override
  Widget build(BuildContext context) {
    final router = AppRouter().buildRouter();

    return MaterialApp.router(
      title: 'Quotes',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF5AB2FF)),
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.white,
      ),
      routerConfig: router,
    );
  }
}
