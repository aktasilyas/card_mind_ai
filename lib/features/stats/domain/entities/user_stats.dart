class UserStats {
  const UserStats({
    required this.totalXp,
    required this.level,
    required this.currentStreak,
    required this.longestStreak,
    required this.lastStudyDate,
    required this.totalCardsStudied,
    required this.totalCorrect,
    required this.heartsRemaining,
    required this.lastHeartRefill,
    required this.dailyGoal,
    required this.todayStudiedCount,
    this.achievements = const [],
  });

  final int totalXp;
  final int level;
  final int currentStreak;
  final int longestStreak;
  final DateTime? lastStudyDate;
  final int totalCardsStudied;
  final int totalCorrect;
  final int heartsRemaining;
  final DateTime lastHeartRefill;
  final int dailyGoal;
  final int todayStudiedCount;
  final List<String> achievements;

  double get accuracy =>
      totalCardsStudied == 0 ? 0 : (totalCorrect / totalCardsStudied) * 100;

  double get levelProgress {
    final thresholds = [0, 100, 500, 2000, 5000];
    if (level >= 5) return 1.0;
    final currentThreshold = thresholds[level - 1];
    final nextThreshold = thresholds[level];
    return (totalXp - currentThreshold) / (nextThreshold - currentThreshold);
  }

  static int calculateLevel(int xp) {
    if (xp >= 5000) return 5;
    if (xp >= 2000) return 4;
    if (xp >= 500) return 3;
    if (xp >= 100) return 2;
    return 1;
  }

  factory UserStats.empty() {
    return UserStats(
      totalXp: 0,
      level: 1,
      currentStreak: 0,
      longestStreak: 0,
      lastStudyDate: null,
      totalCardsStudied: 0,
      totalCorrect: 0,
      heartsRemaining: 5,
      lastHeartRefill: DateTime.now(),
      dailyGoal: 10,
      todayStudiedCount: 0,
      achievements: const [],
    );
  }

  UserStats copyWith({
    int? totalXp,
    int? level,
    int? currentStreak,
    int? longestStreak,
    DateTime? lastStudyDate,
    int? totalCardsStudied,
    int? totalCorrect,
    int? heartsRemaining,
    DateTime? lastHeartRefill,
    int? dailyGoal,
    int? todayStudiedCount,
    List<String>? achievements,
  }) {
    return UserStats(
      totalXp: totalXp ?? this.totalXp,
      level: level ?? this.level,
      currentStreak: currentStreak ?? this.currentStreak,
      longestStreak: longestStreak ?? this.longestStreak,
      lastStudyDate: lastStudyDate ?? this.lastStudyDate,
      totalCardsStudied: totalCardsStudied ?? this.totalCardsStudied,
      totalCorrect: totalCorrect ?? this.totalCorrect,
      heartsRemaining: heartsRemaining ?? this.heartsRemaining,
      lastHeartRefill: lastHeartRefill ?? this.lastHeartRefill,
      dailyGoal: dailyGoal ?? this.dailyGoal,
      todayStudiedCount: todayStudiedCount ?? this.todayStudiedCount,
      achievements: achievements ?? this.achievements,
    );
  }
}
