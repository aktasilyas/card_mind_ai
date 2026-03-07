import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/errors/failures.dart';
import '../../domain/repositories/onboarding_repository.dart';

@LazySingleton(as: OnboardingRepository)
class OnboardingRepositoryImpl implements OnboardingRepository {
  const OnboardingRepositoryImpl(this._prefs);

  final SharedPreferences _prefs;

  static const String _onboardingCompletedKey = 'onboarding_completed';

  @override
  Future<Either<Failure, bool>> isOnboardingCompleted() async {
    try {
      final bool result = _prefs.getBool(_onboardingCompletedKey) ?? false;
      return Right(result);
    } catch (e) {
      return Left(CacheFailure('Onboarding durumu okunamadı: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, Unit>> completeOnboarding() async {
    try {
      await _prefs.setBool(_onboardingCompletedKey, true);
      return const Right(unit);
    } catch (e) {
      return Left(
        CacheFailure('Onboarding tamamlanamadı: ${e.toString()}'),
      );
    }
  }
}
