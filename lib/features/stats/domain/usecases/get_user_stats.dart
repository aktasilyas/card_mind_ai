import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/user_stats.dart';
import '../repositories/stats_repository.dart';

@injectable
class GetUserStats implements UseCase<UserStats, NoParams> {
  const GetUserStats(this._repository);

  final StatsRepository _repository;

  @override
  Future<Either<Failure, UserStats>> call(NoParams params) {
    return _repository.getUserStats();
  }
}
