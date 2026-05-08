import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../menu/drawer.widget.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;
    final surfaceColor = theme.colorScheme.surface;
    final darkBackground = theme.scaffoldBackgroundColor;
    final textColor = theme.colorScheme.onSurface;

    return Scaffold(
      backgroundColor: darkBackground,
      drawer: const MyDrawer(),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: surfaceColor,
        iconTheme: IconThemeData(color: primaryColor),
        title: Text(
          'My_Gym',
          style: TextStyle(
            color: primaryColor,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.2,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              if (context.mounted) {
                Navigator.of(context).pushNamedAndRemoveUntil('/authentification', (route) => false);
              }
            },
            icon: Icon(Icons.logout_rounded, color: primaryColor),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Header de Bienvenue ---
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(25),
              decoration: BoxDecoration(
                color: surfaceColor,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Bord table",
                      style: TextStyle(color: textColor.withOpacity(0.7), fontSize: 16)),
                  const SizedBox(height: 5),
                  Text(
                    "Pose analysis",
                    style: TextStyle(
                        color: primaryColor,
                        fontSize: 28,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            // --- Section des Modules ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "SELECT A MODE",
                    style: TextStyle(
                      color: textColor.withOpacity(0.5),
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                    ),
                  ),
                  const SizedBox(height: 20),

                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    mainAxisSpacing: 15,
                    crossAxisSpacing: 15,
                    childAspectRatio: 0.85,
                    children: [
                      _buildImageModule(
                        context,
                        "Training",
                        'images/gofit-gym-changi-technique-1.jpg',
                        '/pose_camera',
                        surfaceColor,
                        primaryColor,
                        textColor,
                      ),
                      _buildImageModule(
                        context,
                        "Calories",
                        'images/food.jpg', // You might want to use a food image later
                        '/food_scanner',
                        surfaceColor,
                        primaryColor,
                        textColor,
                      ),
                      _buildImageModule(
                        context,
                        "Historic",
                        'images/I-love-gym-M.jpg',
                        '/historique',
                        surfaceColor,
                        primaryColor,
                        textColor,
                      ),
                    ],
                  ),

                  const SizedBox(height: 25),

                  _buildStatusCard(surfaceColor, primaryColor, textColor),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageModule(
    BuildContext context, 
    String title, 
    String imagePath, 
    String route,
    Color surfaceColor,
    Color primaryColor,
    Color textColor,
  ) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, route),
      child: Container(
        decoration: BoxDecoration(
          color: surfaceColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: textColor.withOpacity(0.05)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 5),
            )
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Column(
            children: [
              Expanded(
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  errorBuilder: (context, error, stackTrace) =>
                      Icon(Icons.image_not_supported, color: primaryColor),
                ),
              ),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 12),
                color: surfaceColor,
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: textColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusCard(Color surfaceColor, Color primaryColor, Color textColor) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: primaryColor.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(Icons.bolt, color: primaryColor, size: 30),
          const SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Active AI Engine",
                  style: TextStyle(color: textColor, fontWeight: FontWeight.bold)),
              Text("Pose Detection v2.0",
                  style: TextStyle(color: textColor.withOpacity(0.5), fontSize: 12)),
            ],
          ),
        ],
      ),
    );
  }
}
