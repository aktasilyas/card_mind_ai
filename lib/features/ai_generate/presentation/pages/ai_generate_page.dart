import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injection.dart';
import '../../../deck/domain/entities/flashcard.dart';
import '../../../deck/domain/usecases/add_card.dart';
import '../bloc/ai_generate_bloc.dart';

class AiGeneratePage extends StatelessWidget {
  const AiGeneratePage({super.key, required this.deckId});

  final String deckId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<AiGenerateBloc>(),
      child: _AiGenerateView(deckId: deckId),
    );
  }
}

class _AiGenerateView extends StatefulWidget {
  const _AiGenerateView({required this.deckId});

  final String deckId;

  @override
  State<_AiGenerateView> createState() => _AiGenerateViewState();
}

class _AiGenerateViewState extends State<_AiGenerateView> {
  final _textController = TextEditingController();
  final _addCard = getIt<AddCard>();
  bool _saving = false;

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  Future<void> _addAllCards(List<Flashcard> cards) async {
    setState(() => _saving = true);

    int addedCount = 0;
    for (final card in cards) {
      final cardWithDeck = card.copyWith(deckId: widget.deckId);
      final result = await _addCard(cardWithDeck);
      result.fold((_) {}, (_) => addedCount++);
    }

    if (!mounted) return;
    setState(() => _saving = false);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$addedCount kart desteye eklendi')),
    );

    if (addedCount > 0) {
      context.pop();
    }
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
                    return Column(
                      children: [
                        Expanded(
                          child: ListView.builder(
                            itemCount: state.cards.length,
                            itemBuilder: (context, index) {
                              final card = state.cards[index];
                              return Card(
                                margin: const EdgeInsets.only(bottom: 8),
                                child: Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                          ),
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          width: double.infinity,
                          child: FilledButton.icon(
                            onPressed: _saving
                                ? null
                                : () => _addAllCards(state.cards),
                            icon: _saving
                                ? const SizedBox(
                                    height: 18,
                                    width: 18,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Icon(Icons.add),
                            label: Text(
                              _saving
                                  ? 'Ekleniyor...'
                                  : 'Tümünü Desteye Ekle (${state.cards.length})',
                            ),
                          ),
                        ),
                      ],
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
                            onPressed: () => context.push('/subscription'),
                            child: const Text("Premium'a Geç"),
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
