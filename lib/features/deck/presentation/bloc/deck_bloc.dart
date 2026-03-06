import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/usecases/usecase.dart';
import '../../domain/entities/deck.dart';
import '../../domain/usecases/create_deck.dart';
import '../../domain/usecases/delete_deck.dart';
import '../../domain/usecases/get_decks.dart';

part 'deck_event.dart';
part 'deck_state.dart';

@injectable
class DeckBloc extends Bloc<DeckEvent, DeckState> {
  DeckBloc(this._getDecks, this._createDeck, this._deleteDeck)
      : super(const DeckInitial()) {
    on<LoadDecks>(_onLoadDecks);
    on<CreateDeckEvent>(_onCreateDeck);
    on<DeleteDeckEvent>(_onDeleteDeck);
  }

  final GetDecks _getDecks;
  final CreateDeck _createDeck;
  final DeleteDeck _deleteDeck;

  Future<void> _onLoadDecks(LoadDecks event, Emitter<DeckState> emit) async {
    emit(const DeckLoading());
    final result = await _getDecks(const NoParams());
    result.fold(
      (failure) => emit(DeckError(failure.message)),
      (decks) => emit(DeckLoaded(decks)),
    );
  }

  Future<void> _onCreateDeck(
    CreateDeckEvent event,
    Emitter<DeckState> emit,
  ) async {
    emit(const DeckLoading());
    final result = await _createDeck(
      CreateDeckParams(name: event.name, description: event.description),
    );
    result.fold(
      (failure) => emit(DeckError(failure.message)),
      (_) => add(const LoadDecks()),
    );
  }

  Future<void> _onDeleteDeck(
    DeleteDeckEvent event,
    Emitter<DeckState> emit,
  ) async {
    emit(const DeckLoading());
    final result = await _deleteDeck(DeleteDeckParams(id: event.id));
    result.fold(
      (failure) => emit(DeckError(failure.message)),
      (_) => add(const LoadDecks()),
    );
  }
}
