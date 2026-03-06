enum SubscriptionTier { free, premium }

class SubscriptionStatus {
  const SubscriptionStatus({required this.tier, this.expiryDate});

  final SubscriptionTier tier;
  final DateTime? expiryDate;

  bool get isActive =>
      tier == SubscriptionTier.premium &&
      (expiryDate == null || expiryDate!.isAfter(DateTime.now()));
}
