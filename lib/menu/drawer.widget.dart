import 'dart:convert';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyDrawer extends StatefulWidget {
  const MyDrawer({super.key});

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  final ImagePicker p = ImagePicker();
  String userEmail = "";
  String userUid = "default";
  String? _profileImageBase64;
  late Future<void> _initFuture;

  @override
  void initState() {
    super.initState();
    _initFuture = _loadData();
  }

  Future<void> _loadData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      userEmail = user.email ?? "Utilisateur";
      userUid = user.uid;
    }

    final prefs = await SharedPreferences.getInstance();
    _profileImageBase64 = prefs.getString('profile_image_$userUid');
  }

  Future<void> _pickImage() async {
    try {
      final XFile? pickedFile = await p.pickImage(
        source: ImageSource.gallery,
        imageQuality: 50,
      );

      if (pickedFile != null) {
        final bytes = await File(pickedFile.path).readAsBytes();
        final String base64Image = base64Encode(bytes);

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('profile_image_$userUid', base64Image);

        setState(() {
          _profileImageBase64 = base64Image;
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Photo sauvegardée !')),
          );
        }
      }
    } catch (e) {
      debugPrint("Erreur sauvegarde: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryAccent = theme.colorScheme.primary;
    final darkBackground = theme.scaffoldBackgroundColor;
    final surfaceColor = theme.colorScheme.surface;

    return FutureBuilder<void>(
      future: _initFuture,
      builder: (context, snapshot) {
        final imageBytes = _profileImageBase64 != null
            ? base64Decode(_profileImageBase64!)
            : null;

        return Drawer(
          child: Container(
            color: darkBackground,
            child: Column(
              children: [
                UserAccountsDrawerHeader(
                  decoration: BoxDecoration(color: surfaceColor),
                  currentAccountPicture: GestureDetector(
                    onTap: _pickImage,
                    child: CircleAvatar(
                      key: ValueKey(_profileImageBase64 ?? 'none'),
                      backgroundColor: darkBackground,
                      backgroundImage: imageBytes != null
                          ? MemoryImage(imageBytes)
                          : null,
                      child: imageBytes == null
                          ? Icon(Icons.camera_alt, color: primaryAccent, size: 30)
                          : null,
                    ),
                  ),
                  accountName: const Text(
                    "Username",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  accountEmail: Text(
                    userEmail,
                    style: TextStyle(
                        color: theme.colorScheme.onSurface.withOpacity(0.7)),
                  ),
                ),
                const SizedBox(height: 10),
                _buildDrawerItem(
                  icon: Icons.home_rounded,
                  title: 'Home',
                  onTap: () => Navigator.popAndPushNamed(context, '/home'),
                  accentColor: primaryAccent,
                  textColor: theme.colorScheme.onSurface,
                ),
                _buildDrawerItem(
                  icon: Icons.fitness_center_rounded,
                  title: 'Training',
                  onTap: () => Navigator.popAndPushNamed(context, '/pose_camera'),
                  accentColor: primaryAccent,
                  textColor: theme.colorScheme.onSurface,
                ),
                _buildDrawerItem(
                  icon: Icons.fastfood_rounded,
                  title: 'Calories',
                  onTap: () => Navigator.popAndPushNamed(context, '/food_scanner'),
                  accentColor: primaryAccent,
                  textColor: theme.colorScheme.onSurface,
                ),
                _buildDrawerItem(
                  icon: Icons.history_rounded,
                  title: 'Historic',                  onTap: () => Navigator.popAndPushNamed(context, '/historique'),
                  accentColor: primaryAccent,
                  textColor: theme.colorScheme.onSurface,
                ),
                _buildDrawerItem(
                  icon: Icons.settings_rounded,
                  title: 'Settings',
                  onTap: () => Navigator.popAndPushNamed(context, '/parametres'),
                  accentColor: primaryAccent,
                  textColor: theme.colorScheme.onSurface,
                ),
                _buildDrawerItem(
                  icon: Icons.logout_rounded,
                  title: 'Disconnect',
                  onTap: () async {
                    await FirebaseAuth.instance.signOut();
                    if (!mounted) return;
                    Navigator.of(context).pushNamedAndRemoveUntil(
                        '/authentification', (route) => false);
                  },
                  accentColor: primaryAccent,
                  textColor: theme.colorScheme.onSurface,
                ),
                const Spacer(),
                const Divider(color: Colors.white10, thickness: 1),
                const SizedBox(height: 20),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color accentColor = Colors.white,
    Color textColor = Colors.white,
  }) {
    return ListTile(
      leading: Icon(icon,
          color: accentColor == Colors.white ? textColor : accentColor),
      title: Text(
        title,
        style: TextStyle(
            color: textColor, fontSize: 16, fontWeight: FontWeight.w500),
      ),
      onTap: onTap,
      hoverColor: Colors.white10,
    );
  }
}