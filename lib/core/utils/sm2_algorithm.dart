class SM2Result {
  const SM2Result({
    required this.nextInterval,
    required this.newEaseFactor,
    required this.newRepetitions,
    required this.nextReviewDate,
  });

  final int nextInterval;
  final double newEaseFactor;
  final int newRepetitions;
  final DateTime nextReviewDate;
}

class SM2Algorithm {
  static SM2Result calculate({
    required int quality,
    required double easeFactor,
    required int interval,
    required int repetitions,
  }) {
    assert(quality >= 0 && quality <= 5);

    int newRepetitions;
    int newInterval;

    if (quality < 3) {
      newRepetitions = 0;
      newInterval = 1;
    } else {
      if (repetitions == 0) {
        newInterval = 1;
      } else if (repetitions == 1) {
        newInterval = 6;
      } else {
        newInterval = (interval * easeFactor).round();
      }
      newRepetitions = repetitions + 1;
    }

    final q = quality.toDouble();
    double newEaseFactor =
        easeFactor + (0.1 - (5 - q) * (0.08 + (5 - q) * 0.02));

    if (newEaseFactor < 1.3) {
      newEaseFactor = 1.3;
    }

    final nextReviewDate = DateTime.now().add(Duration(days: newInterval));

    return SM2Result(
      nextInterval: newInterval,
      newEaseFactor: newEaseFactor,
      newRepetitions: newRepetitions,
      nextReviewDate: nextReviewDate,
    );
  }
}
