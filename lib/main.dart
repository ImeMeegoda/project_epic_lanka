import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'features/quotes/data/datasources/quote_local_data_source.dart';
import 'features/quotes/data/datasources/quote_remote_data_source.dart';
import 'features/quotes/data/repositories/quote_repository_impl.dart';
import 'features/quotes/domain/repositories/quote_repository.dart';
import 'features/quotes/presentation/blocs/random_quote_cubit.dart';
import 'router.dart';

void main() {
  runApp(const QuotesApp());
}

class QuotesApp extends StatelessWidget {
  const QuotesApp({super.key});

  @override
  Widget build(BuildContext context) {
    //  Explicit Dependency Injection
    // App eka start weddima ona karana data sources tika initialize karanawa.
    // Remote eken internet data gannawa, Local eken phone eke save karana data gannawa.
    final remoteDataSource = QuoteRemoteDataSourceImpl();
    final localDataSource = QuoteLocalDataSourceImpl();

    // Creating the repository with injected data sources
    // Data sources dhekama repository ekata inject karanawa (Dependency Injection).
    // Meka nisa repository ekata thheeranaya karanna puluwan data ganna ona API ekendha nethnam Cache ekendha kiyala.
    final QuoteRepository repository = QuoteRepositoryImpl(
      remoteDataSource: remoteDataSource,
      localDataSource: localDataSource,
    );

    // MultiRepositoryProvider eken repository object eka app eka purama share karanawa.
    // BlocProvider eken logic handle karana Cubit/Bloc tika root level ekema set karanawa.
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<QuoteRepository>.value(value: repository),
      ],
      child: BlocProvider<RandomQuoteCubit>(
        create: (context) => RandomQuoteCubit(
          repository: context.read<QuoteRepository>(),
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
          routerConfig: AppRouter.router, // Navigation system eka router.dart eken gannawa.
        ),
      ),
    );
  }
}
