import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:ionicons/ionicons.dart';
import 'package:image_picker/image_picker.dart';

import '../../providers/theme_provider.dart';
import '../../providers/user/auth_provider.dart';

class SettingsMainScreen extends StatefulWidget {
  const SettingsMainScreen({Key? key}) : super(key: key);

  @override
  State<SettingsMainScreen> createState() => _SettingsMainScreenState();
}

class _SettingsMainScreenState extends State<SettingsMainScreen> {
  final Map<ThemeType, String> themeTypeNames = {
    ThemeType.light: 'Clair',
    ThemeType.dark: 'Sombre',
    ThemeType.system: 'Système (par défaut)',
  };
  File? _image;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.getImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      setState(() {
        _image = File(pickedImage.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final userAuthProvider = Provider.of<UserAuthProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);

    Widget contentWidget = Container();
    if (userAuthProvider.user?.emailVerified == false) {
      contentWidget = Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          color: Theme.of(context).colorScheme.error,
          padding: const EdgeInsets.all(8),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Ionicons.warning_outline),
              SizedBox(width: 8),
              Text('Adresse mail non vérifiée !'),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Réglages'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Ionicons.help_circle_outline),
            tooltip: 'Feedback',
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Ionicons.ellipsis_vertical_outline),
            tooltip: 'Plus',
            onPressed: () {},
          ),
        ],
      ),
      body: ListView(
        children: <Widget>[
          contentWidget,
          // Profile Section
          ListTile(
            subtitle: Row(
              children: <Widget>[
                // Avatar who can be modified to support user profile images
                GestureDetector(
                  onTap: _pickImage,
                  child: CircleAvatar(
                    radius: 40,
                    backgroundImage: _image != null ? FileImage(_image!) : null,
                    child: _image == null
                        ? const Icon(
                            Icons.add_a_photo_outlined,
                            size: 40,
                          )
                        : null,
                  ),
                ),
                const SizedBox(width: 15),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      userAuthProvider.user!.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                        'Membre depuis le ${DateFormat('dd/MM/yyyy').format(userAuthProvider.user!.creationTime)}'),
                  ],
                ),
              ],
            ),
          ),
          const Divider(),
          // App Settings Section
          ListTile(
            leading: const Icon(Ionicons.person_outline),
            title: const Text('Gestion du profil'),
            onTap: () => context.pushNamed('profile'),
          ),
          ListTile(
            leading: const Icon(Ionicons.medical_outline),
            title: const Text('Gestion des données'),
            onTap: () => context.pushNamed('data'),
          ),
          ListTile(
            leading: const Icon(Ionicons.color_palette_outline),
            title: const Text('Thème de l\'application'),
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Sélection du thème'),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: ThemeType.values.map((ThemeType themeType) {
                        return RadioListTile<ThemeType>(
                          title: Text(themeTypeNames[themeType]!),
                          value: themeType,
                          groupValue: themeProvider.themeType,
                          onChanged: (ThemeType? value) {
                            if (value != null) {
                              themeProvider.updateThemeType(value);
                              Navigator.of(context).pop();
                            }
                          },
                        );
                      }).toList(),
                    ),
                  );
                },
              );
            },
          ),
          ListTile(
            leading: const Icon(Ionicons.log_out_outline),
            title: const Text('Me déconnecter'),
            onTap: () async {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Déconnexion'),
                  content:
                      const Text('Êtes-vous sûr de vouloir vous déconnecter ?'),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Annuler'),
                    ),
                    TextButton(
                      onPressed: () async {
                        await userAuthProvider.signOut();
                        if (context.mounted) context.goNamed('auth');
                      },
                      child: const Text('Déconnexion'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
