// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'CardMind AI';

  @override
  String get navHome => 'Home';

  @override
  String get navStats => 'Statistics';

  @override
  String get navSettings => 'Settings';

  @override
  String get noDecksYet => 'No decks yet,\ncreate your first deck!';

  @override
  String get createDeck => 'Create Deck';

  @override
  String get newDeck => 'Create New Deck';

  @override
  String get deckName => 'Name';

  @override
  String get deckDescription => 'Description';

  @override
  String get create => 'Create';

  @override
  String get retry => 'Retry';

  @override
  String cardCount(int count) {
    return '$count cards';
  }

  @override
  String get startStudy => 'Start Study';

  @override
  String get generateWithAi => 'Generate with AI';

  @override
  String get noCardsYet => 'No cards yet.\nTry generating cards with AI!';

  @override
  String get noCardsToStudy => 'No cards to study today!';

  @override
  String get goBack => 'Go Back';

  @override
  String get greatJob => 'Great Job!';

  @override
  String get totalCards => 'Total Cards';

  @override
  String get averageScore => 'Average Score';

  @override
  String get goToHome => 'Go to Home';

  @override
  String get tapCard => 'Tap the card';

  @override
  String get ratingWorst => 'Nothing';

  @override
  String get ratingHard => 'Hard';

  @override
  String get ratingStruggled => 'Struggled';

  @override
  String get ratingMedium => 'Medium';

  @override
  String get ratingEasy => 'Easy';

  @override
  String get ratingPerfect => 'Perfect';

  @override
  String get question => 'QUESTION';

  @override
  String get answer => 'ANSWER';

  @override
  String get tapToFlip => 'Tap to flip';

  @override
  String get statistics => 'Statistics';

  @override
  String get dailyGoal => 'Daily Goal';

  @override
  String get weeklyXp => 'Weekly XP';

  @override
  String get totalXp => 'Total XP';

  @override
  String get streak => 'Streak';

  @override
  String streakDays(int count) {
    return '$count days';
  }

  @override
  String get achievement => 'Achievement';

  @override
  String get totalCardsStudied => 'Total Cards';

  @override
  String get badges => 'Badges';

  @override
  String get noBadgesYet => 'No badges earned yet.\nKeep studying!';

  @override
  String get mon => 'Mon';

  @override
  String get tue => 'Tue';

  @override
  String get wed => 'Wed';

  @override
  String get thu => 'Thu';

  @override
  String get fri => 'Fri';

  @override
  String get sat => 'Sat';

  @override
  String get sun => 'Sun';

  @override
  String get settings => 'Settings';

  @override
  String get study => 'Study';

  @override
  String get notifications => 'Notifications';

  @override
  String get appearance => 'Appearance';

  @override
  String get subscription => 'Subscription';

  @override
  String get dailyGoalSetting => 'Daily Goal';

  @override
  String get cardsPerDay => 'cards/day';

  @override
  String get dailyReminder => 'Daily Reminder';

  @override
  String reminderOn(String time) {
    return 'On — $time';
  }

  @override
  String get reminderOff => 'Off';

  @override
  String get theme => 'Theme';

  @override
  String get themeLight => 'Light';

  @override
  String get themeDark => 'Dark';

  @override
  String get themeSystem => 'System';

  @override
  String get cardMindPremium => 'CardMind Premium';

  @override
  String get premiumActive => 'Active — All features unlocked';

  @override
  String get premiumDescription => 'PDF, voice input and more';

  @override
  String get upgradeToPremium => 'Upgrade to Premium';

  @override
  String get aiCardGenerator => 'AI Card Generator';

  @override
  String get uploadFromFile => 'Upload from File';

  @override
  String get listening => 'Listening...';

  @override
  String get enterTextHint => 'Enter topic or text here...';

  @override
  String get cardCountLabel => 'Card Count';

  @override
  String get generateCards => 'Generate Cards';

  @override
  String cardsGenerated(int count) {
    return '$count cards generated';
  }

  @override
  String saveAll(int count) {
    return 'Save All ($count)';
  }

  @override
  String get dailyLimitReached => 'Daily Limit Reached';

  @override
  String get premiumUnlimited =>
      'Generate unlimited cards with Premium and unlock all features.';

  @override
  String get micPermissionRequired => 'Microphone permission required';

  @override
  String cardsAddedToDeck(int count) {
    return '$count cards added to deck';
  }

  @override
  String get premium => 'Premium';

  @override
  String get premiumActiveTitle => 'Premium Active';

  @override
  String get allFeaturesAccess => 'You have access to all features.';

  @override
  String get feature => 'Feature';

  @override
  String get free => 'Free';

  @override
  String get ads => 'Ads';

  @override
  String get adsYes => 'Yes';

  @override
  String get adsNo => 'No';

  @override
  String get aiCardGeneration => 'AI Card Generation';

  @override
  String get fivePerDay => '5/day';

  @override
  String get unlimited => 'Unlimited';

  @override
  String get prioritySupport => 'Priority Support';

  @override
  String get premiumPlans => 'Premium Plans';

  @override
  String get monthly => 'Monthly';

  @override
  String get yearly => 'Yearly';

  @override
  String get restorePurchases => 'Restore Purchases';

  @override
  String get premiumFeatureOnly => 'This feature is for Premium users only.';

  @override
  String get start => 'START';

  @override
  String get next => 'NEXT';

  @override
  String get smartStudy => 'Study smart, learn more';

  @override
  String get aiPoweredLearning => 'AI-powered learning';

  @override
  String get whatWeOffer => 'What do we offer?';

  @override
  String get powerfulTools => 'Powerful tools to accelerate your learning';

  @override
  String get aiCardGenerationFeature => 'AI Card Generation';

  @override
  String get aiCardGenerationDesc => 'Create flashcards instantly with AI';

  @override
  String get smartRepetition => 'Smart Repetition';

  @override
  String get smartRepetitionDesc => 'Most efficient study with SM-2 algorithm';

  @override
  String get gamification => 'Gamification';

  @override
  String get gamificationDesc => 'Motivation with XP, streaks and achievements';

  @override
  String get chooseDailyGoal => 'Choose your daily goal';

  @override
  String get howManyCards => 'How many cards do you want to study each day?';

  @override
  String greatStart(int count) {
    return 'You can make a great start with $count cards per day!';
  }

  @override
  String get cardsPerDayUnit => 'cards/day';

  @override
  String get language => 'Language';

  @override
  String get languageTurkish => 'Türkçe';

  @override
  String get languageEnglish => 'English';

  @override
  String levelLabel(int level) {
    return 'Level $level';
  }

  @override
  String goalCards(int goal) {
    return '/ $goal cards';
  }
}
