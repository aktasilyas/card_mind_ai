import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/subscription_status.dart';
import '../../domain/repositories/subscription_repository.dart';
import '../datasources/subscription_remote_datasource.dart';

@LazySingleton(as: SubscriptionRepository)
class SubscriptionRepositoryImpl implements SubscriptionRepository {
  const SubscriptionRepositoryImpl(this._remoteDatasource);

  final SubscriptionRemoteDatasource _remoteDatasource;

  @override
  Future<Either<Failure, SubscriptionStatus>> getSubscriptionStatus() async {
    try {
      final status = await _remoteDatasource.getCustomerInfo();
      return Right(status);
    } on PurchaseException catch (e) {
      return Left(PurchaseFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, Unit>> purchasePremium() async {
    try {
      await _remoteDatasource.purchasePackage();
      return const Right(unit);
    } on PurchaseException catch (e) {
      return Left(PurchaseFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, SubscriptionStatus>> restorePurchases() async {
    try {
      final status = await _remoteDatasource.restorePurchases();
      return Right(status);
    } on PurchaseException catch (e) {
      return Left(PurchaseFailure(e.message));
    }
  }
}
