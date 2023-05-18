import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:ionicons/ionicons.dart';

import '../../providers/user_auth_provider.dart';
import '../../providers/user_data_provider.dart';

class SettingsProfileScreen extends StatefulWidget {
  const SettingsProfileScreen({Key? key}) : super(key: key);

  @override
  State<SettingsProfileScreen> createState() => _SettingsProfileScreenState();
}

class _SettingsProfileScreenState extends State<SettingsProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final userAuthProvider = Provider.of<UserAuthProvider>(context);
    final userDataProvider = Provider.of<UserDataProvider>(context);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Ionicons.arrow_back_outline),
          onPressed: () => context.pop(),
        ),
        title: const Text('Mon profil'),
      ),
      body: ListView(
        children: [
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
            subtitle: Text(userAuthProvider.user!.gender),
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
              leading: const Icon(Ionicons.trash_bin_outline),
              title: const Text('Supprimer mon compte'),
              trailing: const Icon(Ionicons.chevron_forward_outline),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Supprimer mon compte'),
                    content: const Text(
                        'Êtes-vous sûr de vouloir supprimer votre compte ? Cette action est défintive.'),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Annuler'),
                      ),
                      TextButton(
                        onPressed: () async {
                          await userDataProvider.deleteUser();
                          FirebaseAuth.instance.currentUser?.reload();
                          if (context.mounted) context.goNamed('auth');
                        },
                        child: const Text('Supprimer'),
                      ),
                    ],
                  ),
                );
              }),
        ],
      ),
    );
  }
}
