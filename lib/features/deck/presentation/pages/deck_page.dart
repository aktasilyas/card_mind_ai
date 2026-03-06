import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_theme.dart';
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Destelerim'),
        actions: [
          IconButton(
            icon: const Icon(Icons.workspace_premium),
            onPressed: () => context.push('/subscription'),
          ),
        ],
      ),
      body: BlocBuilder<DeckBloc, DeckState>(
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
                          const Text(
                            'Henüz deste yok,\nilk desteni oluştur!',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 18),
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
                      return _DeckCard(deck: deck);
                    },
                  ),
            DeckError(:final message) => Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(message),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () =>
                          context.read<DeckBloc>().add(const LoadDecks()),
                      child: const Text('Tekrar Dene'),
                    ),
                  ],
                ),
              ),
          };
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCreateDeckDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showCreateDeckDialog(BuildContext context) {
    final nameController = TextEditingController();
    final descriptionController = TextEditingController();
    final bloc = context.read<DeckBloc>();

    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Yeni Deste Oluştur'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'İsim'),
                autofocus: true,
              ),
              const SizedBox(height: 8),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(labelText: 'Açıklama'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('İptal'),
            ),
            FilledButton(
              onPressed: () {
                final name = nameController.text.trim();
                if (name.isNotEmpty) {
                  bloc.add(CreateDeckEvent(
                    name: name,
                    description: descriptionController.text.trim(),
                  ));
                  Navigator.of(dialogContext).pop();
                }
              },
              child: const Text('Oluştur'),
            ),
          ],
        );
      },
    );
  }
}

class _DeckCard extends StatelessWidget {
  const _DeckCard({required this.deck});

  final Deck deck;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push('/deck/${deck.id}'),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: AppTheme.glassmorphism,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: Theme.of(context)
                      .colorScheme
                      .primary
                      .withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.style,
                  color: Theme.of(context).colorScheme.primary,
                ),
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
                      ),
                    ),
                    if (deck.description.isNotEmpty)
                      Text(
                        deck.description,
                        style: TextStyle(
                          fontSize: 13,
                          color: Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withValues(alpha: 0.6),
                        ),
                      ),
                  ],
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.amber.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${deck.cardCount} kart',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.amber.shade700,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                icon: const Icon(Icons.delete_outline, size: 20),
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
