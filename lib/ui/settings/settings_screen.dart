import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:ionicons/ionicons.dart';
import 'package:image_picker/image_picker.dart';

import '../../providers/theme_provider.dart';
import '../../providers/user/auth_provider.dart';
import '../../providers/user/data_provider.dart';

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

  final Map<String, String> genders = {
    'male': 'Homme',
    'female': 'Femme',
    'other': 'Non-binaire',
  };
  File? _image;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      setState(() {
        _image = File(pickedImage.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final userAuthProvider = Provider.of<UserAuthProvider>(context);
    final userDataProvider = Provider.of<UserDataProvider>(context);

    Widget contentWidget = Container();
    if (userAuthProvider.user?.emailVerified == false) {
      contentWidget = Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          color: Theme.of(context).colorScheme.error,
          padding: const EdgeInsets.all(8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
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
            tooltip: 'Plus',
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Ionicons.ellipsis_vertical_outline),
            tooltip: 'Feedback',
            onPressed: () => showLicensePage(
              context: context,
              applicationName: 'Morpheus',
              applicationVersion: '1.0.0',
              applicationLegalese: '© 2023 Morpheus',
            ),
          ),
        ],
      ),
      body: ListView(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.all(8),
            child: contentWidget,
          ),
          // Profile Section
          ListTile(
            subtitle: Row(
              children: <Widget>[
                GestureDetector(
                  onTap: _pickImage,
                  child: CircleAvatar(
                    radius: 40,
                    backgroundImage: _image != null ? FileImage(_image!) : null,
                    child: _image == null
                        ? const Icon(
                            Ionicons.phone_portrait_outline,
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
          const ListTile(
            title: Text('Paramètres de l\'application'),
          ),
          ListTile(
            leading: const Icon(Ionicons.medical_outline),
            title: const Text('Gestion des données'),
            trailing: const Icon(Ionicons.chevron_forward_outline),
            onTap: () => context.pushNamed('data'),
          ),
          ListTile(
            leading: const Icon(Ionicons.color_palette_outline),
            title: const Text('Thème de l\'application'),
            trailing: const Icon(Ionicons.chevron_forward_outline),
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
            leading: const Icon(Ionicons.language_outline),
            title: const Text('Langue'),
            trailing: const Icon(Ionicons.chevron_forward_outline),
            onTap: () => context.pushNamed('data'),
          ),
          const ListTile(
            title: Text('Paramètres du compte'),
          ),
          ListTile(
            leading: const Icon(Ionicons.camera_outline),
            title: const Text('Photo de profil'),
            trailing: const Icon(Ionicons.chevron_forward_outline),
            onTap: () => _pickImage,
          ),
          ListTile(
            leading: const Icon(Ionicons.person_outline),
            title: const Text('Nom'),
            subtitle: Text(userAuthProvider.user!.name),
            trailing: const Icon(Ionicons.chevron_forward_outline),
            onTap: () => context.goNamed('name'),
          ),
          ListTile(
            leading: const Icon(Ionicons.mail_outline),
            title: const Text('Adresse mail'),
            subtitle: Text(userAuthProvider.user!.email),
            trailing: const Icon(Ionicons.chevron_forward_outline),
            onTap: () => context.goNamed('email'),
          ),
          ListTile(
            leading: const Icon(Ionicons.calendar_outline),
            title: const Text('Date de naissance'),
            subtitle: Text(DateFormat('dd/MM/yyyy')
                .format(userAuthProvider.user!.birthDate)),
            trailing: const Icon(Ionicons.chevron_forward_outline),
            onTap: () => context.go('/settings/profile/birthdate'),
          ),
          ListTile(
            leading: const Icon(Ionicons.male_female_outline),
            title: const Text('Genre'),
            subtitle: Text(genders[userAuthProvider.user!.gender]!),
            trailing: const Icon(Ionicons.chevron_forward_outline),
            onTap: () => context.go('/settings/profile/gender'),
          ),
          ListTile(
            leading: const Icon(Ionicons.lock_closed_outline),
            title: const Text('Mot de passe'),
            trailing: const Icon(Ionicons.chevron_forward_outline),
            onTap: () => context.pushNamed('password'),
          ),
          ListTile(
            leading: const Icon(Ionicons.log_out_outline),
            title: const Text('Me déconnecter'),
            trailing: const Icon(Ionicons.chevron_forward_outline),
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
          ListTile(
            leading: const Icon(Ionicons.trash_bin_outline),
            title: const Text('Supprimer mon compte'),
            trailing: const Icon(Ionicons.chevron_forward_outline),
            onTap: () => showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Supprimer mon compte'),
                content: const Text(
                    'Êtes-vous sûr de vouloir supprimer votre compte ? Toutes vos données seront supprimées. Cette action est défintive.'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Annuler'),
                  ),
                  TextButton(
                    onPressed: () async {
                      await userDataProvider.deleteUser();
                      if (context.mounted) context.goNamed('auth');
                    },
                    child: const Text('Supprimer'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
