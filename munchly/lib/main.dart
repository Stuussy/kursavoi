import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/config/dependency_injection.dart';
import 'core/config/router.dart';
import 'core/theme/app_theme.dart';
import 'core/constants/app_constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize dependencies
  await DependencyInjection.init();

  // Initialize auth provider
  await DependencyInjection.authProvider.init();

  runApp(const MunchlyApp());
}

/// Main application widget
class MunchlyApp extends StatelessWidget {
  const MunchlyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: DependencyInjection.authProvider,
        ),
        ChangeNotifierProvider.value(
          value: DependencyInjection.favoritesProvider,
        ),
        ChangeNotifierProvider.value(
          value: DependencyInjection.adminProvider,
        ),
        ChangeNotifierProvider.value(
          value: DependencyInjection.bookingsProvider,
        ),
      ],
      child: MaterialApp.router(
        title: AppConstants.appName,
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        routerConfig: AppRouter.router,
      ),
    );
  }
}
