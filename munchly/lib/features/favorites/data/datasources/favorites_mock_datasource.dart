import '../models/favorite_model.dart';

/// Mock data source for favorites (for development)
class FavoritesMockDataSource {
  final List<FavoriteModel> _favorites = [];

  /// Get all favorites
  Future<List<FavoriteModel>> getFavorites() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return List.unmodifiable(_favorites);
  }

  /// Add to favorites
  Future<FavoriteModel> addToFavorites({
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
    await Future.delayed(const Duration(milliseconds: 500));

    // Check if already exists
    final exists = _favorites.any((f) => f.restaurantId == restaurantId);
    if (exists) {
      throw Exception('Already in favorites');
    }

    final favorite = FavoriteModel(
      id: 'fav_${_favorites.length + 1}',
      userId: 'current-user-id',
      restaurantId: restaurantId,
      restaurantName: restaurantName,
      cuisine: cuisine,
      rating: rating,
      reviewCount: reviewCount,
      address: address,
      priceRange: priceRange,
      description: description,
      isOpen: isOpen,
      createdAt: DateTime.now(),
    );

    _favorites.add(favorite);
    return favorite;
  }

  /// Check if favorited
  Future<bool> isFavorited(String restaurantId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return _favorites.any((f) => f.restaurantId == restaurantId);
  }

  /// Remove from favorites
  Future<void> removeFromFavorites(String restaurantId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    _favorites.removeWhere((f) => f.restaurantId == restaurantId);
  }
}
