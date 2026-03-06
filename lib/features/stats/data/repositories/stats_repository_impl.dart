import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/study_session_record.dart';
import '../../domain/entities/user_stats.dart';
import '../../domain/repositories/stats_repository.dart';
import '../datasources/stats_local_datasource.dart';
import '../models/study_session_record_model.dart';
import '../models/user_stats_model.dart';

@LazySingleton(as: StatsRepository)
class StatsRepositoryImpl implements StatsRepository {
  const StatsRepositoryImpl(this._localDatasource);

  final StatsLocalDatasource _localDatasource;

  @override
  Future<Either<Failure, UserStats>> getUserStats() async {
    try {
      final model = await _localDatasource.getUserStats();
      if (model == null) {
        return Right(UserStats.empty());
      }
      return Right(model.toEntity());
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, Unit>> updateStats(UserStats stats) async {
    try {
      await _localDatasource.saveUserStats(UserStatsModel.fromEntity(stats));
      return const Right(unit);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, Unit>> addSessionRecord(
    StudySessionRecord record,
  ) async {
    try {
      await _localDatasource
          .addSessionRecord(StudySessionRecordModel.fromEntity(record));
      return const Right(unit);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<StudySessionRecord>>> getWeeklyRecords() async {
    try {
      final models = await _localDatasource.getWeeklyRecords();
      return Right(models.map((m) => m.toEntity()).toList());
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }
}
