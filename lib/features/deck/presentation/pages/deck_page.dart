import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/game_header.dart';
import '../../domain/entities/deck.dart';
import '../bloc/deck_bloc.dart';

class DeckPage extends StatelessWidget {
  const DeckPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const _DeckView();
  }
}

class _DeckView extends StatelessWidget {
  const _DeckView();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      body: Column(
        children: [
          const GameHeader(),
          Expanded(
            child: BlocBuilder<DeckBloc, DeckState>(
              builder: (context, state) {
                return switch (state) {
                  DeckInitial() => const SizedBox.shrink(),
                  DeckLoading() =>
                    const Center(child: CircularProgressIndicator()),
                  DeckLoaded(:final decks) => decks.isEmpty
                      ? Center(
                          child: Padding(
                            padding: const EdgeInsets.all(32),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.style_outlined,
                                  size: 80,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .primary
                                      .withValues(alpha: 0.4),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  l10n.noDecksYet,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(fontSize: 18),
                                ),
                                const SizedBox(height: 24),
                                FilledButton.icon(
                                  onPressed: () =>
                                      _showCreateDeckSheet(context),
                                  icon: const Icon(Icons.add),
                                  label: Text(l10n.createDeck),
                                ),
                              ],
                            ),
                          ),
                        )
                      : ListView.builder(
                          itemCount: decks.length,
                          padding: const EdgeInsets.all(16),
                          itemBuilder: (context, index) {
                            final deck = decks[index];
                            return _DeckCard(
                              deck: deck,
                              gradientIndex: index,
                            );
                          },
                        ),
                  DeckError(:final message) => Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(message),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () => context
                                .read<DeckBloc>()
                                .add(const LoadDecks()),
                            child: Text(l10n.retry),
                          ),
                        ],
                      ),
                    ),
                };
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCreateDeckSheet(context),
        backgroundColor: AppTheme.duoGreen,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  void _showCreateDeckSheet(BuildContext context) {
    final nameController = TextEditingController();
    final descriptionController = TextEditingController();
    final bloc = context.read<DeckBloc>();
    final l10n = AppLocalizations.of(context)!;

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetContext) {
        return Padding(
          padding: EdgeInsets.only(
            left: 24,
            right: 24,
            top: 24,
            bottom: MediaQuery.of(sheetContext).viewInsets.bottom + 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                l10n.newDeck,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: l10n.deckName),
                autofocus: true,
              ),
              const SizedBox(height: 8),
              TextField(
                controller: descriptionController,
                decoration: InputDecoration(labelText: l10n.deckDescription),
              ),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: () {
                  final name = nameController.text.trim();
                  if (name.isNotEmpty) {
                    bloc.add(CreateDeckEvent(
                      name: name,
                      description: descriptionController.text.trim(),
                    ));
                    Navigator.of(sheetContext).pop();
                  }
                },
                child: Text(l10n.create),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _DeckCard extends StatelessWidget {
  const _DeckCard({required this.deck, required this.gradientIndex});

  final Deck deck;
  final int gradientIndex;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colors =
        AppTheme.deckGradients[gradientIndex % AppTheme.deckGradients.length];

    return GestureDetector(
      onTap: () => context.go('/deck/${deck.id}'),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: colors,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: colors[0].withValues(alpha: 0.3),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.style, color: Colors.white),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      deck.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    if (deck.description.isNotEmpty)
                      Text(
                        deck.description,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.white.withValues(alpha: 0.8),
                        ),
                      ),
                  ],
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  l10n.cardCount(deck.cardCount),
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                icon: const Icon(Icons.delete_outline,
                    size: 20, color: Colors.white70),
                onPressed: () => context
                    .read<DeckBloc>()
                    .add(DeleteDeckEvent(id: deck.id)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
