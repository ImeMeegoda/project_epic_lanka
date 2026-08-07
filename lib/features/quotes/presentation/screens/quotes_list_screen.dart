import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../injection_container.dart';
import '../blocs/quote_list_bloc.dart';
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
    // Me screen ekata witharak adala BLoC eka initialize karala data load karana event eka trigger karanawa.
    // UseCase eka injection container eken gannawa.
    _bloc = QuoteListBloc(getQuotes: DependencyInjection.getQuotes);
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
                  hintText: 'Search quotes...',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onChanged: (value) {
                  // User type karana query eka real-time BLoC ekata yawanawa instant search filtering karanna.
                  _bloc.add(SearchQuotesEvent(value));
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
                            onPressed: () => _bloc.add(
                              LoadQuotesEvent(),
                            ),
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    );
                  }

                  // List eka aluth karanna pahalata pull karama Refresh event eka trigger wenawa.
                  return RefreshIndicator(
                    onRefresh: () async {
                      _bloc.add(RefreshQuotesEvent());
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
