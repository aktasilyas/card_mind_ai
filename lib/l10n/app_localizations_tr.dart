// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Turkish (`tr`).
class AppLocalizationsTr extends AppLocalizations {
  AppLocalizationsTr([String locale = 'tr']) : super(locale);

  @override
  String get appTitle => 'CardMind AI';

  @override
  String get navHome => 'Ana Sayfa';

  @override
  String get navStats => 'İstatistik';

  @override
  String get navSettings => 'Ayarlar';

  @override
  String get noDecksYet => 'Henüz deste yok,\nilk desteni oluştur!';

  @override
  String get createDeck => 'Deste Oluştur';

  @override
  String get newDeck => 'Yeni Deste Oluştur';

  @override
  String get deckName => 'İsim';

  @override
  String get deckDescription => 'Açıklama';

  @override
  String get create => 'Oluştur';

  @override
  String get retry => 'Tekrar Dene';

  @override
  String cardCount(int count) {
    return '$count kart';
  }

  @override
  String get startStudy => 'Çalışmaya Başla';

  @override
  String get generateWithAi => 'AI ile Üret';

  @override
  String get noCardsYet => 'Henüz kart yok.\nAI ile kart üretmeyi deneyin!';

  @override
  String get noCardsToStudy => 'Bugün çalışılacak kart yok!';

  @override
  String get goBack => 'Geri Dön';

  @override
  String get greatJob => 'Harika İş!';

  @override
  String get totalCards => 'Toplam Kart';

  @override
  String get averageScore => 'Ortalama Puan';

  @override
  String get goToHome => 'Ana Sayfaya Dön';

  @override
  String get tapCard => 'Karta dokun';

  @override
  String get ratingWorst => 'Hiç';

  @override
  String get ratingHard => 'Zor';

  @override
  String get ratingStruggled => 'Zorlandım';

  @override
  String get ratingMedium => 'Orta';

  @override
  String get ratingEasy => 'Kolay';

  @override
  String get ratingPerfect => 'Mükemmel';

  @override
  String get question => 'SORU';

  @override
  String get answer => 'CEVAP';

  @override
  String get tapToFlip => 'Çevirmek için dokun';

  @override
  String get statistics => 'İstatistikler';

  @override
  String get dailyGoal => 'Günlük Hedef';

  @override
  String get weeklyXp => 'Haftalık XP';

  @override
  String get totalXp => 'Toplam XP';

  @override
  String get streak => 'Seri';

  @override
  String streakDays(int count) {
    return '$count gün';
  }

  @override
  String get achievement => 'Başarı';

  @override
  String get totalCardsStudied => 'Toplam Kart';

  @override
  String get badges => 'Rozetler';

  @override
  String get noBadgesYet => 'Henüz rozet kazanılmadı.\nÇalışmaya devam et!';

  @override
  String get mon => 'Pzt';

  @override
  String get tue => 'Sal';

  @override
  String get wed => 'Çar';

  @override
  String get thu => 'Per';

  @override
  String get fri => 'Cum';

  @override
  String get sat => 'Cmt';

  @override
  String get sun => 'Paz';

  @override
  String get settings => 'Ayarlar';

  @override
  String get study => 'Çalışma';

  @override
  String get notifications => 'Bildirimler';

  @override
  String get appearance => 'Görünüm';

  @override
  String get subscription => 'Abonelik';

  @override
  String get dailyGoalSetting => 'Günlük Hedef';

  @override
  String get cardsPerDay => 'kart/gün';

  @override
  String get dailyReminder => 'Günlük Hatırlatma';

  @override
  String reminderOn(String time) {
    return 'Açık — $time';
  }

  @override
  String get reminderOff => 'Kapalı';

  @override
  String get theme => 'Tema';

  @override
  String get themeLight => 'Açık';

  @override
  String get themeDark => 'Koyu';

  @override
  String get themeSystem => 'Sistem';

  @override
  String get cardMindPremium => 'CardMind Premium';

