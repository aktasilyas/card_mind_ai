sealed class Failure {
  const Failure(this.message);

  final String message;
}

final class ServerFailure extends Failure {
  const ServerFailure(super.message);
}

final class CacheFailure extends Failure {
  const CacheFailure(super.message);
}

final class NetworkFailure extends Failure {
  const NetworkFailure(super.message);
}

final class LimitExceededFailure extends Failure {
  const LimitExceededFailure(super.message);
}

final class AuthFailure extends Failure {
  const AuthFailure(super.message);
}

final class PurchaseFailure extends Failure {
  const PurchaseFailure(super.message);
}

final class PermissionFailure extends Failure {
  const PermissionFailure(super.message);
}
