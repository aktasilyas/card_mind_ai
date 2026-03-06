abstract class XpCalculator {
  static int studyCard(int quality) {
    if (quality >= 5) return 15;
    if (quality >= 3) return 10;
    return 5;
  }

  static int completeDailyGoal() => 50;

  static int createDeck() => 20;

  static int weekStreak() => 100;
}
