import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import '../menu/drawer.widget.dart'; // Assurez-vous que le chemin est correct

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  // --- AJOUTÉ : Palette de couleurs cohérente ---
  final Color primaryBrown = const Color(0xFF4E342E);
  final Color accentBrown = const Color(0xFF8D6E63);
  final Color lightBeige = const Color(0xFFF5F5DC);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // --- MODIFIÉ : Fond de page beige ---
      backgroundColor: lightBeige,
      appBar: AppBar(
        elevation: 0,
        title: const Text('Vision TGL', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: primaryBrown,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            onPressed: () async {
              final SharedPreferences prefs = await SharedPreferences.getInstance();
              await prefs.setBool("connect", false);
              if (context.mounted) {
                Navigator.pushReplacementNamed(context, '/authentification');
              }
            },
            icon: const Icon(Icons.logout),
          )
        ],
      ),
      // drawer: const MyDrawer(), // Votre tiroir de navigation
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- AJOUTÉ : Section de Bienvenue ---
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(25),
              decoration: BoxDecoration(
                color: primaryBrown,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(40),
                  bottomRight: Radius.circular(40),
                ),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Bonjour,", style: TextStyle(color: Colors.white70, fontSize: 18)),
                  SizedBox(height: 5),
                  Text(
                    "Prêt pour une détection ?",
                    style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // --- AJOUTÉ : Grille d'actions pour la Computer Vision ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Outils de Vision",
                    style: TextStyle(color: primaryBrown, fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),

                  // Carte pour la Caméra
                  _buildVisionCard(
                    context,
                    title: "Scanner en Temps Réel",
                    subtitle: "Utiliser la caméra live",
                    icon: Icons.camera_alt,
                    color: Colors.white,
                  ),

                  const SizedBox(height: 15),

                  // Carte pour la Galerie
                  _buildVisionCard(
                    context,
                    title: "Analyser une Image",
                    subtitle: "Importer depuis la galerie",
                    icon: Icons.photo_library,
                    color: Colors.white,
                  ),

                  const SizedBox(height: 30),

                  // --- AJOUTÉ : Section Historique/Résultats récents ---
                  Text(
                    "Dernières Analyses",
                    style: TextStyle(color: primaryBrown, fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    height: 100,
                    decoration: BoxDecoration(
                      color: accentBrown.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: accentBrown.withOpacity(0.2)),
                    ),
                    child: const Center(
                      child: Text("Aucune analyse récente", style: TextStyle(color: Colors.grey)),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- Widget Helper pour les cartes de détection ---
  Widget _buildVisionCard(BuildContext context,
      {required String title, required String subtitle, required IconData icon, required Color color}) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          )
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        leading: CircleAvatar(
          backgroundColor: lightBeige,
          child: Icon(icon, color: primaryBrown),
        ),
        title: Text(title, style: TextStyle(fontWeight: FontWeight.bold, color: primaryBrown)),
        subtitle: Text(subtitle, style: const TextStyle(color: Colors.grey)),
        trailing: Icon(Icons.arrow_forward_ios, size: 16, color: accentBrown),
        onTap: () {
          // Logique pour ouvrir la caméra ou galerie ici
        },
      ),
    );
  }
}