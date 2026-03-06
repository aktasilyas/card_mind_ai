import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/deck.dart';
import '../repositories/deck_repository.dart';

class CreateDeckParams {
  const CreateDeckParams({required this.name, required this.description});

  final String name;
  final String description;
}

@injectable
class CreateDeck extends UseCase<Deck, CreateDeckParams> {
  CreateDeck(this._repository);

  final DeckRepository _repository;

  @override
  Future<Either<Failure, Deck>> call(CreateDeckParams params) {
    return _repository.createDeck(params.name, params.description);
  }
}
