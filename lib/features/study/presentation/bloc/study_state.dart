part of 'study_bloc.dart';

sealed class StudyState {
  const StudyState();
}

final class StudyInitial extends StudyState {
  const StudyInitial();
}

final class StudyLoading extends StudyState {
  const StudyLoading();
}

final class StudyInProgress extends StudyState {
  const StudyInProgress({
    required this.session,
    this.isFlipped = false,
  });

  final StudySession session;
  final bool isFlipped;
}

final class StudyComplete extends StudyState {
  const StudyComplete({
    required this.totalCards,
    required this.averageRating,
    required this.xpEarned,
  });

  final int totalCards;
  final double averageRating;
  final int xpEarned;
}

final class StudyEmpty extends StudyState {
  const StudyEmpty();
}

final class StudyError extends StudyState {
  const StudyError(this.message);

  final String message;
}
