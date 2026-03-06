part of 'deck_bloc.dart';

sealed class DeckState {}

final class DeckInitial extends DeckState {}

final class DeckLoading extends DeckState {}

final class DeckLoaded extends DeckState {
  final List<Deck> decks;

  DeckLoaded({required this.decks});
}

final class DeckError extends DeckState {
  final String message;

  DeckError({required this.message});
}
