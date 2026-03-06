part of 'study_bloc.dart';

sealed class StudyEvent {
  const StudyEvent();
}

final class LoadStudySession extends StudyEvent {
  const LoadStudySession(this.deckId);

  final String deckId;
}

final class FlipCard extends StudyEvent {
  const FlipCard();
}

final class RateCard extends StudyEvent {
  const RateCard(this.quality);

  final int quality;
}
