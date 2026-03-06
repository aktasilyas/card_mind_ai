import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/errors/exceptions.dart';
import '../models/study_session_record_model.dart';
import '../models/user_stats_model.dart';

abstract class StatsLocalDatasource {
  Future<UserStatsModel?> getUserStats();
  Future<void> saveUserStats(UserStatsModel stats);
  Future<void> addSessionRecord(StudySessionRecordModel record);
  Future<List<StudySessionRecordModel>> getWeeklyRecords();
}

@LazySingleton(as: StatsLocalDatasource)
class StatsLocalDatasourceImpl implements StatsLocalDatasource {
  const StatsLocalDatasourceImpl(this._statsBox, this._sessionRecordsBox);

  final Box<UserStatsModel> _statsBox;
  final Box<StudySessionRecordModel> _sessionRecordsBox;

  static const _userStatsKey = 'user_stats';
  static const _uuid = Uuid();

  @override
  Future<UserStatsModel?> getUserStats() async {
    try {
      return _statsBox.get(_userStatsKey);
    } catch (e) {
      throw CacheException(message: e.toString());
    }
  }

  @override
  Future<void> saveUserStats(UserStatsModel stats) async {
    try {
      await _statsBox.put(_userStatsKey, stats);
    } catch (e) {
      throw CacheException(message: e.toString());
    }
  }

  @override
  Future<void> addSessionRecord(StudySessionRecordModel record) async {
    try {
      await _sessionRecordsBox.put(_uuid.v4(), record);
    } catch (e) {
      throw CacheException(message: e.toString());
    }
  }

  @override
  Future<List<StudySessionRecordModel>> getWeeklyRecords() async {
    try {
      final now = DateTime.now();
      final weekAgo = now.subtract(const Duration(days: 7));
      return _sessionRecordsBox.values
          .where((record) => record.date.isAfter(weekAgo))
          .toList();
    } catch (e) {
      throw CacheException(message: e.toString());
    }
  }
}
