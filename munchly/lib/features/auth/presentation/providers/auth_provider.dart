import 'package:flutter/foundation.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/register_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';
import '../../domain/usecases/get_current_user_usecase.dart';

/// Authentication state provider
class AuthProvider extends ChangeNotifier {
  final LoginUseCase _loginUseCase;
  final RegisterUseCase _registerUseCase;
  final LogoutUseCase _logoutUseCase;
  final GetCurrentUserUseCase _getCurrentUserUseCase;
  final AuthRepository _repository;

  AuthProvider({
    required LoginUseCase loginUseCase,
    required RegisterUseCase registerUseCase,
    required LogoutUseCase logoutUseCase,
    required GetCurrentUserUseCase getCurrentUserUseCase,
    required AuthRepository repository,
  })  : _loginUseCase = loginUseCase,
        _registerUseCase = registerUseCase,
        _logoutUseCase = logoutUseCase,
        _getCurrentUserUseCase = getCurrentUserUseCase,
        _repository = repository;

  User? _currentUser;
  bool _isLoading = false;
  String? _errorMessage;

  User? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _currentUser != null;
  bool get isAdmin => _currentUser?.role == 'admin';

  /// Initialize auth state
  Future<void> init() async {
    _setLoading(true);
    try {
      final result = await _getCurrentUserUseCase();
      result.fold(
        (failure) => _currentUser = null,
        (user) => _currentUser = user,
      );
    } catch (e) {
      _currentUser = null;
    } finally {
      _setLoading(false);
    }
  }

  /// Login with email and password
  Future<bool> login({
    required String email,
    required String password,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      final result = await _loginUseCase(
        email: email,
        password: password,
      );

      return await result.fold(
        (failure) {
          _setError(failure.message);
          return false;
        },
        (tokens) async {
          // Get user data after successful login
          final userResult = await _getCurrentUserUseCase();
          return userResult.fold(
            (failure) {
              _setError(failure.message);
              return false;
            },
            (user) {
              _currentUser = user;
              notifyListeners();
              return true;
            },
          );
        },
      );
    } catch (e) {
      _setError('An unexpected error occurred');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Register new user
  Future<bool> register({
    required String name,
    required String email,
    required String password,
    required String phone,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      final result = await _registerUseCase(
        name: name,
        email: email,
        password: password,
        phone: phone,
      );

      return await result.fold(
        (failure) {
          _setError(failure.message);
          return false;
        },
        (tokens) async {
          // Get user data after successful registration
          final userResult = await _getCurrentUserUseCase();
          return userResult.fold(
            (failure) {
              _setError(failure.message);
              return false;
            },
            (user) {
              _currentUser = user;
              notifyListeners();
              return true;
            },
          );
        },
      );
    } catch (e) {
      _setError('An unexpected error occurred');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Update user profile
  Future<bool> updateProfile({
    required String name,
    String? phone,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      final result = await _repository.updateProfile(
        name: name,
        phone: phone,
      );

      return result.fold(
        (failure) {
          _setError(failure.message);
          return false;
        },
        (user) {
          _currentUser = user;
          notifyListeners();
          return true;
        },
      );
    } catch (e) {
      _setError('Қате орын алды');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Logout current user
  Future<void> logout() async {
    _setLoading(true);
    try {
      await _logoutUseCase();
      _currentUser = null;
      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setError(String message) {
    _errorMessage = message;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
  }

  /// Clear error message
  void clearError() {
    _clearError();
    notifyListeners();
  }
}
