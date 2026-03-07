import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_tr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('tr'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'CardMind AI'**
  String get appTitle;

  /// No description provided for @navHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// No description provided for @navStats.
  ///
  /// In en, this message translates to:
  /// **'Statistics'**
  String get navStats;

  /// No description provided for @navSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get navSettings;

  /// No description provided for @noDecksYet.
  ///
  /// In en, this message translates to:
  /// **'No decks yet,\ncreate your first deck!'**
  String get noDecksYet;

  /// No description provided for @createDeck.
  ///
  /// In en, this message translates to:
  /// **'Create Deck'**
  String get createDeck;

  /// No description provided for @newDeck.
  ///
  /// In en, this message translates to:
  /// **'Create New Deck'**
  String get newDeck;

  /// No description provided for @deckName.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get deckName;

  /// No description provided for @deckDescription.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get deckDescription;

  /// No description provided for @create.
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get create;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @cardCount.
  ///
  /// In en, this message translates to:
  /// **'{count} cards'**
  String cardCount(int count);

  /// No description provided for @startStudy.
  ///
  /// In en, this message translates to:
  /// **'Start Study'**
  String get startStudy;

  /// No description provided for @generateWithAi.
  ///
  /// In en, this message translates to:
  /// **'Generate with AI'**
  String get generateWithAi;

  /// No description provided for @noCardsYet.
  ///
  /// In en, this message translates to:
  /// **'No cards yet.\nTry generating cards with AI!'**
  String get noCardsYet;

  /// No description provided for @noCardsToStudy.
  ///
  /// In en, this message translates to:
  /// **'No cards to study today!'**
  String get noCardsToStudy;

  /// No description provided for @goBack.
  ///
  /// In en, this message translates to:
  /// **'Go Back'**
  String get goBack;

  /// No description provided for @greatJob.
  ///
  /// In en, this message translates to:
  /// **'Great Job!'**
  String get greatJob;

  /// No description provided for @totalCards.
  ///
  /// In en, this message translates to:
  /// **'Total Cards'**
  String get totalCards;

  /// No description provided for @averageScore.
  ///
  /// In en, this message translates to:
  /// **'Average Score'**
  String get averageScore;

  /// No description provided for @goToHome.
  ///
  /// In en, this message translates to:
  /// **'Go to Home'**
  String get goToHome;

  /// No description provided for @tapCard.
  ///
  /// In en, this message translates to:
  /// **'Tap the card'**
  String get tapCard;

  /// No description provided for @ratingWorst.
  ///
  /// In en, this message translates to:
  /// **'Nothing'**
  String get ratingWorst;

  /// No description provided for @ratingHard.
  ///
  /// In en, this message translates to:
  /// **'Hard'**
  String get ratingHard;

  /// No description provided for @ratingStruggled.
  ///
  /// In en, this message translates to:
  /// **'Struggled'**
  String get ratingStruggled;

  /// No description provided for @ratingMedium.
  ///
  /// In en, this message translates to:
  /// **'Medium'**
  String get ratingMedium;

  /// No description provided for @ratingEasy.
  ///
  /// In en, this message translates to:
  /// **'Easy'**
  String get ratingEasy;

  /// No description provided for @ratingPerfect.
  ///
  /// In en, this message translates to:
  /// **'Perfect'**
  String get ratingPerfect;

  /// No description provided for @question.
  ///
  /// In en, this message translates to:
  /// **'QUESTION'**
  String get question;

  /// No description provided for @answer.
  ///
  /// In en, this message translates to:
  /// **'ANSWER'**
  String get answer;

  /// No description provided for @tapToFlip.
  ///
  /// In en, this message translates to:
  /// **'Tap to flip'**
  String get tapToFlip;

  /// No description provided for @statistics.
  ///
  /// In en, this message translates to:
  /// **'Statistics'**
  String get statistics;

  /// No description provided for @dailyGoal.
  ///
  /// In en, this message translates to:
  /// **'Daily Goal'**
  String get dailyGoal;

  /// No description provided for @weeklyXp.
  ///
  /// In en, this message translates to:
  /// **'Weekly XP'**
  String get weeklyXp;

  /// No description provided for @totalXp.
  ///
  /// In en, this message translates to:
  /// **'Total XP'**
  String get totalXp;

  /// No description provided for @streak.
  ///
  /// In en, this message translates to:
  /// **'Streak'**
  String get streak;

  /// No description provided for @streakDays.
  ///
  /// In en, this message translates to:
  /// **'{count} days'**
  String streakDays(int count);

  /// No description provided for @achievement.
  ///
  /// In en, this message translates to:
  /// **'Achievement'**
  String get achievement;

  /// No description provided for @totalCardsStudied.
  ///
  /// In en, this message translates to:
  /// **'Total Cards'**
  String get totalCardsStudied;

  /// No description provided for @badges.
  ///
  /// In en, this message translates to:
  /// **'Badges'**
  String get badges;

  /// No description provided for @noBadgesYet.
  ///
  /// In en, this message translates to:
  /// **'No badges earned yet.\nKeep studying!'**
  String get noBadgesYet;

  /// No description provided for @mon.
  ///
  /// In en, this message translates to:
  /// **'Mon'**
  String get mon;

  /// No description provided for @tue.
  ///
  /// In en, this message translates to:
  /// **'Tue'**
  String get tue;

  /// No description provided for @wed.
  ///
  /// In en, this message translates to:
  /// **'Wed'**
  String get wed;

  /// No description provided for @thu.
  ///
  /// In en, this message translates to:
  /// **'Thu'**
  String get thu;

  /// No description provided for @fri.
  ///
  /// In en, this message translates to:
  /// **'Fri'**
  String get fri;

  /// No description provided for @sat.
  ///
  /// In en, this message translates to:
  /// **'Sat'**
  String get sat;

  /// No description provided for @sun.
  ///
  /// In en, this message translates to:
  /// **'Sun'**
  String get sun;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @study.
  ///
  /// In en, this message translates to:
  /// **'Study'**
  String get study;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @appearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get appearance;

  /// No description provided for @subscription.
  ///
  /// In en, this message translates to:
  /// **'Subscription'**
  String get subscription;

  /// No description provided for @dailyGoalSetting.
  ///
  /// In en, this message translates to:
  /// **'Daily Goal'**
  String get dailyGoalSetting;

  /// No description provided for @cardsPerDay.
  ///
  /// In en, this message translates to:
  /// **'cards/day'**
  String get cardsPerDay;

  /// No description provided for @dailyReminder.
  ///
  /// In en, this message translates to:
  /// **'Daily Reminder'**
  String get dailyReminder;

  /// No description provided for @reminderOn.
  ///
  /// In en, this message translates to:
  /// **'On — {time}'**
  String reminderOn(String time);

  /// No description provided for @reminderOff.
  ///
  /// In en, this message translates to:
  /// **'Off'**
  String get reminderOff;

  /// No description provided for @theme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// No description provided for @themeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get themeLight;

  /// No description provided for @themeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get themeDark;

  /// No description provided for @themeSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get themeSystem;

  /// No description provided for @cardMindPremium.
  ///
  /// In en, this message translates to:
  /// **'CardMind Premium'**
  String get cardMindPremium;

  /// No description provided for @premiumActive.
  ///
  /// In en, this message translates to:
  /// **'Active — All features unlocked'**
  String get premiumActive;

  /// No description provided for @premiumDescription.
  ///
  /// In en, this message translates to:
  /// **'PDF, voice input and more'**
  String get premiumDescription;

  /// No description provided for @upgradeToPremium.
  ///
  /// In en, this message translates to:
  /// **'Upgrade to Premium'**
  String get upgradeToPremium;

  /// No description provided for @aiCardGenerator.
  ///
  /// In en, this message translates to:
  /// **'AI Card Generator'**
  String get aiCardGenerator;

  /// No description provided for @uploadFromFile.
  ///
  /// In en, this message translates to:
  /// **'Upload from File'**
  String get uploadFromFile;

  /// No description provided for @listening.
  ///
  /// In en, this message translates to:
  /// **'Listening...'**
  String get listening;

  /// No description provided for @enterTextHint.
  ///
  /// In en, this message translates to:
  /// **'Enter topic or text here...'**
  String get enterTextHint;

  /// No description provided for @cardCountLabel.
  ///
  /// In en, this message translates to:
  /// **'Card Count'**
  String get cardCountLabel;

  /// No description provided for @generateCards.
  ///
  /// In en, this message translates to:
  /// **'Generate Cards'**
  String get generateCards;

  /// No description provided for @cardsGenerated.
  ///
  /// In en, this message translates to:
  /// **'{count} cards generated'**
  String cardsGenerated(int count);

  /// No description provided for @saveAll.
  ///
  /// In en, this message translates to:
  /// **'Save All ({count})'**
  String saveAll(int count);

  /// No description provided for @dailyLimitReached.
  ///
  /// In en, this message translates to:
  /// **'Daily Limit Reached'**
  String get dailyLimitReached;

  /// No description provided for @premiumUnlimited.
  ///
  /// In en, this message translates to:
  /// **'Generate unlimited cards with Premium and unlock all features.'**
  String get premiumUnlimited;

  /// No description provided for @micPermissionRequired.
  ///
  /// In en, this message translates to:
  /// **'Microphone permission required'**
  String get micPermissionRequired;

  /// No description provided for @cardsAddedToDeck.
  ///
  /// In en, this message translates to:
  /// **'{count} cards added to deck'**
  String cardsAddedToDeck(int count);

  /// No description provided for @premium.
  ///
  /// In en, this message translates to:
  /// **'Premium'**
  String get premium;

  /// No description provided for @premiumActiveTitle.
  ///
  /// In en, this message translates to:
  /// **'Premium Active'**
  String get premiumActiveTitle;

  /// No description provided for @allFeaturesAccess.
  ///
  /// In en, this message translates to:
  /// **'You have access to all features.'**
  String get allFeaturesAccess;

  /// No description provided for @feature.
  ///
  /// In en, this message translates to:
  /// **'Feature'**
  String get feature;

  /// No description provided for @free.
  ///
  /// In en, this message translates to:
  /// **'Free'**
  String get free;

  /// No description provided for @ads.
  ///
  /// In en, this message translates to:
  /// **'Ads'**
  String get ads;

  /// No description provided for @adsYes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get adsYes;

  /// No description provided for @adsNo.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get adsNo;

  /// No description provided for @aiCardGeneration.
  ///
  /// In en, this message translates to:
  /// **'AI Card Generation'**
  String get aiCardGeneration;

  /// No description provided for @fivePerDay.
  ///
  /// In en, this message translates to:
  /// **'5/day'**
  String get fivePerDay;

  /// No description provided for @unlimited.
  ///
  /// In en, this message translates to:
  /// **'Unlimited'**
  String get unlimited;

  /// No description provided for @prioritySupport.
  ///
  /// In en, this message translates to:
  /// **'Priority Support'**
  String get prioritySupport;

  /// No description provided for @premiumPlans.
  ///
  /// In en, this message translates to:
  /// **'Premium Plans'**
  String get premiumPlans;

  /// No description provided for @monthly.
  ///
  /// In en, this message translates to:
  /// **'Monthly'**
  String get monthly;

  /// No description provided for @yearly.
  ///
  /// In en, this message translates to:
  /// **'Yearly'**
  String get yearly;

  /// No description provided for @restorePurchases.
  ///
  /// In en, this message translates to:
  /// **'Restore Purchases'**
  String get restorePurchases;

  /// No description provided for @premiumFeatureOnly.
  ///
  /// In en, this message translates to:
  /// **'This feature is for Premium users only.'**
  String get premiumFeatureOnly;

  /// No description provided for @start.
  ///
  /// In en, this message translates to:
  /// **'START'**
  String get start;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'NEXT'**
  String get next;

  /// No description provided for @smartStudy.
  ///
  /// In en, this message translates to:
  /// **'Study smart, learn more'**
  String get smartStudy;

  /// No description provided for @aiPoweredLearning.
  ///
  /// In en, this message translates to:
  /// **'AI-powered learning'**
  String get aiPoweredLearning;

  /// No description provided for @whatWeOffer.
  ///
  /// In en, this message translates to:
  /// **'What do we offer?'**
  String get whatWeOffer;

  /// No description provided for @powerfulTools.
  ///
  /// In en, this message translates to:
  /// **'Powerful tools to accelerate your learning'**
  String get powerfulTools;

  /// No description provided for @aiCardGenerationFeature.
  ///
  /// In en, this message translates to:
  /// **'AI Card Generation'**
  String get aiCardGenerationFeature;

  /// No description provided for @aiCardGenerationDesc.
  ///
  /// In en, this message translates to:
  /// **'Create flashcards instantly with AI'**
  String get aiCardGenerationDesc;

  /// No description provided for @smartRepetition.
  ///
  /// In en, this message translates to:
  /// **'Smart Repetition'**
  String get smartRepetition;

  /// No description provided for @smartRepetitionDesc.
  ///
  /// In en, this message translates to:
  /// **'Most efficient study with SM-2 algorithm'**
  String get smartRepetitionDesc;

  /// No description provided for @gamification.
  ///
  /// In en, this message translates to:
  /// **'Gamification'**
  String get gamification;

  /// No description provided for @gamificationDesc.
  ///
  /// In en, this message translates to:
  /// **'Motivation with XP, streaks and achievements'**
  String get gamificationDesc;

  /// No description provided for @chooseDailyGoal.
  ///
  /// In en, this message translates to:
  /// **'Choose your daily goal'**
  String get chooseDailyGoal;

  /// No description provided for @howManyCards.
  ///
  /// In en, this message translates to:
  /// **'How many cards do you want to study each day?'**
  String get howManyCards;

  /// No description provided for @greatStart.
  ///
  /// In en, this message translates to:
  /// **'You can make a great start with {count} cards per day!'**
  String greatStart(int count);

  /// No description provided for @cardsPerDayUnit.
  ///
  /// In en, this message translates to:
  /// **'cards/day'**
  String get cardsPerDayUnit;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @languageTurkish.
  ///
  /// In en, this message translates to:
  /// **'Türkçe'**
  String get languageTurkish;

  /// No description provided for @languageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// No description provided for @levelLabel.
  ///
  /// In en, this message translates to:
  /// **'Level {level}'**
  String levelLabel(int level);

  /// No description provided for @goalCards.
  ///
  /// In en, this message translates to:
  /// **'/ {goal} cards'**
  String goalCards(int goal);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'tr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'tr':
      return AppLocalizationsTr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
