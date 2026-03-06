import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/subscription_status.dart';
import '../repositories/subscription_repository.dart';

@injectable
class RestorePurchases extends UseCase<SubscriptionStatus, NoParams> {
  RestorePurchases(this._repository);

  final SubscriptionRepository _repository;

  @override
  Future<Either<Failure, SubscriptionStatus>> call(NoParams params) {
    return _repository.restorePurchases();
  }
}
