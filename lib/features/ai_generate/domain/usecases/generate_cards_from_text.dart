import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/generation_result.dart';
import '../repositories/ai_generate_repository.dart';

class GenerateCardsParams {
  const GenerateCardsParams({required this.text, required this.count});

  final String text;
  final int count;
}

@injectable
class GenerateCardsFromText
    extends UseCase<GenerationResult, GenerateCardsParams> {
  GenerateCardsFromText(this._repository, this._prefs);

  final AiGenerateRepository _repository;
  final SharedPreferences _prefs;

  @override
  Future<Either<Failure, GenerationResult>> call(
    GenerateCardsParams params,
  ) async {
    final today = DateTime.now();
    final key =
        '${AppConstants.dailyLimitKey}${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';

    final currentCount = _prefs.getInt(key) ?? 0;
    if (currentCount >= AppConstants.freeAiGenerationLimit) {
      return const Left(
        LimitExceededFailure('Günlük ücretsiz kart üretme limitinize ulaştınız'),
      );
    }

    final result = await _repository.generateCards(params.text, params.count);

    result.fold(
      (_) {},
      (_) => _prefs.setInt(key, currentCount + 1),
    );

    return result;
  }
}
