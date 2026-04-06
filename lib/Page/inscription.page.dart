import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InscriptionPage extends StatefulWidget {
  const InscriptionPage({super.key});

  @override
  State<InscriptionPage> createState() => _InscriptionPageState();
}

class _InscriptionPageState extends State<InscriptionPage> {
  final TextEditingController txtLogin = TextEditingController();
  final TextEditingController txtPassword = TextEditingController();

  // --- les couleurs  ---
  final Color primaryBrown = const Color(0xFF4E342E);
  final Color accentBrown = const Color(0xFF8D6E63);
  final Color lightBeige = const Color(0xFFF5F5DC);
  final Color cardColor = const Color(0xFFFFFBF0);

  @override
  void dispose() {
    txtLogin.dispose();
    txtPassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // --- Bcakground de la page---
      backgroundColor: lightBeige,
      body: SingleChildScrollView( // Added scroll to prevent overflow with keyboard
        child: Column(
          children: [
            // --- ADDED: Decorative Header Section ---
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
                mainAxisAlignment: MainAxisAlignment.center,//pour centrer
                children: [
                  Icon(Icons.add_home, size: 80, color: Colors.white70), // Theme Icon
                  SizedBox(height: 10),
                  Text(
                    "Créer un Compte",
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

            // --- UI Container for Inputs ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Column(
                children: [
                  // Champ d'utilisateur
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    child: TextFormField(
                      controller: txtLogin,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        prefixIcon: Icon(Icons.person, color: accentBrown),
                        hintText: "Utilisateur",
                        // --- UPDATED: Brown Themed Borders ---
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

                  // Champ mot de passe
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

                  // Bouton inscription
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        backgroundColor: primaryBrown, // Brown Button
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        elevation: 5,
                      ),
                      onPressed: () => _onInscrire(context),
                      child: const Text(
                        "S'inscrire",
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                  ),

                  const SizedBox(height: 15),

                  // Lien hypertexte
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/authentification');
                    },
                    child: Text(
                      "J'ai déjà un compte",
                      style: TextStyle(
                        fontSize: 16.0,
                        color: accentBrown, // Subtle brown link
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

  Future<void> _onInscrire(BuildContext context) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (txtLogin.text.isNotEmpty && txtPassword.text.isNotEmpty) {
      prefs.setString("login", txtLogin.text);
      prefs.setString("password", txtPassword.text);
      prefs.setBool("connect", true);
      Navigator.pushNamed(context, '/home');
    } else {
      // --- UPDATED: Snackbar color to match theme ---
      final snackBar = SnackBar(
        backgroundColor: accentBrown,
        content: const Text('Veuillez remplir tous les champs'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }
}