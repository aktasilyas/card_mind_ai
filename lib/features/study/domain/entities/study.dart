import '../../../deck/domain/entities/flashcard.dart';

class StudySession {
  const StudySession({
    required this.deckId,
    required this.cards,
    this.currentIndex = 0,
    this.ratings = const [],
  });

  final String deckId;
  final List<Flashcard> cards;
  final int currentIndex;
  final List<int> ratings;

  bool get isComplete => currentIndex >= cards.length;

  Flashcard? get currentCard => isComplete ? null : cards[currentIndex];

  double get averageRating =>
      ratings.isEmpty ? 0 : ratings.reduce((a, b) => a + b) / ratings.length;

  StudySession copyWith({
    String? deckId,
    List<Flashcard>? cards,
    int? currentIndex,
    List<int>? ratings,
  }) {
    return StudySession(
      deckId: deckId ?? this.deckId,
      cards: cards ?? this.cards,
      currentIndex: currentIndex ?? this.currentIndex,
      ratings: ratings ?? this.ratings,
    );
  }
}
