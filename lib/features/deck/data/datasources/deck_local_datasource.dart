import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/exceptions.dart';
import '../models/deck_model.dart';
import '../models/flashcard_model.dart';

abstract class DeckLocalDatasource {
  Future<List<DeckModel>> getAllDecks();
  Future<void> saveDeck(DeckModel deck);
  Future<void> deleteDeck(String id);
  Future<void> saveCard(FlashcardModel card);
  Future<List<FlashcardModel>> getCardsByDeck(String deckId);
}

@LazySingleton(as: DeckLocalDatasource)
class DeckLocalDatasourceImpl implements DeckLocalDatasource {
  const DeckLocalDatasourceImpl(this._decksBox, this._cardsBox);

  final Box<DeckModel> _decksBox;
  final Box<FlashcardModel> _cardsBox;

  @override
  Future<List<DeckModel>> getAllDecks() async {
    try {
      return _decksBox.values.toList();
    } catch (e) {
      throw CacheException(message: e.toString());
    }
  }

  @override
  Future<void> saveDeck(DeckModel deck) async {
    try {
      await _decksBox.put(deck.id, deck);
    } catch (e) {
      throw CacheException(message: e.toString());
    }
  }

  @override
  Future<void> deleteDeck(String id) async {
    try {
      await _decksBox.delete(id);
      final cardKeys = _cardsBox.values
          .where((card) => card.deckId == id)
          .map((card) => card.id)
          .toList();
      for (final key in cardKeys) {
        await _cardsBox.delete(key);
      }
    } catch (e) {
      throw CacheException(message: e.toString());
    }
  }

  @override
  Future<void> saveCard(FlashcardModel card) async {
    try {
      await _cardsBox.put(card.id, card);
    } catch (e) {
      throw CacheException(message: e.toString());
    }
  }

  @override
  Future<List<FlashcardModel>> getCardsByDeck(String deckId) async {
    try {
      return _cardsBox.values.where((card) => card.deckId == deckId).toList();
    } catch (e) {
      throw CacheException(message: e.toString());
    }
  }
}
