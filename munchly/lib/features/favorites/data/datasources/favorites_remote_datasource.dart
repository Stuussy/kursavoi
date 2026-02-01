import '../../../../core/config/api_config.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/network/dio_client.dart';
import '../models/favorite_model.dart';

/// Remote data source for favorites
class FavoritesRemoteDataSource {
  final DioClient dioClient;

  FavoritesRemoteDataSource(this.dioClient);

  /// Add restaurant to favorites
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
    try {
      final response = await dioClient.post(
        ApiConfig.favoritesEndpoint,
        data: {
          'restaurantId': restaurantId,
          'restaurantName': restaurantName,
          'cuisine': cuisine,
          'rating': rating,
          'reviewCount': reviewCount,
          'address': address,
          'priceRange': priceRange,
          'description': description,
          'isOpen': isOpen,
        },
      );

      if (response.data['data'] != null) {
        return FavoriteModel.fromJson(response.data['data']);
      }

      throw ServerException('Invalid response format');
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException(e.toString());
    }
  }

  /// Get all favorite restaurants for current user
  Future<List<FavoriteModel>> getFavorites() async {
    try {
      final response = await dioClient.get(ApiConfig.myFavoritesEndpoint);

      if (response.data['data'] != null) {
        final List<dynamic> favoritesJson = response.data['data'];
        return favoritesJson
            .map((json) => FavoriteModel.fromJson(json))
            .toList();
      }

      return [];
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException(e.toString());
    }
  }

  /// Check if restaurant is in favorites
  Future<bool> isFavorited(String restaurantId) async {
    try {
      final endpoint = ApiConfig.checkFavoriteEndpoint
          .replaceAll('{restaurantId}', restaurantId);
      final response = await dioClient.get(endpoint);

      if (response.data['data'] != null) {
        return response.data['data']['isFavorited'] as bool;
      }

      return false;
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException(e.toString());
    }
  }

  /// Remove restaurant from favorites
  Future<void> removeFromFavorites(String restaurantId) async {
    try {
      final endpoint = ApiConfig.removeFavoriteEndpoint
          .replaceAll('{restaurantId}', restaurantId);
      await dioClient.delete(endpoint);
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException(e.toString());
    }
  }
}
