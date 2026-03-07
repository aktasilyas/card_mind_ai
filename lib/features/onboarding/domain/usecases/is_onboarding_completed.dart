import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/onboarding_repository.dart';

@lazySingleton
class IsOnboardingCompleted extends UseCase<bool, NoParams> {
  IsOnboardingCompleted(this._repository);

  final OnboardingRepository _repository;

  @override
  Future<Either<Failure, bool>> call(NoParams params) {
    return _repository.isOnboardingCompleted();
  }
}
