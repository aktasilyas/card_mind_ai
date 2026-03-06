import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injection.dart';
import '../bloc/deck_bloc.dart';

class DeckPage extends StatelessWidget {
  const DeckPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<DeckBloc>()..add(const LoadDecks()),
      child: const _DeckView(),
    );
  }
}

class _DeckView extends StatelessWidget {
  const _DeckView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Decks'),
      ),
      body: BlocBuilder<DeckBloc, DeckState>(
        builder: (context, state) {
          return switch (state) {
            DeckInitial() => const SizedBox.shrink(),
            DeckLoading() => const Center(child: CircularProgressIndicator()),
            DeckLoaded(:final decks) => decks.isEmpty
                ? const Center(child: Text('No decks yet. Create one!'))
                : ListView.builder(
                    itemCount: decks.length,
                    padding: const EdgeInsets.all(16),
                    itemBuilder: (context, index) {
                      final deck = decks[index];
                      return Card(
                        child: ListTile(
                          title: Text(deck.name),
                          subtitle: Text(deck.description),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete_outline),
                            onPressed: () {
                              context
                                  .read<DeckBloc>()
                                  .add(DeleteDeckEvent(id: deck.id));
                            },
                          ),
                        ),
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
                      onPressed: () {
                        context.read<DeckBloc>().add(const LoadDecks());
                      },
                      child: const Text('Retry'),
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
          title: const Text('Create Deck'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Name'),
                autofocus: true,
              ),
              const SizedBox(height: 8),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Cancel'),
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
              child: const Text('Create'),
            ),
          ],
        );
      },
    );
  }
}
