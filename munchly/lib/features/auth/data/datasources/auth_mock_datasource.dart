import '../models/auth_tokens_model.dart';
import '../models/user_model.dart';
import 'auth_remote_datasource.dart';
import '../../../../core/error/exceptions.dart';

/// Mock auth remote data source for development
class AuthMockDataSource implements AuthRemoteDataSource {
  // Mock users database
  final List<Map<String, dynamic>> _users = [];

  // Mock authenticated user
  String? _currentUserId;

  @override
  Future<AuthTokensModel> login({
    required String email,
    required String password,
  }) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    // Find user by email
    final user = _users.firstWhere(
      (u) => u['email'] == email,
      orElse: () => throw AuthException('Invalid credentials'),
    );

    // Check password
    if (user['password'] != password) {
      throw AuthException('Invalid credentials');
    }

    _currentUserId = user['id'];

    // Return mock tokens
    return AuthTokensModel(
      accessToken: 'mock_access_token_${user['id']}',
      refreshToken: 'mock_refresh_token_${user['id']}',
    );
  }

  @override
  Future<AuthTokensModel> register({
    required String email,
    required String password,
    required String name,
    String? phone,
  }) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    // Check if user already exists
    final existingUser = _users.any((u) => u['email'] == email);
    if (existingUser) {
      throw AuthException('User already exists');
    }

    // Create new user
    final userId = 'user_${_users.length + 1}';
    _users.add({
      'id': userId,
      'email': email,
      'password': password,
      'name': name,
      'phone': phone,
      'role': 'user',
      'createdAt': DateTime.now().toIso8601String(),
    });

    _currentUserId = userId;

    // Return mock tokens
    return AuthTokensModel(
      accessToken: 'mock_access_token_$userId',
      refreshToken: 'mock_refresh_token_$userId',
    );
  }

  @override
  Future<void> logout() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));
    _currentUserId = null;
  }

  @override
  Future<UserModel> getCurrentUser() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));

    if (_currentUserId == null) {
      throw AuthException('Unauthorized');
    }

    final user = _users.firstWhere(
      (u) => u['id'] == _currentUserId,
      orElse: () => throw AuthException('User not found'),
    );

    return UserModel(
      id: user['id'],
      email: user['email'],
      name: user['name'],
      phone: user['phone'],
      role: user['role'] as String? ?? 'user',
      createdAt: DateTime.parse(user['createdAt']),
    );
  }

  @override
  Future<AuthTokensModel> refreshToken(String refreshToken) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));

    if (_currentUserId == null) {
      throw AuthException('Invalid refresh token');
    }

    // Return new mock tokens
    return AuthTokensModel(
      accessToken: 'mock_access_token_refreshed_$_currentUserId',
      refreshToken: 'mock_refresh_token_refreshed_$_currentUserId',
    );
  }

  @override
  Future<UserModel> updateProfile({
    required String name,
    String? phone,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));

    if (_currentUserId == null) {
      throw AuthException('Unauthorized');
    }

    final userIndex = _users.indexWhere((u) => u['id'] == _currentUserId);
    if (userIndex == -1) {
      throw AuthException('User not found');
    }

    _users[userIndex]['name'] = name;
    if (phone != null) {
      _users[userIndex]['phone'] = phone;
    }

    final user = _users[userIndex];
    return UserModel(
      id: user['id'],
      email: user['email'],
      name: user['name'],
      phone: user['phone'],
      role: user['role'] as String? ?? 'user',
      createdAt: DateTime.parse(user['createdAt']),
    );
  }

  /// Add a test user for development
  void addTestUser({
    required String email,
    required String password,
    required String name,
    String? phone,
    String role = 'user',
  }) {
    final userId = 'user_${_users.length + 1}';
    _users.add({
      'id': userId,
      'email': email,
      'password': password,
      'name': name,
      'phone': phone,
      'role': role,
      'createdAt': DateTime.now().toIso8601String(),
    });
  }
}
