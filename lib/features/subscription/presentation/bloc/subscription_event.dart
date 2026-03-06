part of 'subscription_bloc.dart';

sealed class SubscriptionEvent {
  const SubscriptionEvent();
}

final class LoadSubscription extends SubscriptionEvent {
  const LoadSubscription();
}

final class PurchasePremiumEvent extends SubscriptionEvent {
  const PurchasePremiumEvent();
}

final class RestorePurchasesEvent extends SubscriptionEvent {
  const RestorePurchasesEvent();
}
