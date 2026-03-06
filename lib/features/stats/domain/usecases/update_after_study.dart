import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/gamification/xp_calculator.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/study_session_record.dart';
import '../entities/user_stats.dart';
import '../repositories/stats_repository.dart';

class UpdateAfterStudyParams {
  const UpdateAfterStudyParams({
    required this.deckId,
    required this.ratings,
    required this.durationSeconds,
  });

  final String deckId;
  final List<int> ratings;
  final int durationSeconds;
}

class StudyResult {
  const StudyResult({required this.updatedStats, required this.xpEarned});

  final UserStats updatedStats;
  final int xpEarned;
}

@injectable
class UpdateAfterStudy
    implements UseCase<StudyResult, UpdateAfterStudyParams> {
  const UpdateAfterStudy(this._repository);

  final StatsRepository _repository;

  @override
  Future<Either<Failure, StudyResult>> call(
    UpdateAfterStudyParams params,
  ) async {
    final statsResult = await _repository.getUserStats();
    return statsResult.fold(
      (failure) async => Left(failure),
      (stats) async {
        final xpFromCards = params.ratings
            .fold(0, (sum, q) => sum + XpCalculator.studyCard(q));

        final correctCount = params.ratings.where((q) => q >= 3).length;

        final now = DateTime.now();
        final today = DateTime(now.year, now.month, now.day);

        int newStreak = stats.currentStreak;
        int newTodayCount = stats.todayStudiedCount;

        if (stats.lastStudyDate != null) {
          final lastDate = DateTime(
            stats.lastStudyDate!.year,
            stats.lastStudyDate!.month,
            stats.lastStudyDate!.day,
          );
          final diff = today.difference(lastDate).inDays;
          if (diff == 1) {
            newStreak = stats.currentStreak + 1;
            newTodayCount = params.ratings.length;
          } else if (diff == 0) {
            newTodayCount = stats.todayStudiedCount + params.ratings.length;
          } else {
            newStreak = 1;
            newTodayCount = params.ratings.length;
          }
        } else {
          newStreak = 1;
          newTodayCount = params.ratings.length;
        }

        int totalXpEarned = xpFromCards;

        final wasBelowGoal = stats.todayStudiedCount < stats.dailyGoal;
        final isNowAboveGoal = newTodayCount >= stats.dailyGoal;
        if (wasBelowGoal && isNowAboveGoal) {
          totalXpEarned += XpCalculator.completeDailyGoal();
        }

        if (newStreak > 0 &&
            newStreak % 7 == 0 &&
            newStreak > stats.currentStreak) {
          totalXpEarned += XpCalculator.weekStreak();
        }

        final newTotalXp = stats.totalXp + totalXpEarned;
        final newLevel = UserStats.calculateLevel(newTotalXp);
        final newLongestStreak =
            newStreak > stats.longestStreak ? newStreak : stats.longestStreak;

        int newHearts = stats.heartsRemaining;
        final wrongCount = params.ratings.where((q) => q < 3).length;
        if (wrongCount > 0) {
          newHearts = (stats.heartsRemaining - wrongCount).clamp(0, 5);
        }

        final updatedStats = stats.copyWith(
          totalXp: newTotalXp,
          level: newLevel,
          currentStreak: newStreak,
          longestStreak: newLongestStreak,
          lastStudyDate: now,
          totalCardsStudied: stats.totalCardsStudied + params.ratings.length,
          totalCorrect: stats.totalCorrect + correctCount,
          heartsRemaining: newHearts,
          todayStudiedCount: newTodayCount,
        );

        final updateResult = await _repository.updateStats(updatedStats);
        return updateResult.fold(
          (f) async => Left(f),
          (_) async {
            final sessionRecord = StudySessionRecord(
              deckId: params.deckId,
              date: now,
              cardsStudied: params.ratings.length,
              correctCount: correctCount,
              xpEarned: totalXpEarned,
              durationSeconds: params.durationSeconds,
            );
            final sessionResult =
                await _repository.addSessionRecord(sessionRecord);
            return sessionResult.fold(
              (f) => Left(f),
              (_) => Right(StudyResult(
                updatedStats: updatedStats,
                xpEarned: totalXpEarned,
              )),
            );
          },
        );
      },
    );
  }
}
