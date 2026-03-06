import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/deck.dart';
import '../entities/flashcard.dart';

abstract class DeckRepository {
  Future<Either<Failure, List<Deck>>> getAllDecks();
  Future<Either<Failure, Deck>> createDeck(String name, String description);
  Future<Either<Failure, Unit>> deleteDeck(String id);
  Future<Either<Failure, Unit>> addCard(Flashcard card);
  Future<Either<Failure, List<Flashcard>>> getCardsByDeck(String deckId);
}
