part of 'stats_bloc.dart';

sealed class StatsState {
  const StatsState();
}

final class StatsInitial extends StatsState {
  const StatsInitial();
}

final class StatsLoading extends StatsState {
  const StatsLoading();
}

final class StatsLoaded extends StatsState {
  const StatsLoaded({
    required this.userStats,
    this.weeklyRecords = const [],
  });

  final UserStats userStats;
  final List<StudySessionRecord> weeklyRecords;
}

final class StatsError extends StatsState {
  const StatsError(this.message);

  final String message;
}
