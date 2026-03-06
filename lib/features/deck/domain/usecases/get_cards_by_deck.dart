import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/flashcard.dart';
import '../repositories/deck_repository.dart';

class GetCardsByDeckParams {
  const GetCardsByDeckParams({required this.deckId});

  final String deckId;
}

@injectable
class GetCardsByDeck extends UseCase<List<Flashcard>, GetCardsByDeckParams> {
  GetCardsByDeck(this._repository);

  final DeckRepository _repository;

  @override
  Future<Either<Failure, List<Flashcard>>> call(GetCardsByDeckParams params) {
    return _repository.getCardsByDeck(params.deckId);
  }
}
