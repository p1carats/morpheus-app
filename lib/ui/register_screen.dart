import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/user_model.dart';
import '../providers/user_auth_provider.dart';

class RegisterScreen extends StatefulWidget {
  RegisterScreen({Key? key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _birthDateController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inscription'),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Nom'),
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return 'Merci d\'entrer un nom valide.';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Adresse mail'),
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return 'Merci d\'entrer une adresse mail valide.';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Mot de passe'),
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return 'Merci d\'entrer un mot de passe valide.';
                }
                return null;
              },
            ),
            DropdownButtonFormField<Genders>(
              value: _genderController,
              decoration: const InputDecoration(labelText: 'Gender'),
              onChanged: (Genders? value) {
                setState(() {
                  _genderController = value;
                });
              },
              validator: (Genders? value) {
                if (value == null) {
                  return 'Please select a gender';
                }
                return null;
              },
              items: Genders.values.map((Genders gender) {
                return DropdownMenuItem<Genders>(
                  value: gender,
                  child: Text(gender == Genders.male
                      ? 'Male'
                      : gender == Genders.female
                          ? 'Female'
                          : 'I prefer not to answer'),
                );
              }).toList(),
            ),
            ),
            // Birth date and Sleep hours TextFormFields can be added in similar way. For date, you would probably use a DatePicker.
            ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  try {
                    await Provider.of<UserAuthProvider>(context, listen: false)
                        .register(
                      email: _emailController.text,
                      password: _passwordController.text,
                      displayName: _nameController.text,
                      gender: _genderController.text,
                      birthDate: DateTime.parse(_birthDateController
                          .text), // Assuming input in YYYY-MM-DD format
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Error: ${e.toString()}')));
                  }
                }
              },
              child: const Text('Inscription'),
            ),
          ],
        ),
      ),
    );
  }
}
