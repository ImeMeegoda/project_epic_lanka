import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'cubits/random_quote_cubit.dart';
import 'repositories/quote_repository.dart';
import 'repositories/quote_repository_impl.dart';
import 'router.dart';
import 'services/quote_storage_service.dart';

void main() {
  runApp(const QuotesApp());
}

class QuotesApp extends StatelessWidget {
  const QuotesApp({super.key});

  @override
  Widget build(BuildContext context) {
    final QuoteRepository repository = QuoteRepositoryImpl();
    final QuoteStorageService storageService = QuoteStorageService();

    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<QuoteRepository>.value(value: repository),
        RepositoryProvider<QuoteStorageService>.value(value: storageService),
      ],
      child: BlocProvider<RandomQuoteCubit>(
        create: (context) => RandomQuoteCubit(
          repository: context.read<QuoteRepository>(),
          storageService: context.read<QuoteStorageService>(),
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
