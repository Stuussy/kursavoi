import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/error/exceptions.dart';

/// Auth local data source interface
abstract class AuthLocalDataSource {
  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  });

  Future<String?> getAccessToken();

  Future<String?> getRefreshToken();

  Future<void> clearTokens();

  Future<void> saveUserId(String userId);

  Future<String?> getUserId();
}

/// Auth local data source implementation
class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final SharedPreferences sharedPreferences;

  AuthLocalDataSourceImpl(this.sharedPreferences);

  @override
  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    try {
      await sharedPreferences.setString(
        AppConstants.accessTokenKey,
        accessToken,
      );
      await sharedPreferences.setString(
        AppConstants.refreshTokenKey,
        refreshToken,
      );
    } catch (e) {
      throw CacheException('Failed to save tokens');
    }
  }

  @override
  Future<String?> getAccessToken() async {
    try {
      return sharedPreferences.getString(AppConstants.accessTokenKey);
    } catch (e) {
      throw CacheException('Failed to get access token');
    }
  }

  @override
  Future<String?> getRefreshToken() async {
    try {
      return sharedPreferences.getString(AppConstants.refreshTokenKey);
    } catch (e) {
      throw CacheException('Failed to get refresh token');
    }
  }

  @override
  Future<void> clearTokens() async {
    try {
      await sharedPreferences.remove(AppConstants.accessTokenKey);
      await sharedPreferences.remove(AppConstants.refreshTokenKey);
      await sharedPreferences.remove(AppConstants.userIdKey);
    } catch (e) {
      throw CacheException('Failed to clear tokens');
    }
  }

  @override
  Future<void> saveUserId(String userId) async {
    try {
      await sharedPreferences.setString(AppConstants.userIdKey, userId);
    } catch (e) {
      throw CacheException('Failed to save user ID');
    }
  }

  @override
  Future<String?> getUserId() async {
    try {
      return sharedPreferences.getString(AppConstants.userIdKey);
    } catch (e) {
      throw CacheException('Failed to get user ID');
    }
  }
}
