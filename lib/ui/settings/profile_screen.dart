import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ionicons/ionicons.dart';

import 'package:morpheus/providers/user_provider.dart';

class SettingsProfileScreen extends StatefulWidget {
  const SettingsProfileScreen({Key? key}) : super(key: key);

  @override
  State<SettingsProfileScreen> createState() => _SettingsProfileScreenState();
}

class _SettingsProfileScreenState extends State<SettingsProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  File? _image;
  String? _name;

  void _submit() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      try {
        if (_name != null) {
          await Provider.of<UserProvider>(context, listen: false)
              .updateDisplayName(userProvider.user!.uid, _name!);
        }
        if (_image != null) {
          await Provider.of<UserProvider>(context, listen: false)
              .updateProfilePicture(userProvider.user!.uid, _image!);
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
    final profilePicture =
        Provider.of<UserProvider>(context, listen: false).user?.profilePicture;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Ionicons.arrow_back_outline),
          onPressed: () => context.pop(),
        ),
        title: const Text('Mon profil'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
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
              const SizedBox(height: 30),
              TextFormField(
                initialValue: user,
                decoration: const InputDecoration(
                  labelText: 'Nom d\'utilisateur',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Ionicons.person_outline),
                ),
                validator: (value) {
                  if (value!.isEmpty || value.length < 3) {
                    return 'Nom trop court ! (3 caractères minimum)';
                  }
                  return null;
                },
                onSaved: (value) {
                  _name = value!;
                },
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                onPressed: () => _submit(),
                child: const Text('Valider'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
