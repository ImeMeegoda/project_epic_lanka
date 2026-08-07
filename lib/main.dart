import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'features/quotes/domain/repositories/quote_repository.dart';
import 'features/quotes/presentation/blocs/random_quote_cubit.dart';
import 'injection_container.dart';
import 'router.dart';

void main() async {
  // Flutter engine eka initialize wenna ona async weda walata kalin.
  WidgetsFlutterBinding.ensureInitialized();
  
  // Dependency Injection container eka initialize karanawa.
  await DependencyInjection.init();
  
  runApp(const QuotesApp());
}

class QuotesApp extends StatelessWidget {
  const QuotesApp({super.key});

  @override
  Widget build(BuildContext context) {
    // MultiRepositoryProvider eken 'DependencyInjection' container eke thiyena 
    // repository eka app eka purama share karanawa.
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<QuoteRepository>.value(
          value: DependencyInjection.repository,
        ),
      ],
      child: BlocProvider<RandomQuoteCubit>(
        create: (context) => RandomQuoteCubit(
          getRandomQuote: DependencyInjection.getRandomQuote,
        ),
        child: MaterialApp.router(
          title: 'Quotes',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFF5AB2FF),
            ),
            useMaterial3: true,
            scaffoldBackgroundColor: Colors.white,
          ),
          routerConfig: AppRouter.router,
        ),
      ),
    );
  }
}
