import 'package:flutter/material.dart';
import 'package:mini_projet/main.dart'; // To access themeNotifier
import '../menu/drawer.widget.dart';

class ParametrePage extends StatelessWidget {
  const ParametrePage({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isDark = themeNotifier.value;
    final theme = Theme.of(context);

    return Scaffold(
      drawer: const MyDrawer(),
      appBar: AppBar(
        title: const Text(
          "PARAMÈTRES",
          style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.2),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "APPARENCE",
              style: TextStyle(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 20),
            
            // Edit Option Box for Theme
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: theme.colorScheme.primary.withOpacity(0.2)),
              ),
              child: Column(
                children: [
                  _buildThemeOption(
                    context,
                    title: "Mode Sombre (Défaut)",
                    subtitle: "Noir & Citron Vert",
                    isSelected: isDark,
                    onTap: () => themeNotifier.toggleTheme(true),
                    accentColor: const Color(0xFFC6FF00),
                    previewBg: const Color(0xFF121212),
                  ),
                  const Divider(height: 30),
                  _buildThemeOption(
                    context,
                    title: "Mode Clair",
                    subtitle: "Crème & Jaune",
                    isSelected: !isDark,
                    onTap: () => themeNotifier.toggleTheme(false),
                    accentColor: const Color(0xFFFFD700),
                    previewBg: const Color(0xFFFFFDD0),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildThemeOption(
    BuildContext context, {
    required String title,
    required String subtitle,
    required bool isSelected,
    required VoidCallback onTap,
    required Color accentColor,
    required Color previewBg,
  }) {
    final theme = Theme.of(context);
    
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          // Preview Circle
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: previewBg,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.grey.withOpacity(0.3)),
            ),
            child: Center(
              child: Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  color: accentColor,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Text(
                  subtitle,
                  style: TextStyle(color: theme.textTheme.bodySmall?.color?.withOpacity(0.6), fontSize: 12),
                ),
              ],
            ),
          ),
          Radio<bool>(
            value: true,
            groupValue: isSelected,
            activeColor: theme.colorScheme.primary,
            onChanged: (_) => onTap(),
          ),
        ],
      ),
    );
  }
}
