class Flashcard {
  const Flashcard({
    required this.id,
    required this.deckId,
    required this.front,
    required this.back,
    this.easeFactor = 2.5,
    this.interval = 1,
    this.repetitions = 0,
    required this.dueDate,
  });

  final String id;
  final String deckId;
  final String front;
  final String back;
  final double easeFactor;
  final int interval;
  final int repetitions;
  final DateTime dueDate;

  Flashcard copyWith({
    String? id,
    String? deckId,
    String? front,
    String? back,
    double? easeFactor,
    int? interval,
    int? repetitions,
    DateTime? dueDate,
  }) {
    return Flashcard(
      id: id ?? this.id,
      deckId: deckId ?? this.deckId,
      front: front ?? this.front,
      back: back ?? this.back,
      easeFactor: easeFactor ?? this.easeFactor,
      interval: interval ?? this.interval,
      repetitions: repetitions ?? this.repetitions,
      dueDate: dueDate ?? this.dueDate,
    );
  }
}
