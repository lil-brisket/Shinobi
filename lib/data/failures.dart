/// Failure classes for error handling across the application
/// These represent different types of errors that can occur in the data layer
sealed class Failure {
  const Failure();
  
  String get message;
}

/// Network-related failures
class NetworkFailure extends Failure {
  const NetworkFailure(this.message);
  
  @override
  final String message;
}

/// Authentication-related failures
class AuthFailure extends Failure {
  const AuthFailure(this.message);
  
  @override
  final String message;
}

/// Data validation failures
class ValidationFailure extends Failure {
  const ValidationFailure(this.message);
  
  @override
  final String message;
}

/// Database/Storage failures
class StorageFailure extends Failure {
  const StorageFailure(this.message);
  
  @override
  final String message;
}

/// Generic server errors
class ServerFailure extends Failure {
  const ServerFailure(this.message);
  
  @override
  final String message;
}

/// Resource not found errors
class NotFoundFailure extends Failure {
  const NotFoundFailure(this.message);
  
  @override
  final String message;
}

/// Permission/Authorization failures
class PermissionFailure extends Failure {
  const PermissionFailure(this.message);
  
  @override
  final String message;
}
