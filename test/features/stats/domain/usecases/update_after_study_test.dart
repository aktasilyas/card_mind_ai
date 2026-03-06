import 'package:card_mind_ai/core/errors/failures.dart';
import 'package:card_mind_ai/features/stats/domain/entities/study_session_record.dart';
import 'package:card_mind_ai/features/stats/domain/entities/user_stats.dart';
import 'package:card_mind_ai/features/stats/domain/repositories/stats_repository.dart';
import 'package:card_mind_ai/features/stats/domain/usecases/update_after_study.dart';

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockStatsRepository extends Mock implements StatsRepository {}

class FakeUserStats extends Fake implements UserStats {}

class FakeStudySessionRecord extends Fake implements StudySessionRecord {}

void main() {
  late UpdateAfterStudy usecase;
  late MockStatsRepository mockRepository;

  setUpAll(() {
    registerFallbackValue(FakeUserStats());
    registerFallbackValue(FakeStudySessionRecord());
  });

  setUp(() {
    mockRepository = MockStatsRepository();
    usecase = UpdateAfterStudy(mockRepository);
  });

  UserStats createStats({
    int totalXp = 0,
    int currentStreak = 0,
    int longestStreak = 0,
    DateTime? lastStudyDate,
    int totalCardsStudied = 0,
    int totalCorrect = 0,
    int heartsRemaining = 5,
    int dailyGoal = 10,
    int todayStudiedCount = 0,
  }) {
    return UserStats(
      totalXp: totalXp,
      level: UserStats.calculateLevel(totalXp),
      currentStreak: currentStreak,
      longestStreak: longestStreak,
      lastStudyDate: lastStudyDate,
      totalCardsStudied: totalCardsStudied,
      totalCorrect: totalCorrect,
      heartsRemaining: heartsRemaining,
      lastHeartRefill: DateTime.now(),
      dailyGoal: dailyGoal,
      todayStudiedCount: todayStudiedCount,
    );
  }

  void setupSuccess(UserStats stats) {
    when(() => mockRepository.getUserStats())
        .thenAnswer((_) async => Right(stats));
    when(() => mockRepository.updateStats(any()))
        .thenAnswer((_) async => const Right(unit));
    when(() => mockRepository.addSessionRecord(any()))
        .thenAnswer((_) async => const Right(unit));
  }

  group('UpdateAfterStudy', () {
    test('accumulates XP from card ratings', () async {
      final stats = createStats();
      setupSuccess(stats);

      final result = await usecase(const UpdateAfterStudyParams(
        deckId: 'deck1',
        ratings: [5, 3, 1],
        durationSeconds: 120,
      ));

      expect(result.isRight(), true);
      result.fold(
        (_) => fail('should be right'),
        (studyResult) {
          // 15 + 10 + 5 = 30
          expect(studyResult.updatedStats.totalXp, 30);
          expect(studyResult.xpEarned, 30);
        },
      );
    });

    test('streak increments when last study was yesterday', () async {
      final yesterday = DateTime.now().subtract(const Duration(days: 1));
      final stats = createStats(currentStreak: 3, lastStudyDate: yesterday);
      setupSuccess(stats);

      final result = await usecase(const UpdateAfterStudyParams(
        deckId: 'deck1',
        ratings: [5],
        durationSeconds: 60,
      ));

      result.fold(
        (_) => fail('should be right'),
        (r) => expect(r.updatedStats.currentStreak, 4),
      );
    });

    test('streak stays same when studying same day', () async {
      final today = DateTime.now();
      final stats = createStats(currentStreak: 3, lastStudyDate: today);
      setupSuccess(stats);

      final result = await usecase(const UpdateAfterStudyParams(
        deckId: 'deck1',
        ratings: [5],
        durationSeconds: 60,
      ));

      result.fold(
        (_) => fail('should be right'),
        (r) => expect(r.updatedStats.currentStreak, 3),
      );
    });

    test('streak resets to 1 when gap > 1 day', () async {
      final threeDaysAgo = DateTime.now().subtract(const Duration(days: 3));
      final stats = createStats(currentStreak: 10, lastStudyDate: threeDaysAgo);
      setupSuccess(stats);

      final result = await usecase(const UpdateAfterStudyParams(
        deckId: 'deck1',
        ratings: [5],
        durationSeconds: 60,
      ));

      result.fold(
        (_) => fail('should be right'),
        (r) => expect(r.updatedStats.currentStreak, 1),
      );
    });

    test('daily goal bonus XP when reaching goal', () async {
      final stats = createStats(
        dailyGoal: 3,
        todayStudiedCount: 1,
        lastStudyDate: DateTime.now(),
      );
      setupSuccess(stats);

      final result = await usecase(const UpdateAfterStudyParams(
        deckId: 'deck1',
        ratings: [5, 5],
        durationSeconds: 60,
      ));

      result.fold(
        (_) => fail('should be right'),
        (r) {
          // 15 + 15 (cards) + 50 (daily goal) = 80
          expect(r.updatedStats.totalXp, 80);
          expect(r.xpEarned, 80);
        },
      );
    });

    test('hearts decrease on wrong answers', () async {
      final stats = createStats(heartsRemaining: 5);
      setupSuccess(stats);

      final result = await usecase(const UpdateAfterStudyParams(
        deckId: 'deck1',
        ratings: [1, 2, 5],
        durationSeconds: 60,
      ));

      result.fold(
        (_) => fail('should be right'),
        (r) => expect(r.updatedStats.heartsRemaining, 3),
      );
    });

    test('hearts do not go below 0', () async {
      final stats = createStats(heartsRemaining: 1);
      setupSuccess(stats);

      final result = await usecase(const UpdateAfterStudyParams(
        deckId: 'deck1',
        ratings: [0, 1, 2],
        durationSeconds: 60,
      ));

      result.fold(
        (_) => fail('should be right'),
        (r) => expect(r.updatedStats.heartsRemaining, 0),
      );
    });

    test('level changes when XP threshold crossed', () async {
      final stats = createStats(totalXp: 90);
      setupSuccess(stats);

      final result = await usecase(const UpdateAfterStudyParams(
        deckId: 'deck1',
        ratings: [5],
        durationSeconds: 60,
      ));

      result.fold(
        (_) => fail('should be right'),
        (r) {
          // 90 + 15 = 105 → level 2
          expect(r.updatedStats.level, 2);
        },
      );
    });

    test('returns failure when repository fails', () async {
      when(() => mockRepository.getUserStats())
          .thenAnswer((_) async => const Left(CacheFailure('db error')));

      final result = await usecase(const UpdateAfterStudyParams(
        deckId: 'deck1',
        ratings: [5],
        durationSeconds: 60,
      ));

      expect(result.isLeft(), true);
    });

    test('longest streak updates when current exceeds it', () async {
      final yesterday = DateTime.now().subtract(const Duration(days: 1));
      final stats = createStats(
        currentStreak: 5,
        longestStreak: 5,
        lastStudyDate: yesterday,
      );
      setupSuccess(stats);

      final result = await usecase(const UpdateAfterStudyParams(
        deckId: 'deck1',
        ratings: [5],
        durationSeconds: 60,
      ));

      result.fold(
        (_) => fail('should be right'),
        (r) => expect(r.updatedStats.longestStreak, 6),
      );
    });
  });
}
