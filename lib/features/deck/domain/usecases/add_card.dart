import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/flashcard.dart';
import '../repositories/deck_repository.dart';

@injectable
class AddCard extends UseCase<Unit, Flashcard> {
  AddCard(this._repository);

  final DeckRepository _repository;

  @override
  Future<Either<Failure, Unit>> call(Flashcard params) {
    return _repository.addCard(params);
  }
}
