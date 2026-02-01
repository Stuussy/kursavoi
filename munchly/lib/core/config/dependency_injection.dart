import 'package:shared_preferences/shared_preferences.dart';
import '../../features/auth/data/datasources/auth_local_datasource.dart';
import '../../features/auth/data/datasources/auth_remote_datasource.dart';
import '../../features/auth/data/datasources/auth_mock_datasource.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/usecases/get_current_user_usecase.dart';
import '../../features/auth/domain/usecases/login_usecase.dart';
import '../../features/auth/domain/usecases/logout_usecase.dart';
import '../../features/auth/domain/usecases/register_usecase.dart';
import '../../features/auth/presentation/providers/auth_provider.dart';
import '../../features/bookings/data/datasources/bookings_mock_datasource.dart';
import '../../features/bookings/data/datasources/bookings_remote_datasource.dart';
import '../../features/bookings/data/repositories/bookings_repository_impl.dart';
import '../../features/bookings/domain/repositories/bookings_repository.dart';
import '../../features/bookings/presentation/providers/bookings_provider.dart';
import '../../features/favorites/data/datasources/favorites_remote_datasource.dart';
import '../../features/favorites/data/datasources/favorites_mock_datasource.dart';
import '../../features/favorites/data/repositories/favorites_repository_impl.dart';
import '../../features/favorites/domain/repositories/favorites_repository.dart';
import '../../features/favorites/presentation/providers/favorites_provider.dart';
import '../../features/admin/data/datasources/admin_remote_datasource.dart';
import '../../features/admin/data/datasources/admin_mock_datasource.dart';
import '../../features/admin/presentation/providers/admin_provider.dart';
import '../network/dio_client.dart';
import 'app_config.dart';

/// Dependency injection setup
class DependencyInjection {
  static DioClient? _dioClient;
  static SharedPreferences? _sharedPreferences;
  static AuthProvider? _authProvider;
  static AuthMockDataSource? _authMockDataSource;
  static BookingsRepository? _bookingsRepository;
  static BookingsProvider? _bookingsProvider;
  static FavoritesRepository? _favoritesRepository;
  static FavoritesProvider? _favoritesProvider;
  static FavoritesMockDataSource? _favoritesMockDataSource;
  static AdminProvider? _adminProvider;
  static AdminMockDataSource? _adminMockDataSource;

  /// Initialize dependencies
  static Future<void> init() async {
    // Core
    _sharedPreferences = await SharedPreferences.getInstance();
    _dioClient = DioClient();

    // Auth
    final authLocalDataSource =
        AuthLocalDataSourceImpl(_sharedPreferences!);

    // Choose between mock or real data source
    final AuthRemoteDataSource authRemoteDataSource;
    if (AppConfig.useMockData) {
      _authMockDataSource = AuthMockDataSource();
      // Add test users
      _authMockDataSource!.addTestUser(
        email: 'test@munchly.com',
        password: 'password123',
        name: 'Test User',
        phone: '+1234567890',
      );
      _authMockDataSource!.addTestUser(
        email: 'demo@munchly.com',
        password: 'demo123',
        name: 'Demo User',
      );
      _authMockDataSource!.addTestUser(
        email: 'admin@munchly.com',
        password: 'admin123',
        name: 'Admin User',
        phone: '+1234567890',
        role: 'admin',
      );
      authRemoteDataSource = _authMockDataSource!;
    } else {
      authRemoteDataSource = AuthRemoteDataSourceImpl(_dioClient!);
    }

    final authRepository = AuthRepositoryImpl(
      remoteDataSource: authRemoteDataSource,
      localDataSource: authLocalDataSource,
      dioClient: _dioClient!,
    );

    // Use cases
    final loginUseCase = LoginUseCase(authRepository);
    final registerUseCase = RegisterUseCase(authRepository);
    final logoutUseCase = LogoutUseCase(authRepository);
    final getCurrentUserUseCase = GetCurrentUserUseCase(authRepository);

    // Provider
    _authProvider = AuthProvider(
      loginUseCase: loginUseCase,
      registerUseCase: registerUseCase,
      logoutUseCase: logoutUseCase,
      getCurrentUserUseCase: getCurrentUserUseCase,
      repository: authRepository,
    );

    // Load saved token if exists
    final accessToken = await authLocalDataSource.getAccessToken();
    if (accessToken != null && accessToken.isNotEmpty) {
      _dioClient!.setAuthToken(accessToken);
    }

    // Bookings
    final bookingsMockDataSource = BookingsMockDataSource();
    final bookingsRemoteDataSource = BookingsRemoteDataSource(_dioClient!);
    _bookingsRepository = BookingsRepositoryImpl(
      mockDataSource: bookingsMockDataSource,
      remoteDataSource: bookingsRemoteDataSource,
    );
    _bookingsProvider = BookingsProvider(repository: _bookingsRepository!);

    // Favorites
    if (AppConfig.useMockData) {
      _favoritesMockDataSource = FavoritesMockDataSource();
    }
    final favoritesRemoteDataSource = FavoritesRemoteDataSource(_dioClient!);
    _favoritesRepository = FavoritesRepositoryImpl(
      favoritesRemoteDataSource,
      mockDataSource: _favoritesMockDataSource,
    );
    _favoritesProvider = FavoritesProvider(repository: _favoritesRepository!);

    // Admin
    if (AppConfig.useMockData) {
      _adminMockDataSource = AdminMockDataSource();
    }
    final adminRemoteDataSource = AdminRemoteDataSource(_dioClient!);
    _adminProvider = AdminProvider(
      datasource: adminRemoteDataSource,
      mockDataSource: _adminMockDataSource,
    );
  }

  /// Get DioClient instance
  static DioClient get dioClient => _dioClient!;

  /// Get SharedPreferences instance
  static SharedPreferences get sharedPreferences => _sharedPreferences!;

  /// Get AuthProvider instance
  static AuthProvider get authProvider => _authProvider!;

  /// Get BookingsRepository instance
  static BookingsRepository get bookingsRepository => _bookingsRepository!;

  /// Get BookingsProvider instance
  static BookingsProvider get bookingsProvider => _bookingsProvider!;

  /// Get FavoritesProvider instance
  static FavoritesProvider get favoritesProvider => _favoritesProvider!;

  /// Get AdminProvider instance
  static AdminProvider get adminProvider => _adminProvider!;
}
