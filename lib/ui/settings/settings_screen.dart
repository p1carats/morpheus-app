import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
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

    return Scaffold(
      appBar: AppBar(
        title: const Text('Réglages'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Ionicons.help_circle_outline),
            tooltip: 'Feedback',
            onPressed: () {
              final Uri emailLaunchUri = Uri(
                scheme: 'mailto',
                path: 'morpheus@uphoria.tech',
                queryParameters: {'subject': 'Feedback sur Morpheus'},
              );
              launchUrl(emailLaunchUri);
            },
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
          const SizedBox(height: 10),
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
          const SizedBox(height: 5),
          Consumer<UserProvider>(
            builder: (context, provider, child) {
              if (provider.user?.emailVerified == false) {
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Card(
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(16)),
                    ),
                    child: Center(
                      child: Container(
                        padding: const EdgeInsets.fromLTRB(8, 12, 8, 2),
                        //height: 200,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            const Text(
                              'Adresse mail non vérifiée !',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 10),
                            const Text(
                              'Veuillez vérifier votre adresse e-mail pour continuer à utiliser Morpheus.',
                              style: TextStyle(
                                fontSize: 14,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            TextButton(
                              onPressed: () async {
                                try {
                                  await userProvider.sendEmailVerification();
                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        backgroundColor: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                        content: const Text(
                                          'Un nouvel email de vérification vous a été envoyé. Pensez à vérifier vos spams !',
                                        ),
                                      ),
                                    );
                                  }
                                } catch (err) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      backgroundColor:
                                          Theme.of(context).colorScheme.error,
                                      content: Text(err.toString()),
                                    ),
                                  );
                                }
                              },
                              child: const Text(
                                'Renvoyer l\'email de confirmation',
                                //style: TextStyle(fontSize: 16),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              } else {
                return const SizedBox.shrink();
              }
            },
          ),
          ListTile(
            title: Text(
              'Paramètres de l\'application',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
          ListTile(
            leading: const Icon(Ionicons.medical_outline),
            title: const Text('Gestion du sommeil'),
            trailing: const Icon(Ionicons.chevron_forward_outline),
            onTap: () => context.pushNamed('settingsdata'),
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
                          onChanged: (ThemeType? value) async {
                            if (value != null) {
                              appProvider.updateThemeType(value);
                              await Future.delayed(
                                  const Duration(milliseconds: 150));
                              if (context.mounted) {
                                Navigator.of(context).pop();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                        'Thème ${themeTypeNames[value]!.toLowerCase()} appliqué !'),
                                    backgroundColor:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                                );
                              }
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
            title: Text(
              'Paramètres du compte',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
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
                          context.pop();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text(
                                  'Une erreur est srvenue. Merci de vérifier votre mot de passe.'),
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
