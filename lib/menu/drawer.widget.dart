import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyDrawer extends StatefulWidget {
  const MyDrawer({super.key});

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  File? img;
  final ImagePicker p = ImagePicker();

  Future<void> _pickImage() async {
    final XFile? image = await p.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        img = File(image.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.deepPurple.shade900,
        ),
        child: Column(
          children: [
            // --- En-tête du Drawer ---
            Container(
              height: 250,
              alignment: Alignment.center,
              child: GestureDetector(
                onTap: _pickImage,
                child: CircleAvatar(
                  radius: 60,
                  backgroundColor: Colors.white24,
                  backgroundImage: img != null ? FileImage(img!) : null,
                  child: img == null
                      ? const Text(
                          'Choisir photo',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white70, fontSize: 14),
                        )
                      : null,
                ),
              ),
            ),

            // --- Liste des Options ---
            ListTile(
              leading: const Icon(Icons.home, color: Colors.white),
              title: const Text('Accueil', style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings, color: Colors.white),
              title: const Text('Paramètres', style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            const Divider(color: Colors.white24),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.white),
              title: const Text('Déconnexion', style: TextStyle(color: Colors.white)),
              onTap: () async {
                final SharedPreferences prefs = await SharedPreferences.getInstance();
                await prefs.setBool("connect", false);
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/authentification',
                      (route) => false,
                );              },
            ),
          ],
        ),
      ),
    );
  }
}
