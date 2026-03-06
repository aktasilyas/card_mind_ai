import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/deck.dart';

abstract class DeckRepository {
  Future<Either<Failure, List<Deck>>> getDecks();
  Future<Either<Failure, Deck>> createDeck(Deck deck);
  Future<Either<Failure, Unit>> deleteDeck(String id);
}
