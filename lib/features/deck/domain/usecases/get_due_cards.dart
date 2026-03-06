import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/flashcard.dart';
import '../repositories/deck_repository.dart';

class GetDueCardsParams {
  const GetDueCardsParams({required this.deckId});

  final String deckId;
}

@injectable
class GetDueCards extends UseCase<List<Flashcard>, GetDueCardsParams> {
  GetDueCards(this._repository);

  final DeckRepository _repository;

  @override
  Future<Either<Failure, List<Flashcard>>> call(GetDueCardsParams params) {
    return _repository.getDueCards(params.deckId);
  }
}
