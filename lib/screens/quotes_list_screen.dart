import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../models/quote.dart';
import '../presentation/cubit/quote_list_cubit.dart';
import '../services/quote_repository.dart';
import '../widgets/shimmer_loading.dart';

class QuotesListScreen extends StatelessWidget {
  const QuotesListScreen({super.key, this.repository});

  final QuoteRepository? repository;

  @override
  Widget build(BuildContext context) {
    final quoteRepository = repository ?? QuoteRepositoryImpl();

    return BlocProvider(
      create: (_) => QuoteListCubit(quoteRepository)..loadQuotes(),
      child: const QuotesListView(),
    );
  }
}

class QuotesListView extends StatelessWidget {
  const QuotesListView({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(20, 16, 20, 12),
            child: Text(
              'Quotes',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          Expanded(
            child: BlocBuilder<QuoteListCubit, QuoteListState>(
              builder: (context, state) {
                if (state is QuoteListLoading || state is QuoteListInitial) {
                  return const QuotesListShimmer();
                }

                if (state is QuoteListError) {
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
                              context.read<QuoteListCubit>().loadQuotes(),
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  );
                }

                final loadedState = state as QuoteListLoaded;
                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: loadedState.quotes.length,
                  itemBuilder: (context, index) {
                    return _buildQuoteCard(context, loadedState.quotes[index]);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuoteCard(BuildContext context, Quote quote) {
    return GestureDetector(
      onTap: () {
        context.go('/quote/${quote.id}', extra: quote);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              quote.quote,
              style: const TextStyle(
                fontSize: 15,
                color: Colors.black87,
                height: 1.4,
              ),
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
            Text(
              '- ${quote.author}',
              style: const TextStyle(fontSize: 13, color: Colors.black45),
            ),
          ],
        ),
      ),
    );
  }
}
