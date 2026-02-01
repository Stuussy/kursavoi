import 'package:flutter/foundation.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/config/app_config.dart';
import '../../../restaurants/domain/entities/restaurant.dart';
import '../../../restaurants/data/datasources/restaurants_mock_datasource.dart';

/// Home screen provider for loading restaurants
class HomeProvider extends ChangeNotifier {
  final DioClient _dioClient;
  final RestaurantsMockDataSource _mockDataSource;

  List<Restaurant> _restaurants = [];
  List<Restaurant> _filteredRestaurants = [];
  bool _isLoading = false;
  String? _errorMessage;
  String _searchQuery = '';
  String _selectedCuisine = 'Барлығы';

  HomeProvider({
    required DioClient dioClient,
    RestaurantsMockDataSource? mockDataSource,
  })  : _dioClient = dioClient,
        _mockDataSource = mockDataSource ?? RestaurantsMockDataSource();

  List<Restaurant> get restaurants => _restaurants;
  List<Restaurant> get filteredRestaurants => _filteredRestaurants;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String get searchQuery => _searchQuery;
  String get selectedCuisine => _selectedCuisine;

  /// Load restaurants from API or mock data
  Future<void> loadRestaurants() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      if (AppConfig.useMockData) {
        _restaurants = _mockDataSource.getAllRestaurants();
      } else {
        final response = await _dioClient.get('/restaurants');
        if (response.data['data'] != null) {
          final List<dynamic> json = response.data['data'];
          _restaurants = json.map((e) => Restaurant.fromJson(e)).toList();
        } else {
          _restaurants = [];
        }
      }
      _applyFilters();
    } catch (e) {
      _errorMessage = 'Ресторандарды жүктеу қатесі: $e';
      // Fallback to mock data on error
      _restaurants = _mockDataSource.getAllRestaurants();
      _applyFilters();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Search restaurants
  void searchRestaurants(String query) {
    _searchQuery = query;
    _applyFilters();
    notifyListeners();
  }

  /// Filter by cuisine
  void filterByCuisine(String cuisine) {
    _selectedCuisine = cuisine;
    _applyFilters();
    notifyListeners();
  }

  /// Apply all filters
  void _applyFilters() {
    final englishCuisine = _selectedCuisine == 'Барлығы' ? 'All' : _selectedCuisine;

    _filteredRestaurants = _restaurants.where((restaurant) {
      // Apply cuisine filter
      final matchesCuisine = englishCuisine == 'All' ||
          restaurant.cuisine == englishCuisine;

      // Apply search filter
      final lowerQuery = _searchQuery.toLowerCase();
      final matchesSearch = _searchQuery.isEmpty ||
          restaurant.name.toLowerCase().contains(lowerQuery) ||
          restaurant.cuisine.toLowerCase().contains(lowerQuery) ||
          restaurant.description.toLowerCase().contains(lowerQuery);

      return matchesCuisine && matchesSearch;
    }).toList();
  }

  /// Get restaurant by ID
  Restaurant? getRestaurantById(String id) {
    try {
      return _restaurants.firstWhere((r) => r.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Refresh restaurants (reload from API)
  Future<void> refresh() async {
    await loadRestaurants();
  }

  /// Clear error
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
