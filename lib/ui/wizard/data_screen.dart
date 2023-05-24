import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:ionicons/ionicons.dart';

import '../../providers/app_provider.dart';
import '../../providers/user_provider.dart';
import '../../providers/sleep_provider.dart';

class WizardDataScreen extends StatefulWidget {
  const WizardDataScreen({Key? key}) : super(key: key);

  @override
  State<WizardDataScreen> createState() => _WizardDataScreenState();
}

class _WizardDataScreenState extends State<WizardDataScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Ionicons.arrow_back_outline),
          onPressed: () => context.pop(),
        ),
        title: const Text('Données de sommeil'),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                'Afin d\'offrir une expérience personnalisée et des recommandations précises, nous avons besoin de votre autorisation pour accéder à vos données de sommeil.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20.0),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                onPressed: () {},
                child: const Text('Récupérer mes données'),
              ),
              //const SizedBox(height: 15),
              TextButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Pas si vite !'),
                      content: const Text(
                          'Sans données de santé, Morpheus ne pourra pas vous proposer de conseils personnalisés sur votre sommeil. Vous ne pourrez utiliser que les fonctionnalités liées à l\'enregistrement de rêves.'),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Annuler'),
                        ),
                        TextButton(
                          onPressed: () {
                            if (context.mounted) context.goNamed('home');
                          },
                          child: const Text('Je comprends'),
                        ),
                      ],
                    ),
                  );
                },
                child: const Text('Passer cette étape'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
