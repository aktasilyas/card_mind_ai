import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/flashcard.dart';
import '../repositories/deck_repository.dart';

@injectable
class UpdateCard extends UseCase<Unit, Flashcard> {
  UpdateCard(this._repository);

  final DeckRepository _repository;

  @override
  Future<Either<Failure, Unit>> call(Flashcard params) {
    return _repository.updateCard(params);
  }
}
