import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injection.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/deck.dart';
import '../../domain/entities/flashcard.dart';
import '../../domain/usecases/get_cards_by_deck.dart';
import '../bloc/deck_bloc.dart';

class DeckDetailPage extends StatelessWidget {
  const DeckDetailPage({super.key, required this.deckId});

  final String deckId;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DeckBloc, DeckState>(
      builder: (context, state) {
        final deck = switch (state) {
          DeckLoaded(:final decks) =>
            decks.where((d) => d.id == deckId).firstOrNull,
          _ => null,
        };

        if (deck == null) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        return _DeckDetailView(deck: deck);
      },
    );
  }
}

class _DeckDetailView extends StatefulWidget {
  const _DeckDetailView({required this.deck});

  final Deck deck;

  @override
  State<_DeckDetailView> createState() => _DeckDetailViewState();
}

class _DeckDetailViewState extends State<_DeckDetailView> {
  final _getCardsByDeck = getIt<GetCardsByDeck>();
  List<Flashcard>? _cards;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadCards();
  }

  Future<void> _loadCards() async {
    final result = await _getCardsByDeck(
      GetCardsByDeckParams(deckId: widget.deck.id),
    );
    if (!mounted) return;
    result.fold(
      (_) => setState(() => _loading = false),
      (cards) => setState(() {
        _cards = cards;
        _loading = false;
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(widget.deck.name)),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    children: [
                      Expanded(
                        child: FilledButton.icon(
                          onPressed: () =>
                              context.push('/study/${widget.deck.id}'),
                          icon: const Icon(Icons.play_arrow),
                          label: Text(l10n.startStudy),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () =>
                              context.push('/ai-generate/${widget.deck.id}'),
                          icon: const Icon(Icons.auto_awesome),
                          label: Text(l10n.generateWithAi),
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(),
                Expanded(
                  child: _cards == null || _cards!.isEmpty
                      ? Center(
                          child: Text(
                            l10n.noCardsYet,
                            textAlign: TextAlign.center,
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: _cards!.length,
                          itemBuilder: (context, index) {
                            final card = _cards![index];
                            return Card(
                              child: ListTile(
                                title: Text(card.front),
                                subtitle: Text(card.back),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
    );
  }
}
