import 'package:flutter_test/flutter_test.dart';
import 'package:card_mind_ai/core/utils/sm2_algorithm.dart';

void main() {
  group('SM2Algorithm', () {
    group('quality 0-2 (failed)', () {
      for (final q in [0, 1, 2]) {
        test('quality $q resets repetitions and sets interval to 1', () {
          final result = SM2Algorithm.calculate(
            quality: q,
            easeFactor: 2.5,
            interval: 10,
            repetitions: 5,
          );

          expect(result.newRepetitions, 0);
          expect(result.nextInterval, 1);
        });
      }
    });

    group('quality 3 (pass, easeFactor decreases)', () {
      test('easeFactor decreases but stays above 1.3', () {
        final result = SM2Algorithm.calculate(
          quality: 3,
          easeFactor: 2.5,
          interval: 10,
          repetitions: 3,
        );

        expect(result.newRepetitions, 4);
        expect(result.newEaseFactor, lessThan(2.5));
        expect(result.newEaseFactor, greaterThanOrEqualTo(1.3));
      });
    });

    group('quality 4 (pass, easeFactor slightly decreases)', () {
      test('easeFactor slightly decreases', () {
        final result = SM2Algorithm.calculate(
          quality: 4,
          easeFactor: 2.5,
          interval: 10,
          repetitions: 3,
        );

        expect(result.newRepetitions, 4);
        expect(result.newEaseFactor, equals(2.5));
      });
    });

    group('quality 5 (pass, easeFactor increases)', () {
      test('easeFactor increases', () {
        final result = SM2Algorithm.calculate(
          quality: 5,
          easeFactor: 2.5,
          interval: 10,
          repetitions: 3,
        );

        expect(result.newRepetitions, 4);
        expect(result.newEaseFactor, greaterThan(2.5));
      });
    });

    group('easeFactor minimum 1.3', () {
      test('does not go below 1.3 with low quality and low starting ef', () {
        final result = SM2Algorithm.calculate(
          quality: 0,
          easeFactor: 1.3,
          interval: 1,
          repetitions: 0,
        );

        expect(result.newEaseFactor, 1.3);
      });
    });

    group('first review (repetitions=0, quality>=3)', () {
      test('interval = 1, repetitions = 1', () {
        final result = SM2Algorithm.calculate(
          quality: 4,
          easeFactor: 2.5,
          interval: 0,
          repetitions: 0,
        );

        expect(result.nextInterval, 1);
        expect(result.newRepetitions, 1);
      });
    });

    group('second review (repetitions=1)', () {
      test('interval = 6', () {
        final result = SM2Algorithm.calculate(
          quality: 4,
          easeFactor: 2.5,
          interval: 1,
          repetitions: 1,
        );

        expect(result.nextInterval, 6);
        expect(result.newRepetitions, 2);
      });
    });

    group('third+ review', () {
      test('interval = (previous interval * ef).round()', () {
        const ef = 2.5;
        const previousInterval = 6;

        final result = SM2Algorithm.calculate(
          quality: 4,
          easeFactor: ef,
          interval: previousInterval,
          repetitions: 2,
        );

        expect(result.nextInterval, (previousInterval * ef).round());
        expect(result.newRepetitions, 3);
      });
    });

    group('nextReviewDate', () {
      test('is set to now + interval days', () {
        final before = DateTime.now();
        final result = SM2Algorithm.calculate(
          quality: 5,
          easeFactor: 2.5,
          interval: 6,
          repetitions: 2,
        );
        final after = DateTime.now();

        final expectedMin = before.add(Duration(days: result.nextInterval));
        final expectedMax = after.add(Duration(days: result.nextInterval));

        expect(
          result.nextReviewDate.isAfter(expectedMin) ||
              result.nextReviewDate.isAtSameMomentAs(expectedMin),
          isTrue,
        );
        expect(
          result.nextReviewDate.isBefore(expectedMax) ||
              result.nextReviewDate.isAtSameMomentAs(expectedMax),
          isTrue,
        );
      });
    });
  });
}
