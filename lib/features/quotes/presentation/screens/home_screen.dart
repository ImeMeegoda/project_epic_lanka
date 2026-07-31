import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/random_quote_cubit.dart';
import '../widgets/shimmer_loading.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // [SPECIAL PART] - Screen eka load weddima random quote ekak fetch karanna kiyala Cubit ekata kiyanawa.
    context.read<RandomQuoteCubit>().loadRandomQuote();
  }

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
            // [SPECIAL PART] - Cubit eke state eka anuwa UI eka change wenne me BlocBuilder eken.
            Expanded(
              child: BlocBuilder<RandomQuoteCubit, RandomQuoteState>(
                builder: (context, state) {
                  if (state.isLoading) {
                    return const HomeShimmer();
                  }

                  if (state.error != null && state.quote == null) {
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
                          if (state.failure != null) ...[
                            const SizedBox(height: 8),
                            Text(
                              'Reason: ${state.failure!.kind.name}',
                              style: const TextStyle(
                                fontSize: 13,
                                color: Colors.black54,
                              ),
                            ),
                          ],
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () => context
                                .read<RandomQuoteCubit>()
                                .loadRandomQuote(),
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    );
                  }

                  final quote = state.quote!;
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '“${quote.quote}”',
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            height: 1.4,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          '- ${quote.author}',
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
