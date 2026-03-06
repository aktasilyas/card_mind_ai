import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/deck_repository.dart';

class DeleteDeckParams {
  const DeleteDeckParams({required this.id});

  final String id;
}

@injectable
class DeleteDeck extends UseCase<Unit, DeleteDeckParams> {
  DeleteDeck(this._repository);

  final DeckRepository _repository;

  @override
  Future<Either<Failure, Unit>> call(DeleteDeckParams params) {
    return _repository.deleteDeck(params.id);
  }
}
