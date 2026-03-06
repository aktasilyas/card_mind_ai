class StudySessionRecord {
  const StudySessionRecord({
    required this.deckId,
    required this.date,
    required this.cardsStudied,
    required this.correctCount,
    required this.xpEarned,
    required this.durationSeconds,
  });

  final String deckId;
  final DateTime date;
  final int cardsStudied;
  final int correctCount;
  final int xpEarned;
  final int durationSeconds;
}
