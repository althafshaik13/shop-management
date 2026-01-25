import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/theme/app_theme.dart';
import 'core/api/api_client.dart';
import 'data/services/auth_service.dart';
import 'data/services/battery_service.dart';
import 'data/services/spare_part_service.dart';
import 'data/services/sale_service.dart';
import 'data/services/image_service.dart';
import 'presentation/providers/auth_provider.dart';
import 'presentation/providers/battery_provider.dart';
import 'presentation/providers/spare_part_provider.dart';
import 'presentation/providers/sale_provider.dart';
import 'presentation/screens/auth/login_screen.dart';
import 'presentation/screens/home/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize SharedPreferences
  final prefs = await SharedPreferences.getInstance();

  // Initialize API Client
  final apiClient = ApiClient(prefs);

  // Initialize Services
  final authService = AuthService(apiClient);
  final batteryService = BatteryService(apiClient);
  final sparePartService = SparePartService(apiClient);
  final saleService = SaleService(apiClient);
  final imageService = ImageService(apiClient);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthProvider(authService, prefs),
        ),
        ChangeNotifierProvider(
          create: (_) => BatteryProvider(batteryService, imageService),
        ),
        ChangeNotifierProvider(
          create: (_) => SparePartProvider(sparePartService, imageService),
        ),
        ChangeNotifierProvider(
          create: (_) => SaleProvider(saleService),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shop Management',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.light,
      home: Consumer<AuthProvider>(
        builder: (context, authProvider, child) {
          // Show loading while checking auth status
          if (authProvider.status == AuthStatus.initial) {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }

          // Navigate based on authentication status
          if (authProvider.isAuthenticated) {
            return const HomeScreen();
          } else {
            return const LoginScreen();
          }
        },
      ),
    );
  }
}
