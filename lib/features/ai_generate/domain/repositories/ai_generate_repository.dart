import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/generation_result.dart';

abstract class AiGenerateRepository {
  Future<Either<Failure, GenerationResult>> generateCards(
    String text,
    int count,
  );
}
