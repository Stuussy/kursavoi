import '../entities/favorite.dart';

/// Repository interface for favorites
abstract class FavoritesRepository {
  /// Add restaurant to favorites
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
  });

  /// Get all favorite restaurants for current user
  Future<List<Favorite>> getFavorites();

  /// Check if restaurant is in favorites
  Future<bool> isFavorited(String restaurantId);

  /// Remove restaurant from favorites
  Future<void> removeFromFavorites(String restaurantId);
}
