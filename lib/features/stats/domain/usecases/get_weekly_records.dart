import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/study_session_record.dart';
import '../repositories/stats_repository.dart';

@injectable
class GetWeeklyRecords
    implements UseCase<List<StudySessionRecord>, NoParams> {
  const GetWeeklyRecords(this._repository);

  final StatsRepository _repository;

  @override
  Future<Either<Failure, List<StudySessionRecord>>> call(NoParams params) {
    return _repository.getWeeklyRecords();
  }
}
