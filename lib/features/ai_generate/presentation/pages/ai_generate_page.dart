import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injection.dart';
import '../bloc/ai_generate_bloc.dart';

class AiGeneratePage extends StatelessWidget {
  const AiGeneratePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<AiGenerateBloc>(),
      child: const _AiGenerateView(),
    );
  }
}

class _AiGenerateView extends StatefulWidget {
  const _AiGenerateView();

  @override
  State<_AiGenerateView> createState() => _AiGenerateViewState();
}

class _AiGenerateViewState extends State<_AiGenerateView> {
  final _textController = TextEditingController();

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('AI ile Kart Üret')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _textController,
              minLines: 3,
              maxLines: 8,
              decoration: const InputDecoration(
                hintText: 'Kart üretmek istediğiniz metni girin...',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            BlocBuilder<AiGenerateBloc, AiGenerateState>(
              buildWhen: (previous, current) =>
                  previous.cardCount != current.cardCount,
              builder: (context, state) {
                return Row(
                  children: [
                    const Text('Kart sayısı:'),
                    const SizedBox(width: 16),
                    DropdownButton<int>(
                      value: state.cardCount,
                      items: List.generate(
                        16,
                        (i) => DropdownMenuItem(
                          value: i + 5,
                          child: Text('${i + 5}'),
                        ),
                      ),
                      onChanged: (value) {
                        if (value != null) {
                          context
                              .read<AiGenerateBloc>()
                              .add(UpdateCardCount(value));
                        }
                      },
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 16),
            BlocConsumer<AiGenerateBloc, AiGenerateState>(
              listener: (context, state) {
                if (state is AiGenerateError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(state.message)),
                  );
                }
              },
              builder: (context, state) {
                return ElevatedButton(
                  onPressed: state is AiGenerateLoading
                      ? null
                      : () {
                          final text = _textController.text.trim();
                          if (text.isEmpty) return;
                          context.read<AiGenerateBloc>().add(
                                GenerateCards(text: text),
                              );
                        },
                  child: state is AiGenerateLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Kart Üret'),
                );
              },
            ),
            const SizedBox(height: 16),
            Expanded(
              child: BlocBuilder<AiGenerateBloc, AiGenerateState>(
                builder: (context, state) {
                  if (state is AiGenerateSuccess) {
                    return ListView.builder(
                      itemCount: state.cards.length,
                      itemBuilder: (context, index) {
                        final card = state.cards[index];
                        return Card(
                          margin: const EdgeInsets.only(bottom: 8),
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Soru:',
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelSmall
                                      ?.copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                      ),
                                ),
                                const SizedBox(height: 4),
                                Text(card.front),
                                const Divider(),
                                Text(
                                  'Cevap:',
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelSmall
                                      ?.copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary,
                                      ),
                                ),
                                const SizedBox(height: 4),
                                Text(card.back),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  }
                  if (state is AiGenerateLimitReached) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.lock_outline, size: 48),
                          const SizedBox(height: 16),
                          const Text(
                            'Günlük ücretsiz limitinize ulaştınız',
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 8),
                          ElevatedButton(
                            onPressed: () {
                              // TODO: Premium sayfasına yönlendir
                            },
                            child: const Text('Premium\'a Geç'),
                          ),
                        ],
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
