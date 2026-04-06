import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthentificationPage extends StatefulWidget {
  const AuthentificationPage({super.key});

  @override
  State<AuthentificationPage> createState() => _AuthentificationPageState();
}

class _AuthentificationPageState extends State<AuthentificationPage> {
  final TextEditingController txtLogin = TextEditingController();
  final TextEditingController txtPassword = TextEditingController();

  // --- AJOUTÉ : Palette de couleurs pour le style Brown ---
  final Color primaryBrown = const Color(0xFF4E342E); // Marron foncé
  final Color accentBrown = const Color(0xFF8D6E63);  // Marron moyen
  final Color lightBeige = const Color(0xFFF5F5DC);   // Fond crème

  @override
  void dispose() {
    txtLogin.dispose();
    txtPassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // --- MODIFIÉ : Couleur de fond ---
      backgroundColor: lightBeige,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // --- AJOUTÉ : En-tête décoratif avec design courbé ---
            Container(
              height: 250,
              width: double.infinity,
              decoration: BoxDecoration(
                color: primaryBrown,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(60),
                ),
              ),
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.login, size: 80, color: Colors.white70),
                  SizedBox(height: 10),
                  Text(
                    "Connexion",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Column(
                children: [
                  // Login
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    child: TextFormField(
                      controller: txtLogin,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        prefixIcon: Icon(Icons.person, color: accentBrown),
                        hintText: "Utilisateur",
                        // --- MODIFIÉ : Bordures arrondies et marron ---
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide.none,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(color: accentBrown.withOpacity(0.3)),
                        ),
                      ),
                    ),
                  ),

                  // Password
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    child: TextFormField(
                      controller: txtPassword,
                      obscureText: true,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        prefixIcon: Icon(Icons.lock, color: accentBrown),
                        hintText: "Mot de passe",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide.none,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(color: accentBrown.withOpacity(0.3)),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Bouton connexion
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        backgroundColor: primaryBrown, // Bouton Marron
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        elevation: 5,
                      ),
                      onPressed: () => _onAuthentifier(context),
                      child: const Text(
                        "S'authentifier",
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                  ),

                  const SizedBox(height: 15),

                  // Lien hypertexte
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/inscription');
                    },
                    child: Text(
                      "Nouvel utilisateur",
                      style: TextStyle(
                        fontSize: 16.0,
                        color: accentBrown, // Texte en marron moyen
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _onAuthentifier(BuildContext context) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? login = prefs.getString("login");
    String? mdp = prefs.getString("password");
    if (txtLogin.text == login && txtPassword.text == mdp) {
      prefs.setBool("connect", true);
      Navigator.pushNamed(context, '/home');
    } else {
      // --- MODIFIÉ : SnackBar stylisée ---
      final snackBar = SnackBar(
        backgroundColor: accentBrown,
        content: const Text('Utilisateur ou mot de passe incorrect'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }
}