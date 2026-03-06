import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/usecases/usecase.dart';
import '../../domain/entities/study_session_record.dart';
import '../../domain/entities/user_stats.dart';
import '../../domain/usecases/get_user_stats.dart';
import '../../domain/usecases/get_weekly_records.dart';

part 'stats_event.dart';
part 'stats_state.dart';

@injectable
class StatsBloc extends Bloc<StatsEvent, StatsState> {
  StatsBloc(this._getUserStats, this._getWeeklyRecords)
      : super(const StatsInitial()) {
    on<LoadStats>(_onLoadStats);
    on<RefreshStats>(_onRefreshStats);
  }

  final GetUserStats _getUserStats;
  final GetWeeklyRecords _getWeeklyRecords;

  Future<void> _onLoadStats(
    LoadStats event,
    Emitter<StatsState> emit,
  ) async {
    emit(const StatsLoading());
    await _loadStats(emit);
  }

  Future<void> _onRefreshStats(
    RefreshStats event,
    Emitter<StatsState> emit,
  ) async {
    await _loadStats(emit);
  }

  Future<void> _loadStats(Emitter<StatsState> emit) async {
    final statsResult = await _getUserStats(const NoParams());
    await statsResult.fold(
      (failure) async => emit(StatsError(failure.message)),
      (stats) async {
        final weeklyResult = await _getWeeklyRecords(const NoParams());
        weeklyResult.fold(
          (failure) => emit(StatsError(failure.message)),
          (records) => emit(StatsLoaded(
            userStats: stats,
            weeklyRecords: records,
          )),
        );
      },
    );
  }
}
