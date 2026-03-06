import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/subscription_status.dart';

abstract class SubscriptionRepository {
  Future<Either<Failure, SubscriptionStatus>> getSubscriptionStatus();
  Future<Either<Failure, Unit>> purchasePremium();
  Future<Either<Failure, SubscriptionStatus>> restorePurchases();
}
