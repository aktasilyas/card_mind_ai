part of 'deck_bloc.dart';

sealed class DeckState {
  const DeckState();
}

final class DeckInitial extends DeckState {
  const DeckInitial();
}

final class DeckLoading extends DeckState {
  const DeckLoading();
}

final class DeckLoaded extends DeckState {
  const DeckLoaded(this.decks);

  final List<Deck> decks;
}

final class DeckError extends DeckState {
  const DeckError(this.message);

  final String message;
}
