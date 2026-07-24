import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../blocs/quote_list_bloc.dart';
import '../repositories/quote_repository.dart';
import '../widgets/quote_card.dart';
import '../widgets/shimmer_loading.dart';

class QuotesListScreen extends StatefulWidget {
  const QuotesListScreen({super.key});

  @override
  State<QuotesListScreen> createState() => _QuotesListScreenState();
}

class _QuotesListScreenState extends State<QuotesListScreen> {
  late final QuoteListBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = QuoteListBloc(repository: context.read<QuoteRepository>());
    _bloc.add(LoadQuotesEvent());
  }

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<QuoteListBloc>.value(
      value: _bloc,
      child: SafeArea(
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
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search quotes',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                ),
                onChanged: (value) {
                  context.read<QuoteListBloc>().add(SearchQuotesEvent(value));
                },
              ),
            ),
            Expanded(
              child: BlocBuilder<QuoteListBloc, QuoteListState>(
                builder: (context, state) {
                  if (state.isLoading) {
                    return const QuotesListShimmer();
                  }

                  if (state.error != null && state.quotes.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            state.error!,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.red,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () => context.read<QuoteListBloc>().add(
                              LoadQuotesEvent(),
                            ),
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    );
                  }

                  return RefreshIndicator(
                    onRefresh: () async {
                      context.read<QuoteListBloc>().add(RefreshQuotesEvent());
                    },
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: state.visibleQuotes.length,
                      itemBuilder: (context, index) {
                        final quote = state.visibleQuotes[index];
                        return QuoteCard(
                          quote: quote,
                          onTap: () {
                            context.push('/quote/${quote.id}', extra: quote);
                          },
                        );
                      },
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
