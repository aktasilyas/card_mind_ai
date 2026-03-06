import 'package:card_mind_ai/core/gamification/xp_calculator.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('XpCalculator', () {
    group('studyCard', () {
      test('quality 5 returns 15 XP', () {
        expect(XpCalculator.studyCard(5), 15);
      });

      test('quality 4 returns 10 XP', () {
        expect(XpCalculator.studyCard(4), 10);
      });

      test('quality 3 returns 10 XP', () {
        expect(XpCalculator.studyCard(3), 10);
      });

      test('quality 2 returns 5 XP', () {
        expect(XpCalculator.studyCard(2), 5);
      });

      test('quality 1 returns 5 XP', () {
        expect(XpCalculator.studyCard(1), 5);
      });

      test('quality 0 returns 5 XP', () {
        expect(XpCalculator.studyCard(0), 5);
      });
    });

    test('completeDailyGoal returns 50', () {
      expect(XpCalculator.completeDailyGoal(), 50);
    });

    test('createDeck returns 20', () {
      expect(XpCalculator.createDeck(), 20);
    });

    test('weekStreak returns 100', () {
      expect(XpCalculator.weekStreak(), 100);
    });
  });
}
