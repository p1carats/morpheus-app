import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import '../../providers/app_provider.dart';

class WizardWelcomeScreen extends StatefulWidget {
  const WizardWelcomeScreen({Key? key}) : super(key: key);

  @override
  State<WizardWelcomeScreen> createState() => _WizardWelcomeScreenState();
}

class _WizardWelcomeScreenState extends State<WizardWelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bienvenue !'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const <Widget>[
            Text(
              'HEY',
            )
          ],
        ),
      ),
    );
  }
}
