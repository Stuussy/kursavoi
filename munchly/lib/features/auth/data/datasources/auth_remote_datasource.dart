import 'package:dio/dio.dart';
import '../../../../core/config/api_config.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/network/dio_client.dart';
import '../models/auth_tokens_model.dart';
import '../models/user_model.dart';

/// Auth remote data source interface
abstract class AuthRemoteDataSource {
  Future<AuthTokensModel> login({
    required String email,
    required String password,
  });

  Future<AuthTokensModel> register({
    required String email,
    required String password,
    required String name,
    String? phone,
  });

  Future<void> logout();

  Future<UserModel> getCurrentUser();

  Future<AuthTokensModel> refreshToken(String refreshToken);

  Future<UserModel> updateProfile({
    required String name,
    String? phone,
  });
}

/// Auth remote data source implementation
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final DioClient dioClient;

  AuthRemoteDataSourceImpl(this.dioClient);

  @override
  Future<AuthTokensModel> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await dioClient.post(
        ApiConfig.loginEndpoint,
        data: {
          'email': email,
          'password': password,
        },
      );

      if (response.statusCode == 200) {
        return AuthTokensModel.fromJson(response.data['data']);
      } else {
        throw ServerException('Login failed');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw AuthException('Invalid credentials');
      } else if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw NetworkException();
      } else {
        throw ServerException(e.message ?? 'Unknown error');
      }
    }
  }

  @override
  Future<AuthTokensModel> register({
    required String email,
    required String password,
    required String name,
    String? phone,
  }) async {
    try {
      final response = await dioClient.post(
        ApiConfig.registerEndpoint,
        data: {
          'email': email,
          'password': password,
          'name': name,
          if (phone != null) 'phone': phone,
        },
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        return AuthTokensModel.fromJson(response.data['data']);
      } else {
        throw ServerException('Registration failed');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 409) {
        throw AuthException('User already exists');
      } else if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw NetworkException();
      } else {
        throw ServerException(e.message ?? 'Unknown error');
      }
    }
  }

  @override
  Future<void> logout() async {
    try {
      await dioClient.post(ApiConfig.logoutEndpoint);
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw NetworkException();
      } else {
        throw ServerException(e.message ?? 'Unknown error');
      }
    }
  }

  @override
  Future<UserModel> getCurrentUser() async {
    try {
      final response = await dioClient.get(ApiConfig.meEndpoint);

      if (response.statusCode == 200) {
        return UserModel.fromJson(response.data['data']);
      } else {
        throw ServerException('Failed to get user');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw AuthException('Unauthorized');
      } else if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw NetworkException();
      } else {
        throw ServerException(e.message ?? 'Unknown error');
      }
    }
  }

  @override
  Future<AuthTokensModel> refreshToken(String refreshToken) async {
    try {
      final response = await dioClient.post(
        ApiConfig.refreshTokenEndpoint,
        data: {
          'refreshToken': refreshToken,
        },
      );

      if (response.statusCode == 200) {
        return AuthTokensModel.fromJson(response.data['data']);
      } else {
        throw ServerException('Token refresh failed');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw AuthException('Invalid refresh token');
      } else if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw NetworkException();
      } else {
        throw ServerException(e.message ?? 'Unknown error');
      }
    }
  }

  @override
  Future<UserModel> updateProfile({
    required String name,
    String? phone,
  }) async {
    try {
      final response = await dioClient.put(
        ApiConfig.meEndpoint,
        data: {
          'name': name,
          if (phone != null) 'phone': phone,
        },
      );

      if (response.statusCode == 200) {
        return UserModel.fromJson(response.data['data']);
      } else {
        throw ServerException('Failed to update profile');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw AuthException('Unauthorized');
      } else {
        throw ServerException(e.message ?? 'Unknown error');
      }
    }
  }
}
