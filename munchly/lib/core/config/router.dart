import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/register_screen.dart';
import '../../features/main/presentation/screens/main_screen.dart';
import '../../features/restaurants/presentation/screens/restaurant_details_screen.dart';
import '../../features/bookings/presentation/screens/booking_screen.dart';
import '../../features/profile/presentation/screens/edit_profile_screen.dart';
import '../../features/profile/presentation/screens/notifications_screen.dart';
import '../../features/profile/presentation/screens/help_screen.dart';
import '../../features/profile/presentation/screens/favorites_screen.dart';
import '../../features/bookings/presentation/screens/my_bookings_screen.dart';
import 'dependency_injection.dart';

/// App router configuration
class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/login',
    redirect: (context, state) {
      final authProvider = DependencyInjection.authProvider;
      final isAuthenticated = authProvider.isAuthenticated;
      final isGoingToLogin = state.matchedLocation == '/login';
      final isGoingToRegister = state.matchedLocation == '/register';

      // If not authenticated and not going to auth pages, redirect to login
      if (!isAuthenticated && !isGoingToLogin && !isGoingToRegister) {
        return '/login';
      }

      // If authenticated and going to auth pages, redirect to home
      if (isAuthenticated && (isGoingToLogin || isGoingToRegister)) {
        return '/';
      }

      return null;
    },
    routes: [
      // Auth routes
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        name: 'register',
        builder: (context, state) => const RegisterScreen(),
      ),

      // Main screen (home with bottom navigation)
      GoRoute(
        path: '/',
        name: 'main',
        builder: (context, state) => const MainScreen(),
      ),

      // Restaurant details
      GoRoute(
        path: '/restaurant/:id',
        name: 'restaurant-details',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return RestaurantDetailsScreen(restaurantId: id);
        },
      ),

      // Booking route
      GoRoute(
        path: '/booking/:restaurantId',
        name: 'booking',
        builder: (context, state) {
          final restaurantId = state.pathParameters['restaurantId']!;
          return BookingScreen(restaurantId: restaurantId);
        },
      ),

      // Edit profile route
      GoRoute(
        path: '/edit-profile',
        name: 'edit-profile',
        builder: (context, state) => const EditProfileScreen(),
      ),

      // Notifications route
      GoRoute(
        path: '/notifications',
        name: 'notifications',
        builder: (context, state) => const NotificationsScreen(),
      ),

      // Help route
      GoRoute(
        path: '/help',
        name: 'help',
        builder: (context, state) => const HelpScreen(),
      ),

      // Favorites route (standalone page)
      GoRoute(
        path: '/favorites',
        name: 'favorites',
        builder: (context, state) => const FavoritesScreen(),
      ),

      // My Bookings route (standalone page)
      GoRoute(
        path: '/bookings',
        name: 'bookings',
        builder: (context, state) => const MyBookingsScreen(),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64),
            const SizedBox(height: 16),
            Text('Page not found: ${state.uri}'),
          ],
        ),
      ),
    ),
  );
}
