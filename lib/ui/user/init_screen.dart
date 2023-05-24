import 'dart:io';
import 'package:flutter/material.dart';
import "package:flutter/services.dart";
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ionicons/ionicons.dart';

import '../../providers/user_provider.dart';

class UserInitScreen extends StatefulWidget {
  const UserInitScreen({Key? key}) : super(key: key);

  @override
  State<UserInitScreen> createState() => _UserInitScreenState();
}

class _UserInitScreenState extends State<UserInitScreen> {
  final _formKey = GlobalKey<FormState>();
  File? _image;
  int? _desiredSleepDuration;

  void _submit() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      try {
        if (_image != null) {
          await userProvider.updateProfilePicture(
              userProvider.user!.uid, _image!);
        }
        if (_desiredSleepDuration != null) {
          await userProvider.updateDesiredSleepDuration(
              userProvider.user!.uid, _desiredSleepDuration!);
        }
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

  Future<void> _selectImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context, listen: false).user?.name;
    final birthDate =
        Provider.of<UserProvider>(context, listen: false).user?.birthDate;
    final desiredSleepDuration =
        Provider.of<UserProvider>(context, listen: false)
            .user
            ?.desiredSleepDuration;
    final profilePicture =
        Provider.of<UserProvider>(context, listen: false).user?.profilePicture;

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
        //title: const Text('Mon profil'),
        actions: [
          TextButton.icon(
            icon: const Icon(Ionicons.help_outline),
            label: const Text('Ce n\'est pas vous ?'),
            onPressed: () async {
              await Provider.of<UserProvider>(context, listen: false).signOut();
              if (context.mounted) context.goNamed('auth');
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              Text(
                'Bienvenue sur Morpheus, $user !',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 20.0),
              const Text(
                  'Suivez vos données de santé et notez vos rêves avec notre appli de malade mental. Créez votre profil sans plus attendre !'),
              const SizedBox(height: 20.0),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundImage: _image != null
                          ? FileImage(_image!) as ImageProvider<Object>?
                          : NetworkImage(profilePicture!),
                    ),
                    const SizedBox(width: 20),
                    TextButton(
                      onPressed: _selectImage,
                      child: Row(
                        children: const [
                          Icon(Ionicons.camera_outline),
                          SizedBox(width: 5),
                          Text('Changer de photo'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20.0),
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
                child: const Text('Créer mon profil'),
              ),
              TextButton(
                onPressed: () => context.go('/'),
                child: const Text('Passer cette étape'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
