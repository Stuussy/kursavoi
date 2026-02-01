import '../../domain/entities/favorite.dart';
import '../../domain/repositories/favorites_repository.dart';
import '../datasources/favorites_remote_datasource.dart';
import '../datasources/favorites_mock_datasource.dart';
import '../../../../core/config/app_config.dart';

/// Implementation of FavoritesRepository
class FavoritesRepositoryImpl implements FavoritesRepository {
  final FavoritesRemoteDataSource _remoteDataSource;
  final FavoritesMockDataSource? _mockDataSource;

  FavoritesRepositoryImpl(
    this._remoteDataSource, {
    FavoritesMockDataSource? mockDataSource,
  }) : _mockDataSource = mockDataSource;

  @override
  Future<Favorite> addToFavorites({
    required String restaurantId,
    required String restaurantName,
    required String cuisine,
    required double rating,
    required int reviewCount,
    required String address,
    required String priceRange,
    required String description,
    required bool isOpen,
  }) async {
    if (AppConfig.useMockData && _mockDataSource != null) {
      final model = await _mockDataSource!.addToFavorites(
        restaurantId: restaurantId,
        restaurantName: restaurantName,
        cuisine: cuisine,
        rating: rating,
        reviewCount: reviewCount,
        address: address,
        priceRange: priceRange,
        description: description,
        isOpen: isOpen,
      );
      return model.toEntity();
    }

    final model = await _remoteDataSource.addToFavorites(
      restaurantId: restaurantId,
      restaurantName: restaurantName,
      cuisine: cuisine,
      rating: rating,
      reviewCount: reviewCount,
      address: address,
      priceRange: priceRange,
      description: description,
      isOpen: isOpen,
    );
    return model.toEntity();
  }

  @override
  Future<List<Favorite>> getFavorites() async {
    if (AppConfig.useMockData && _mockDataSource != null) {
      final models = await _mockDataSource!.getFavorites();
      return models.map((model) => model.toEntity()).toList();
    }

    final models = await _remoteDataSource.getFavorites();
    return models.map((model) => model.toEntity()).toList();
  }

  @override
  Future<bool> isFavorited(String restaurantId) async {
    if (AppConfig.useMockData && _mockDataSource != null) {
      return await _mockDataSource!.isFavorited(restaurantId);
    }

    return await _remoteDataSource.isFavorited(restaurantId);
  }

  @override
  Future<void> removeFromFavorites(String restaurantId) async {
    if (AppConfig.useMockData && _mockDataSource != null) {
      await _mockDataSource!.removeFromFavorites(restaurantId);
      return;
    }

    await _remoteDataSource.removeFromFavorites(restaurantId);
  }
}
