import 'package:hive/hive.dart';

import '../../domain/entities/user_stats.dart';

class UserStatsModel {
  const UserStatsModel({
    required this.totalXp,
    required this.level,
    required this.currentStreak,
    required this.longestStreak,
    this.lastStudyDate,
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

  UserStats toEntity() {
    return UserStats(
      totalXp: totalXp,
      level: level,
      currentStreak: currentStreak,
      longestStreak: longestStreak,
      lastStudyDate: lastStudyDate,
      totalCardsStudied: totalCardsStudied,
      totalCorrect: totalCorrect,
      heartsRemaining: heartsRemaining,
      lastHeartRefill: lastHeartRefill,
      dailyGoal: dailyGoal,
      todayStudiedCount: todayStudiedCount,
      achievements: achievements,
    );
  }

  factory UserStatsModel.fromEntity(UserStats stats) {
    return UserStatsModel(
      totalXp: stats.totalXp,
      level: stats.level,
      currentStreak: stats.currentStreak,
      longestStreak: stats.longestStreak,
      lastStudyDate: stats.lastStudyDate,
      totalCardsStudied: stats.totalCardsStudied,
      totalCorrect: stats.totalCorrect,
      heartsRemaining: stats.heartsRemaining,
      lastHeartRefill: stats.lastHeartRefill,
      dailyGoal: stats.dailyGoal,
      todayStudiedCount: stats.todayStudiedCount,
      achievements: stats.achievements,
    );
  }
}

class UserStatsModelAdapter extends TypeAdapter<UserStatsModel> {
  @override
  final int typeId = 2;

  @override
  UserStatsModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserStatsModel(
      totalXp: fields[0] as int,
      level: fields[1] as int,
      currentStreak: fields[2] as int,
      longestStreak: fields[3] as int,
      lastStudyDate: fields[4] as DateTime?,
      totalCardsStudied: fields[5] as int,
      totalCorrect: fields[6] as int,
      heartsRemaining: fields[7] as int,
      lastHeartRefill: fields[8] as DateTime,
      dailyGoal: fields[9] as int,
      todayStudiedCount: fields[10] as int,
      achievements: (fields[11] as List?)?.cast<String>() ?? [],
    );
  }

  @override
  void write(BinaryWriter writer, UserStatsModel obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.totalXp)
      ..writeByte(1)
      ..write(obj.level)
      ..writeByte(2)
      ..write(obj.currentStreak)
      ..writeByte(3)
      ..write(obj.longestStreak)
      ..writeByte(4)
      ..write(obj.lastStudyDate)
      ..writeByte(5)
      ..write(obj.totalCardsStudied)
      ..writeByte(6)
      ..write(obj.totalCorrect)
      ..writeByte(7)
      ..write(obj.heartsRemaining)
      ..writeByte(8)
      ..write(obj.lastHeartRefill)
      ..writeByte(9)
      ..write(obj.dailyGoal)
      ..writeByte(10)
      ..write(obj.todayStudiedCount)
      ..writeByte(11)
      ..write(obj.achievements);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserStatsModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
