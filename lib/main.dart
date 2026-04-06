import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Page/authentification.page.dart';
import 'Page/home.page.dart';
import 'Page/inscription.page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final routes = {
      '/home': (context) => const HomePage(),
      '/inscription': (context) => InscriptionPage(),
      '/authentification': (context) => AuthentificationPage(),
    };

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FutureBuilder(
        future: SharedPreferences.getInstance(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(body: Center(child: CircularProgressIndicator()));
          }
          bool con = snapshot.data?.getBool("connect") ?? false;
          if (con) return const HomePage();
          return InscriptionPage();
        },
      ),
      routes: routes,
    );
  }
}
