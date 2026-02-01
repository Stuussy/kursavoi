import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/auth_tokens.dart';
import '../repositories/auth_repository.dart';

/// Register use case
class RegisterUseCase {
  final AuthRepository repository;

  RegisterUseCase(this.repository);

  Future<Either<Failure, AuthTokens>> call({
    required String email,
    required String password,
    required String name,
    String? phone,
  }) async {
    return await repository.register(
      email: email,
      password: password,
      name: name,
      phone: phone,
    );
  }
}
