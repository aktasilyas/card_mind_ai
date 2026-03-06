part of 'subscription_bloc.dart';

sealed class SubscriptionState {
  const SubscriptionState();
}

final class SubscriptionInitial extends SubscriptionState {
  const SubscriptionInitial();
}

final class SubscriptionLoading extends SubscriptionState {
  const SubscriptionLoading();
}

final class SubscriptionLoaded extends SubscriptionState {
  const SubscriptionLoaded(this.status);

  final SubscriptionStatus status;
}

final class SubscriptionError extends SubscriptionState {
  const SubscriptionError(this.message);

  final String message;
}
