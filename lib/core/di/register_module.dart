import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';

import '../../features/deck/data/models/deck_model.dart';
import '../../features/deck/data/models/flashcard_model.dart';
import '../constants/app_constants.dart';

@module
abstract class RegisterModule {
  @preResolve
  Future<Box<DeckModel>> get decksBox =>
      Hive.openBox<DeckModel>(AppConstants.hiveDecksBox);

  @preResolve
  Future<Box<FlashcardModel>> get cardsBox =>
      Hive.openBox<FlashcardModel>(AppConstants.hiveCardsBox);
}