  @override
  String get premiumActive => 'Aktif — Tüm özellikler açık';

  @override
  String get premiumDescription => 'PDF, sesli giriş ve daha fazlası';

  @override
  String get upgradeToPremium => 'Premium\'a Geç';

  @override
  String get aiCardGenerator => 'AI Kart Üretici';

  @override
  String get uploadFromFile => 'Dosyadan Yükle';

  @override
  String get listening => 'Dinleniyor...';

  @override
  String get enterTextHint => 'Konuyu veya metni buraya yazın...';

  @override
  String get cardCountLabel => 'Kart Sayısı';

  @override
  String get generateCards => 'Kart Üret';

  @override
  String cardsGenerated(int count) {
    return '$count kart üretildi';
  }

  @override
  String saveAll(int count) {
    return 'Tümünü Kaydet ($count)';
  }

  @override
  String get dailyLimitReached => 'Günlük Limitinize Ulaştınız';

  @override
  String get premiumUnlimited =>
      'Premium ile sınırsız kart üretin ve tüm özelliklerin kilidini açın.';

  @override
  String get micPermissionRequired => 'Mikrofon izni gerekli';

  @override
  String cardsAddedToDeck(int count) {
    return '$count kart desteye eklendi';
  }

  @override
  String get premium => 'Premium';

  @override
  String get premiumActiveTitle => 'Premium Aktif';

  @override
  String get allFeaturesAccess => 'Tüm özelliklere erişiminiz var.';

  @override
  String get feature => 'Özellik';

  @override
  String get free => 'Free';

  @override
  String get ads => 'Reklamlar';

  @override
  String get adsYes => 'Var';

  @override
  String get adsNo => 'Yok';

  @override
  String get aiCardGeneration => 'AI Kart Üretimi';

  @override
  String get fivePerDay => '5/gün';

  @override
  String get unlimited => 'Sınırsız';

  @override
  String get prioritySupport => 'Öncelikli Destek';

  @override
  String get premiumPlans => 'Premium Planlar';

  @override
  String get monthly => 'Aylık';

  @override
  String get yearly => 'Yıllık';

  @override
  String get restorePurchases => 'Satın Alımları Geri Yükle';

  @override
  String get premiumFeatureOnly => 'Bu özellik Premium kullanıcılara özeldir.';

  @override
  String get start => 'BAŞLA';

  @override
  String get next => 'İLERİ';

  @override
  String get smartStudy => 'Akıllıca çalış, daha çok öğren';

  @override
  String get aiPoweredLearning => 'Yapay zeka destekli öğrenme';

  @override
  String get whatWeOffer => 'Neler sunuyoruz?';

  @override
  String get powerfulTools => 'Öğrenmeni hızlandıran güçlü araçlar';

  @override
  String get aiCardGenerationFeature => 'AI Kart Üretimi';

  @override
  String get aiCardGenerationDesc => 'Yapay zeka ile anında flashcard oluştur';

  @override
  String get smartRepetition => 'Akıllı Tekrar';

  @override
  String get smartRepetitionDesc => 'SM-2 algoritması ile en verimli çalışma';

  @override
  String get gamification => 'Gamification';

  @override
  String get gamificationDesc => 'XP, streak ve başarımlarla motivasyon';

  @override
  String get chooseDailyGoal => 'Günlük hedefinizi seçin';

  @override
  String get howManyCards => 'Her gün kaç kart çalışmak istiyorsunuz?';

  @override
  String greatStart(int count) {
    return 'Günde $count kart ile harika bir başlangıç yapabilirsin!';
  }

  @override
  String get cardsPerDayUnit => 'kart/gün';

  @override
  String get language => 'Dil';

  @override
  String get languageTurkish => 'Türkçe';

  @override
  String get languageEnglish => 'English';

  @override
  String levelLabel(int level) {
    return 'Seviye $level';
  }

  @override
  String goalCards(int goal) {
    return '/ $goal kart';
  }
}
