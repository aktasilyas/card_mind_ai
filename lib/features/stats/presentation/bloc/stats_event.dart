part of 'stats_bloc.dart';

sealed class StatsEvent {
  const StatsEvent();
}

final class LoadStats extends StatsEvent {
  const LoadStats();
}

final class RefreshStats extends StatsEvent {
  const RefreshStats();
}
