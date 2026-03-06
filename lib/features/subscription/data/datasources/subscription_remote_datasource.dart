import 'package:injectable/injectable.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../../domain/entities/subscription_status.dart';

abstract class SubscriptionRemoteDatasource {
  Future<SubscriptionStatus> getCustomerInfo();
  Future<SubscriptionStatus> purchasePackage();
  Future<SubscriptionStatus> restorePurchases();
}

@LazySingleton(as: SubscriptionRemoteDatasource)
class SubscriptionRemoteDatasourceImpl implements SubscriptionRemoteDatasource {
  SubscriptionStatus _mapCustomerInfo(CustomerInfo customerInfo) {
    final entitlement = customerInfo
        .entitlements.all[AppConstants.revenueCatEntitlementId];

    if (entitlement != null && entitlement.isActive) {
      final expiryDate = entitlement.expirationDate != null
          ? DateTime.tryParse(entitlement.expirationDate!)
          : null;
      return SubscriptionStatus(
        tier: SubscriptionTier.premium,
        expiryDate: expiryDate,
      );
    }

    return const SubscriptionStatus(tier: SubscriptionTier.free);
  }

  @override
  Future<SubscriptionStatus> getCustomerInfo() async {
    try {
      final customerInfo = await Purchases.getCustomerInfo();
      return _mapCustomerInfo(customerInfo);
    } catch (e) {
      throw PurchaseException(message: e.toString());
    }
  }

  @override
  Future<SubscriptionStatus> purchasePackage() async {
    try {
      final offerings = await Purchases.getOfferings();
      final currentOffering = offerings.current;

      if (currentOffering == null || currentOffering.availablePackages.isEmpty) {
        throw const PurchaseException(
          message: 'Mevcut paket bulunamadı',
        );
      }

      final package = currentOffering.availablePackages.first;
      final purchaseResult =
          await Purchases.purchase(PurchaseParams.package(package));
      return _mapCustomerInfo(purchaseResult.customerInfo);
    } on PurchaseException {
      rethrow;
    } catch (e) {
      throw PurchaseException(message: e.toString());
    }
  }

  @override
  Future<SubscriptionStatus> restorePurchases() async {
    try {
      final customerInfo = await Purchases.restorePurchases();
      return _mapCustomerInfo(customerInfo);
    } catch (e) {
      throw PurchaseException(message: e.toString());
    }
  }
}
