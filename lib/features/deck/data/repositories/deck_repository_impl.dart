import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../domain/entities/deck.dart';
import '../../domain/repositories/deck_repository.dart';
import '../datasources/deck_local_datasource.dart';

class DeckRepositoryImpl implements DeckRepository {
  final DeckLocalDatasource localDatasource;

  const DeckRepositoryImpl({required this.localDatasource});

  @override
  Future<Either<Failure, List<Deck>>> getDecks() {
    // TODO: implement
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, Deck>> createDeck(Deck deck) {
    // TODO: implement
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, Unit>> deleteDeck(String id) {
    // TODO: implement
    throw UnimplementedError();
  }
}
