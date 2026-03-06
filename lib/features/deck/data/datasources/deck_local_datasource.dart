import '../models/deck_model.dart';

abstract class DeckLocalDatasource {
  Future<List<DeckModel>> getDecks();
  Future<DeckModel> createDeck(DeckModel deck);
  Future<void> deleteDeck(String id);
}
