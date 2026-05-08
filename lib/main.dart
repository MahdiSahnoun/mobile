import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:mini_projet/Page/authentification.page.dart';
import 'package:mini_projet/Page/home.page.dart';
import 'package:mini_projet/Page/inscription.page.dart';
import 'package:mini_projet/Page/screens/pose_camera_screen.dart';
import 'package:mini_projet/Page/historique.page.dart';
import 'package:mini_projet/Page/parametre.page.dart';
import 'package:mini_projet/Page/servives/theme_service.dart';
import 'package:mini_projet/Page/food_scanner.page.dart';

// Global notifier for theme
final themeNotifier = ThemeNotifier(true);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final isDark = await ThemeService().getTheme();
  themeNotifier.value = isDark;
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: themeNotifier,
      builder: (context, isDark, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: isDark ? _darkTheme : _lightTheme,
          home: StreamBuilder<User?>(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Scaffold(body: Center(child: CircularProgressIndicator()));
              }
              if (snapshot.hasData) {
                return const HomePage();
              }
              return const AuthentificationPage();
            },
          ),
          routes: {
            '/home': (context) => const HomePage(),
            '/inscription': (context) => const InscriptionPage(),
            '/authentification': (context) => const AuthentificationPage(),
            '/pose_camera': (context) => const PoseCameraScreen(),
            '/historique': (context) => const HistoriquePage(),
            '/parametres': (context) => const ParametrePage(),
            '/food_scanner': (context) => const FoodScannerPage(),
          },
        );
      },
    );
  }

  static final ThemeData _darkTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: const Color(0xFF121212),
    primaryColor: const Color(0xFFC6FF00),
    colorScheme: const ColorScheme.dark(
      primary: Color(0xFFC6FF00),
      surface: Color(0xFF1E1E1E),
      onSurface: Colors.white,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF1E1E1E),
      foregroundColor: Color(0xFFC6FF00),
    ),
  );

  static final ThemeData _lightTheme = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: const Color(0xFFF8F9FA), // Soft Light Gray
    primaryColor: const Color(0xFFFFD700), // Yellow
    colorScheme: const ColorScheme.light(
      primary: Color(0xFFFFD700),
      secondary: Color(0xFFFFD700),
      surface: Colors.white,
      onSurface: Color(0xFF1C1C1E),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      foregroundColor: Color(0xFFFFD700),
      elevation: 0,
    ),
  );
}
