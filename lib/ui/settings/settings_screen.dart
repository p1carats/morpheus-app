import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';

import '../../providers/user_auth_provider.dart';
import '../../providers/user_data_provider.dart';

class SettingsMainScreen extends StatefulWidget {
  const SettingsMainScreen({Key? key}) : super(key: key);

  @override
  State<SettingsMainScreen> createState() => _SettingsMainScreenState();
}

class _SettingsMainScreenState extends State<SettingsMainScreen> {
  @override
  Widget build(BuildContext context) {
    final userAuthProvider = Provider.of<UserAuthProvider>(context);
    final userDataProvider = Provider.of<UserDataProvider>(context);

    Widget contentWidget = Container();
    if (userAuthProvider.user != null &&
        !userAuthProvider.user!.isEmailVerified) {
      contentWidget = Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          color: Colors.redAccent,
          padding: const EdgeInsets.all(8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(Ionicons.warning_outline, color: Colors.white),
              SizedBox(width: 8),
              Text(
                'Adresse mail non vérifiée !',
                style: TextStyle(color: Colors.white),
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
                const CircleAvatar(
                  radius: 40,
                  backgroundImage: NetworkImage(
                      'https://i.pinimg.com/originals/65/25/a0/6525a08f1df98a2e3a545fe2ace4be47.jpg'),
                ),
                const SizedBox(width: 10),
                Text(userAuthProvider.user!.name)
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
            title: const Text('Accès aux données'),
            onTap: () => context.pushNamed('data'),
          ),
          ListTile(
            leading: const Icon(Ionicons.color_palette_outline),
            title: const Text('Thème de l\'application'),
            onTap: () {},
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
