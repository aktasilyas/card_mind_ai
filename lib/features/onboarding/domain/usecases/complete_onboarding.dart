import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/onboarding_repository.dart';

@lazySingleton
class CompleteOnboarding extends UseCase<Unit, NoParams> {
  CompleteOnboarding(this._repository);

  final OnboardingRepository _repository;

  @override
  Future<Either<Failure, Unit>> call(NoParams params) {
    return _repository.completeOnboarding();
  }
}
