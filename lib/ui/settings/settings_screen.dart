import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:ionicons/ionicons.dart';

import '../../providers/app_provider.dart';
import '../../providers/user_provider.dart';

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

  final Map<String, IconData> genders = {
    'male': Ionicons.male_outline,
    'female': Ionicons.female_outline,
    'other': Ionicons.male_female_outline,
  };

  @override
  Widget build(BuildContext context) {
    final appProvider = Provider.of<AppProvider>(context);
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    Widget contentWidget = Container();
    if (userProvider.user?.emailVerified == false) {
      contentWidget = Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          color: Theme.of(context).colorScheme.error,
          padding: const EdgeInsets.all(8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(
                Ionicons.warning_outline,
                color: Colors.black,
              ),
              SizedBox(width: 8),
              Text(
                'Adresse mail non vérifiée !',
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
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
                CircleAvatar(
                  radius: 40,
                  backgroundImage:
                      NetworkImage(userProvider.user!.profilePicture),
                ),
                const SizedBox(width: 15),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: [
                        Text(
                          userProvider.user!.name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 5),
                        Icon(
                          genders[userProvider.user!.gender]!,
                          color: Theme.of(context).colorScheme.secondary,
                          size: 16,
                        ),
                      ],
                    ),
                    Text(
                        'Membre depuis le ${DateFormat('dd/MM/yyyy').format(userProvider.user!.creationTime)}'),
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
                          groupValue: appProvider.themeType,
                          onChanged: (ThemeType? value) {
                            if (value != null) {
                              appProvider.updateThemeType(value);
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
            onTap: () {},
          ),
          const ListTile(
            title: Text('Paramètres du compte'),
          ),
          ListTile(
            leading: const Icon(Ionicons.person_outline),
            title: const Text('Mon profil'),
            trailing: const Icon(Ionicons.chevron_forward_outline),
            onTap: () => context.goNamed('profile'),
          ),
          ListTile(
            leading: const Icon(Ionicons.mail_outline),
            title: const Text('Adresse mail'),
            subtitle: Text(userProvider.user!.email),
            trailing: const Icon(Ionicons.chevron_forward_outline),
            onTap: () => context.goNamed('email'),
          ),
          ListTile(
            leading: const Icon(Ionicons.lock_closed_outline),
            title: const Text('Modifier mon mot de passe'),
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
                        await userProvider.signOut();
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
              builder: (context) {
                final passwordController = TextEditingController();
                return AlertDialog(
                  title: const Text('Supprimer mon compte'),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                          'Êtes-vous sûr de vouloir supprimer votre compte ? Toutes vos données seront supprimées. Cette action est irréversible.'),
                      const SizedBox(height: 15),
                      const Text(
                          'Merci de confirmer votre mot de passe pour continuer.'),
                      const SizedBox(height: 15),
                      TextField(
                        controller: passwordController,
                        obscureText: true,
                        decoration: const InputDecoration(
                          labelText: 'Mot de passe',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Ionicons.lock_closed_outline),
                        ),
                      ),
                    ],
                  ),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Annuler'),
                    ),
                    TextButton(
                      onPressed: () async {
                        try {
                          await userProvider
                              .deleteUser(passwordController.text);
                          if (context.mounted) context.goNamed('auth');
                        } catch (err) {
                          Navigator.of(context).pop();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(err.toString()),
                              backgroundColor:
                                  Theme.of(context).colorScheme.error,
                            ),
                          );
                        }
                      },
                      child: const Text('Supprimer'),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
