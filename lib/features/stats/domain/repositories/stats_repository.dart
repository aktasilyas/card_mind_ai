import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/study_session_record.dart';
import '../entities/user_stats.dart';

abstract class StatsRepository {
  Future<Either<Failure, UserStats>> getUserStats();
  Future<Either<Failure, Unit>> updateStats(UserStats stats);
  Future<Either<Failure, Unit>> addSessionRecord(StudySessionRecord record);
  Future<Either<Failure, List<StudySessionRecord>>> getWeeklyRecords();
}
