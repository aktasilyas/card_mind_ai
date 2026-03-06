import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../features/deck/data/models/deck_model.dart';
import '../../features/deck/data/models/flashcard_model.dart';
import '../../features/stats/data/models/study_session_record_model.dart';
import '../../features/stats/data/models/user_stats_model.dart';
import '../constants/app_constants.dart';

@module
abstract class RegisterModule {
  @preResolve
  Future<Box<DeckModel>> get decksBox =>
      Hive.openBox<DeckModel>(AppConstants.hiveDecksBox);

  @preResolve
  Future<Box<FlashcardModel>> get cardsBox =>
      Hive.openBox<FlashcardModel>(AppConstants.hiveCardsBox);

  @preResolve
  Future<Box<UserStatsModel>> get statsBox =>
      Hive.openBox<UserStatsModel>(AppConstants.hiveStatsBox);

  @preResolve
  Future<Box<StudySessionRecordModel>> get sessionRecordsBox =>
      Hive.openBox<StudySessionRecordModel>(
          AppConstants.hiveSessionRecordsBox);

  @preResolve
  Future<SharedPreferences> get prefs => SharedPreferences.getInstance();
}
