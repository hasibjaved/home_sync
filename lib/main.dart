import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:home_sync/views/signup.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'core/supabase.dart';
import 'controllers/auth.dart';
import 'controllers/roommate.dart';
import 'controllers/task.dart';
import 'controllers/health.dart';
import 'views/login.dart';
import 'views/admin.dart';
import 'views/roommate.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supa.init();
  final prefs = await SharedPreferences.getInstance();
  final useSystem = prefs.getBool('use_system_theme') ?? true;

  Get.put(AuthCtrl());
  Get.put(RoommateCtrl());
  Get.put(TaskCtrl());
  Get.put(HealthCtrl());

  runApp(App(useSystem: useSystem));
}

class App extends StatelessWidget {
  final bool useSystem;
  const App({required this.useSystem, super.key});

  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(builder: (light, dark) {
      return GetMaterialApp(
        title: 'Roommate Tasks',
        theme: _buildTheme(light ?? _fallbackLight, Brightness.light),
        darkTheme: _buildTheme(dark ?? _fallbackDark, Brightness.dark),
        themeMode: useSystem ? ThemeMode.system : (Get.isDarkMode ? ThemeMode.dark : ThemeMode.light),
        initialRoute: '/login',
        getPages: [
          GetPage(name: '/login', page: () => LoginView()),
          GetPage(name: '/admin', page: () => AdminView()),
          GetPage(name: '/signup', page: () => SignupView()),
          GetPage(name: '/roommate', page: () => RoommateView()),
        ],
      );
    });
  }

  static final _fallbackLight = ColorScheme.fromSeed(seedColor: Colors.deepPurple);
  static final _fallbackDark = ColorScheme.fromSeed(seedColor: Colors.deepPurple, brightness: Brightness.dark);

  ThemeData _buildTheme(ColorScheme scheme, Brightness brightness) {
    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      typography: Typography.material2021(platform: TargetPlatform.android),
      scaffoldBackgroundColor: scheme.surface,
      cardTheme: CardThemeData(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      ),
      appBarTheme: AppBarTheme(
        elevation: 0,
        centerTitle: true,
        backgroundColor: scheme.surface,
        foregroundColor: scheme.onSurface,
        titleTextStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
      chipTheme: ChipThemeData(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        labelStyle: const TextStyle(fontSize: 11),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }
}