abstract class AppConstants {
  static const int freeAiGenerationLimit = 5;
  static const String hiveDecksBox = 'decks_box';
  static const String hiveCardsBox = 'cards_box';
  static const String dailyLimitKey = 'daily_limit_';
  static const String openAiBaseUrl = 'https://api.openai.com/v1';
  static const String openAiModel = 'gpt-4o-mini';
  static const int maxCardsPerGeneration = 20;

  // Monetization
  static const String revenueCatEntitlementId = 'premium';
  static const String bannerAdUnitId =
      'ca-app-pub-3940256099942544/6300978111';
  static const String interstitialAdUnitId =
      'ca-app-pub-3940256099942544/1033173712';
  static const int interstitialFrequency = 3;
}
