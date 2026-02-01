/// Server exception
class ServerException implements Exception {
  final String message;

  ServerException([this.message = 'Server error occurred']);

  @override
  String toString() => message;
}

/// Cache exception
class CacheException implements Exception {
  final String message;

  CacheException([this.message = 'Cache error occurred']);

  @override
  String toString() => message;
}

/// Network exception
class NetworkException implements Exception {
  final String message;

  NetworkException([this.message = 'No internet connection']);

  @override
  String toString() => message;
}

/// Authentication exception
class AuthException implements Exception {
  final String message;

  AuthException([this.message = 'Authentication failed']);

  @override
  String toString() => message;
}

/// Validation exception
class ValidationException implements Exception {
  final String message;

  ValidationException([this.message = 'Validation error']);

  @override
  String toString() => message;
}
