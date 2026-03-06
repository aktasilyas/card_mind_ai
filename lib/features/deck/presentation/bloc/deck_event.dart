part of 'deck_bloc.dart';

sealed class DeckEvent {
  const DeckEvent();
}

final class LoadDecks extends DeckEvent {
  const LoadDecks();
}

final class CreateDeckEvent extends DeckEvent {
  const CreateDeckEvent({required this.name, required this.description});

  final String name;
  final String description;
}

final class DeleteDeckEvent extends DeckEvent {
  const DeleteDeckEvent({required this.id});

  final String id;
}
