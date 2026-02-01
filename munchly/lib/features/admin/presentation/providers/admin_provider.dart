import 'package:flutter/foundation.dart';
import '../../data/datasources/admin_remote_datasource.dart';
import '../../data/datasources/admin_mock_datasource.dart';
import '../../../../core/config/app_config.dart';

/// Admin panel state provider
class AdminProvider extends ChangeNotifier {
  final AdminRemoteDataSource _datasource;
  final AdminMockDataSource? _mockDataSource;

  AdminProvider({
    required AdminRemoteDataSource datasource,
    AdminMockDataSource? mockDataSource,
  })  : _datasource = datasource,
        _mockDataSource = mockDataSource;

  AdminStats? _stats;
  List<AdminUser> _users = [];
  List<AdminBooking> _bookings = [];
  List<AdminRestaurant> _restaurants = [];
  bool _isLoading = false;
  String? _errorMessage;

  AdminStats? get stats => _stats;
  List<AdminUser> get users => _users;
  List<AdminBooking> get bookings => _bookings;
  List<AdminRestaurant> get restaurants => _restaurants;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  /// Load statistics
  Future<void> loadStats() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      if (AppConfig.useMockData && _mockDataSource != null) {
        _stats = await _mockDataSource!.getStats();
      } else {
        _stats = await _datasource.getStats();
      }
    } catch (e) {
      _errorMessage = 'Failed to load statistics: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Load all users
  Future<void> loadUsers() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      if (AppConfig.useMockData && _mockDataSource != null) {
        _users = await _mockDataSource!.getUsers();
      } else {
        _users = await _datasource.getUsers();
      }
    } catch (e) {
      _errorMessage = 'Failed to load users: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Load all bookings
  Future<void> loadBookings() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      if (AppConfig.useMockData && _mockDataSource != null) {
        _bookings = await _mockDataSource!.getBookings();
      } else {
        _bookings = await _datasource.getBookings();
      }
    } catch (e) {
      _errorMessage = 'Failed to load bookings: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Load all restaurants from MongoDB
  Future<void> loadRestaurants() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _restaurants = await _datasource.getRestaurants();
    } catch (e) {
      _errorMessage = 'Failed to load restaurants: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Create restaurant in MongoDB
  Future<bool> createRestaurant({
    required String name,
    required String description,
    required String cuisine,
    required String address,
    required String phone,
    required String priceRange,
    String? imageUrl,
    bool isOpen = true,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final restaurant = await _datasource.createRestaurant(
        name: name,
        description: description,
        cuisine: cuisine,
        address: address,
        phone: phone,
        priceRange: priceRange,
        imageUrl: imageUrl,
        isOpen: isOpen,
      );
      _restaurants.insert(0, restaurant);
      return true;
    } catch (e) {
      _errorMessage = 'Failed to create restaurant: $e';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Delete restaurant from MongoDB
  Future<bool> deleteRestaurant(String id) async {
    try {
      await _datasource.deleteRestaurant(id);
      _restaurants.removeWhere((r) => r.id == id);
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Failed to delete restaurant: $e';
      notifyListeners();
      return false;
    }
  }

  /// Clear error
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
