import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/deck.dart';
import '../../domain/entities/flashcard.dart';
import '../../domain/repositories/deck_repository.dart';
import '../datasources/deck_local_datasource.dart';
import '../models/deck_model.dart';
import '../models/flashcard_model.dart';

@LazySingleton(as: DeckRepository)
class DeckRepositoryImpl implements DeckRepository {
  const DeckRepositoryImpl(this._localDatasource);

  final DeckLocalDatasource _localDatasource;

  static const _uuid = Uuid();

  @override
  Future<Either<Failure, List<Deck>>> getAllDecks() async {
    try {
      final models = await _localDatasource.getAllDecks();
      return Right(models.map((m) => m.toEntity()).toList());
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, Deck>> createDeck(
    String name,
    String description,
  ) async {
    try {
      final deck = Deck(
        id: _uuid.v4(),
        name: name,
        description: description,
        createdAt: DateTime.now(),
      );
      await _localDatasource.saveDeck(DeckModel.fromEntity(deck));
      return Right(deck);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteDeck(String id) async {
    try {
      await _localDatasource.deleteDeck(id);
      return const Right(unit);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, Unit>> addCard(Flashcard card) async {
    try {
      await _localDatasource.saveCard(FlashcardModel.fromEntity(card));
      return const Right(unit);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<Flashcard>>> getCardsByDeck(
    String deckId,
  ) async {
    try {
      final models = await _localDatasource.getCardsByDeck(deckId);
      return Right(models.map((m) => m.toEntity()).toList());
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, Unit>> updateCard(Flashcard card) async {
    try {
      await _localDatasource.updateCard(FlashcardModel.fromEntity(card));
      return const Right(unit);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<Flashcard>>> getDueCards(String deckId) async {
    try {
      final models = await _localDatasource.getDueCardsByDeck(deckId);
      return Right(models.map((m) => m.toEntity()).toList());
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }
}
