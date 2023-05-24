import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:ionicons/ionicons.dart';

import '../../providers/user_provider.dart';
import '../../providers/sleep_provider.dart';

class SleepDataPage extends StatefulWidget {
  const SleepDataPage({Key? key}) : super(key: key);

  @override
  _SleepDataPageState createState() => _SleepDataPageState();
}

class _SleepDataPageState extends State<SleepDataPage> {
  final _formKey = GlobalKey<FormState>();
  int? _desiredSleepDuration;

  void _submit() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      try {
        await userProvider.updateDesiredSleepDuration(
            userProvider.user!.uid, _desiredSleepDuration!);
        if (context.mounted) context.goNamed('settings');
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error.toString()),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final birthDate =
        Provider.of<UserProvider>(context, listen: false).user?.birthDate;
    final desiredSleepDuration =
        Provider.of<UserProvider>(context, listen: false)
            .user
            ?.desiredSleepDuration;

    final currentDate = DateTime.now();
    int age = currentDate.month < birthDate!.month ||
            (currentDate.month == birthDate.month &&
                currentDate.day < birthDate.day)
        ? currentDate.year - birthDate.year - 1
        : currentDate.year - birthDate.year;

    int referenceSleepDuration;
    if (age >= 26) {
      referenceSleepDuration = 9;
    } else if (age >= 18) {
      referenceSleepDuration = 8;
    } else if (age >= 14) {
      referenceSleepDuration = 10;
    } else if (age >= 6) {
      referenceSleepDuration = 11;
    } else {
      referenceSleepDuration = 12;
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Ionicons.arrow_back_outline),
          onPressed: () => context.pop(),
        ),
        title: const Text('Gestion des données'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Durée de sommeil souhaitée',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              const SizedBox(height: 10.0),
              Text(
                  'Vous semblez avoir $age ans. La durée minimale de sommeil recommandée pour votre tranche d\'âge est de ${referenceSleepDuration}h, et la durée minimale est de ${referenceSleepDuration - 2}h. Vous pouvez modifier cette valeur ci-dessous si vous le souhaitez.'),
              const SizedBox(height: 20.0),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Nombre d\'heures de sommeil souhaitées',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Ionicons.bed_outline),
                ),
                initialValue: desiredSleepDuration.toString(),
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Merci d\'entrer une valeur valide !';
                  } else {
                    return null;
                  }
                },
                onSaved: (value) {
                  if (value != null && value.isNotEmpty) {
                    _desiredSleepDuration = int.tryParse(value);
                  }
                },
              ),
              const SizedBox(height: 20),
              const Text(
                  'Notez que la modification de cette valeur, tout comme le non respect de celle-ci n\'est pas recommandée par défaut. Ne la modifiez qu\'en connaissance de cause !'),
              const SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () => _submit(),
                child: const Text('Mettre à jour'),
              ),
              const SizedBox(height: 20.0),
              const Divider(),
              const SizedBox(height: 20.0),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Accès aux données de sommeil',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              const SizedBox(height: 10.0),
              const Text(
                  'Pour vous proposer des analyses de merde, Morpheus a besoin de vos données de sommeil.\nElles ne sont pas stockées sur nos serveurs, et sont uniquement utilisées pour vous proposer des analyses personnalisées.\nVous pouvez révoquer l\'accès à vos données à tout moment.'),
              if (Provider.of<SleepProvider>(context).checkIfUserIsAuthorized()
                      is Future<bool> ==
                  false) ...[
                const SizedBox(height: 10.0),
                // checkbox
                ElevatedButton(
                  onPressed: () {},
                  child: const Text('Révoquer l\'accès à mes données'),
                ),
              ] else ...[
                const SizedBox(height: 10.0),
                ElevatedButton(
                  onPressed: () {},
                  child: const Text('Autoriser l\'accès à mes données'),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
