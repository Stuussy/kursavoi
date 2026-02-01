import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/user.dart';
import '../entities/auth_tokens.dart';

/// Auth repository interface
abstract class AuthRepository {
  /// Login with email and password
  Future<Either<Failure, AuthTokens>> login({
    required String email,
    required String password,
  });

  /// Register new user
  Future<Either<Failure, AuthTokens>> register({
    required String email,
    required String password,
    required String name,
    String? phone,
  });

  /// Logout current user
  Future<Either<Failure, void>> logout();

  /// Get current user
  Future<Either<Failure, User>> getCurrentUser();

  /// Refresh access token
  Future<Either<Failure, AuthTokens>> refreshToken(String refreshToken);

  /// Update user profile
  Future<Either<Failure, User>> updateProfile({
    required String name,
    String? phone,
  });

  /// Check if user is authenticated
  Future<bool> isAuthenticated();
}
