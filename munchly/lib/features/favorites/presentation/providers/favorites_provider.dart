import 'package:flutter/foundation.dart';
import '../../domain/entities/favorite.dart';
import '../../domain/repositories/favorites_repository.dart';

/// Favorites state provider
class FavoritesProvider extends ChangeNotifier {
  final FavoritesRepository _repository;

  FavoritesProvider({required FavoritesRepository repository})
      : _repository = repository;

  List<Favorite> _favorites = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<Favorite> get favorites => _favorites;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  /// Load user favorites
  Future<void> loadFavorites() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _favorites = await _repository.getFavorites();
    } catch (e) {
      _errorMessage = 'Failed to load favorites';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Add restaurant to favorites
  Future<bool> addFavorite({
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
    try {
      await _repository.addToFavorites(
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
      await loadFavorites(); // Reload favorites
      return true;
    } catch (e) {
      _errorMessage = 'Failed to add favorite';
      notifyListeners();
      return false;
    }
  }

  /// Remove restaurant from favorites
  Future<bool> removeFavorite(String restaurantId) async {
    try {
      await _repository.removeFromFavorites(restaurantId);
      _favorites.removeWhere((f) => f.restaurantId == restaurantId);
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Failed to remove favorite';
      notifyListeners();
      return false;
    }
  }

  /// Check if restaurant is in favorites (from repository)
  Future<bool> checkIsFavorite(String restaurantId) async {
    try {
      return await _repository.isFavorited(restaurantId);
    } catch (e) {
      return false;
    }
  }

  /// Check if restaurant is favorited
  bool isFavorite(String restaurantId) {
    return _favorites.any((f) => f.restaurantId == restaurantId);
  }

  /// Clear error message
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}