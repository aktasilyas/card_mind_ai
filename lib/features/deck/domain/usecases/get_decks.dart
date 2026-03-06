import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/deck.dart';
import '../repositories/deck_repository.dart';

@injectable
class GetDecks extends UseCase<List<Deck>, NoParams> {
  GetDecks(this._repository);

  final DeckRepository _repository;

  @override
  Future<Either<Failure, List<Deck>>> call(NoParams params) {
    return _repository.getAllDecks();
  }
}
