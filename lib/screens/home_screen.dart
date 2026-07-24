import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../presentation/cubit/quote_cubit.dart';
import '../services/quote_repository.dart';
import '../widgets/shimmer_loading.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key, this.repository});

  final QuoteRepository? repository;

  @override
  Widget build(BuildContext context) {
    final quoteRepository = repository ?? QuoteRepositoryImpl();

    return BlocProvider(
      create: (_) => QuoteCubit(quoteRepository)..loadRandomQuote(),
      child: const HomeView(),
    );
  }
}

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            const Text(
              'Quote of the Day',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black54,
                fontWeight: FontWeight.w400,
              ),
            ),
            Expanded(
              child: BlocBuilder<QuoteCubit, QuoteState>(
                builder: (context, state) {
                  if (state is QuoteLoading || state is QuoteInitial) {
                    return const HomeShimmer();
                  }

                  if (state is QuoteError) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            state.message,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.red,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () =>
                                context.read<QuoteCubit>().loadRandomQuote(),
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    );
                  }

                  final loadedState = state as QuoteLoaded;
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '“${loadedState.quote.quote}”',
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            height: 1.4,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          '- ${loadedState.quote.author}',
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
