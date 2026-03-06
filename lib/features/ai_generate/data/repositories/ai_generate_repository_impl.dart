import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../deck/domain/entities/flashcard.dart';
import '../../domain/entities/generation_result.dart';
import '../../domain/repositories/ai_generate_repository.dart';
import '../datasources/ai_card_remote_datasource.dart';

@LazySingleton(as: AiGenerateRepository)
class AiGenerateRepositoryImpl implements AiGenerateRepository {
  const AiGenerateRepositoryImpl(this._remoteDatasource);

  final AiCardRemoteDatasource _remoteDatasource;

  static const _uuid = Uuid();

  @override
  Future<Either<Failure, GenerationResult>> generateCards(
    String text,
    int count,
  ) async {
    try {
      final models = await _remoteDatasource.generateCards(text, count);
      final now = DateTime.now();

      final cards = models
          .map(
            (m) => Flashcard(
              id: _uuid.v4(),
              deckId: '',
              front: m.front,
              back: m.back,
              dueDate: now,
            ),
          )
          .toList();

      return Right(
        GenerationResult(
          generatedCards: cards,
          inputText: text,
          generatedAt: now,
        ),
      );
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    }
  }
}
