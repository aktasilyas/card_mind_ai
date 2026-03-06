import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/subscription_repository.dart';

@injectable
class PurchasePremium extends UseCase<Unit, NoParams> {
  PurchasePremium(this._repository);

  final SubscriptionRepository _repository;

  @override
  Future<Either<Failure, Unit>> call(NoParams params) {
    return _repository.purchasePremium();
  }
}
