part of 'deck_bloc.dart';

sealed class DeckEvent {}

final class DeckLoadRequested extends DeckEvent {}

final class DeckCreateRequested extends DeckEvent {
  final String name;

  DeckCreateRequested({required this.name});
}

final class DeckDeleteRequested extends DeckEvent {
  final String id;

  DeckDeleteRequested({required this.id});
}
