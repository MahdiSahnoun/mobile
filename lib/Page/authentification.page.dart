import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthentificationPage extends StatefulWidget {
  const AuthentificationPage({super.key});

  @override
  State<AuthentificationPage> createState() => _AuthentificationPageState();
}

class _AuthentificationPageState extends State<AuthentificationPage> {
  final TextEditingController txtLogin = TextEditingController();
  final TextEditingController txtPassword = TextEditingController();
  bool _isLoading = false;

  // --- Nouvelle Palette : Dark & Lime ---
  final Color darkBackground = const Color(0xFF121212); // Gris Anthracite
  final Color surfaceColor = const Color(0xFF1E1E1E);    // Gris un peu plus clair pour les cartes
  final Color limeAccent = const Color(0xFFC6FF00);      // Vert Lime vibrant
  final Color textSecondary = const Color(0xFFB0B0B0);  // Gris clair pour le texte secondaire

  @override
  void dispose() {
    txtLogin.dispose();
    txtPassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darkBackground,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header avec Logo Moderne
            Container(
              height: MediaQuery.of(context).size.height * 0.35,
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [surfaceColor, darkBackground],
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo stylisé
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: limeAccent.withOpacity(0.1),
                      shape: BoxShape.circle,
                      border: Border.all(color: limeAccent, width: 2),
                    ),
                    child: Icon(Icons.bolt, size: 60, color: limeAccent),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "BIENVENUE",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 2,
                    ),
                  ),
                  Text(
                    "Connectez-vous pour continuer",
                    style: TextStyle(color: textSecondary, fontSize: 14),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                children: [
                  // Champ Login
                  _buildTextField(
                    controller: txtLogin,
                    hint: "Identifiant (Email)",
                    icon: Icons.email,
                  ),
                  const SizedBox(height: 20),

                  // Champ Password
                  _buildTextField(
                    controller: txtPassword,
                    hint: "Mot de passe",
                    icon: Icons.lock,
                    isPassword: true,
                  ),

                  const SizedBox(height: 30),

                  // Bouton de Connexion
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: limeAccent,
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      onPressed: _isLoading ? null : () => _onAuthentifier(context),
                      child: _isLoading
                          ? const CircularProgressIndicator(color: Colors.black)
                          : const Text(
                              "SE CONNECTER",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),

                  const SizedBox(height: 25),

                  // Inscription
                  Wrap(
                    alignment: WrapAlignment.center,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Text("Pas encore de compte ?",
                          style: TextStyle(color: textSecondary)),
                      TextButton(
                        onPressed: () => Navigator.pushNamed(context, '/inscription'),
                        child: Text(
                          "S'inscrire",
                          style: TextStyle(
                            color: limeAccent,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget réutilisable pour les champs de texte
  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool isPassword = false,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        filled: true,
        fillColor: surfaceColor,
        hintText: hint,
        hintStyle: TextStyle(color: textSecondary),
        prefixIcon: Icon(icon, color: limeAccent, size: 20),
        contentPadding: const EdgeInsets.symmetric(vertical: 18),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.05)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: limeAccent.withOpacity(0.5)),
        ),
      ),
    );
  }

  Future<void> _onAuthentifier(BuildContext context) async {
    if (txtLogin.text.isEmpty || txtPassword.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez remplir tous les champs')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: txtLogin.text.trim(),
        password: txtPassword.text.trim(),
      );
      
      if (mounted) {
        // Redirection explicite vers Home en vidant la pile de navigation
        Navigator.of(context).pushNamedAndRemoveUntil('/home', (route) => false);
      }
    } on FirebaseAuthException catch (e) {
      String message = "Erreur d'authentification";
      if (e.code == 'user-not-found') {
        message = "Utilisateur non trouvé";
      } else if (e.code == 'wrong-password') {
        message = "Mot de passe incorrect";
      } else if (e.code == 'invalid-email') {
        message = "Email invalide";
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.redAccent,
          content: Text(message),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}