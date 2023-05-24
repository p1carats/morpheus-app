import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:ionicons/ionicons.dart';

import '../../providers/user_provider.dart';

class UserRegisterScreen extends StatefulWidget {
  const UserRegisterScreen({Key? key, required this.email}) : super(key: key);
  final String? email;

  @override
  _UserRegisterScreenState createState() => _UserRegisterScreenState();
}

class _UserRegisterScreenState extends State<UserRegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final FocusNode _passwordFocusNode = FocusNode();
  final FocusNode _confirmPasswordFocusNode = FocusNode();
  bool _isLoading = false;
  bool _obscureConfirmPassword = true;
  String _name = '';
  String _email = '';
  String _password = '';
  String? _checkPassword;
  DateTime _birthDate = DateTime.now();
  String _gender = '';

  @override
  void initState() {
    super.initState();
    _email = widget.email ?? '';
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _passwordFocusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _passwordFocusNode.dispose();
    _confirmPasswordFocusNode.dispose();
    super.dispose();
  }

  void _submit() async {
    _email = widget.email ?? '';
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() {
        _isLoading = true;
      });
      try {
        await Provider.of<UserProvider>(context, listen: false)
            .signUp(_name, _email, _password, _gender, _birthDate);
        if (context.mounted) context.goNamed('init');
      } catch (err) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(err.toString()),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      } finally {
        setState(() {
          _password = '';
          _checkPassword = '';
          _isLoading = false;
        });
      }
    }
  }

  // Function to show the DatePicker
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _birthDate,
      firstDate: DateTime(1900),
      lastDate: DateTime(DateTime.now().year + 1),
    );

    if (picked != null && picked != _birthDate) {
      setState(() {
        _birthDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Ionicons.arrow_back_outline),
          onPressed: () => context.pop(),
        ),
        title: const Text('Inscription'),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const SizedBox(height: 30),
                Text('Inscription en tant que ${widget.email}'),
                const SizedBox(height: 20),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Nom',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Ionicons.person_outline),
                  ),
                  validator: (value) {
                    if (value!.isEmpty || value.length < 3) {
                      return 'Nom trop court ! (3 caractères minimum)';
                    } else {
                      return null;
                    }
                  },
                  onSaved: (value) {
                    _name = value!;
                  },
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(_passwordFocusNode);
                  },
                  autofillHints: const [AutofillHints.givenName],
                ),
                const SizedBox(height: 20),
                TextFormField(
                  focusNode: _passwordFocusNode,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Mot de passe',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Ionicons.lock_closed_outline),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Merci d\'entrer un mot de passe';
                    } else if (value.length < 7) {
                      return 'Le mot de passe doit contenir au moins 7 caractères';
                    } else if (!RegExp(r'\d').hasMatch(value)) {
                      return 'Le mot de passe doit contenir au moins un chiffre';
                    } else if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]')
                        .hasMatch(value)) {
                      return 'Le mot de passe doit contenir au moins un caractère spécial';
                    } else {
                      _checkPassword = value;
                      return null;
                    }
                  },
                  onSaved: (value) {
                    _password = value!;
                    _checkPassword = value;
                  },
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (_) {
                    FocusScope.of(context)
                        .requestFocus(_confirmPasswordFocusNode);
                  },
                  autofillHints: const [AutofillHints.newPassword],
                ),
                const SizedBox(height: 20),
                TextFormField(
                  focusNode: _confirmPasswordFocusNode,
                  obscureText: _obscureConfirmPassword,
                  decoration: InputDecoration(
                    labelText: 'Confirmer le mot de passe',
                    border: const OutlineInputBorder(),
                    prefixIcon: const Icon(Ionicons.lock_closed_outline),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureConfirmPassword
                            ? Ionicons.eye_off_outline
                            : Ionicons.eye_outline,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureConfirmPassword = !_obscureConfirmPassword;
                        });
                      },
                    ),
                  ),
                  validator: (value) {
                    if (value!.isEmpty || value != _checkPassword) {
                      return 'Les mots de passe ne correspondent pas !';
                    } else {
                      return null;
                    }
                  },
                  onSaved: (value) {},
                  autofillHints: const [AutofillHints.newPassword],
                ),
                const SizedBox(height: 20),
                TextFormField(
                  readOnly: true,
                  decoration: const InputDecoration(
                    labelText: 'Date de naissance',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Ionicons.calendar_outline),
                  ),
                  onTap: () => _selectDate(context),
                  controller: TextEditingController(
                    text: DateFormat('dd/MM/yyyy').format(_birthDate),
                  ),
                ),
                const SizedBox(height: 20),
                const Text('Genre'),
                const SizedBox(height: 5),
                SegmentedButton<String>(
                  segments: const <ButtonSegment<String>>[
                    ButtonSegment<String>(
                      value: 'male',
                      label: Text('Homme'),
                      icon: Icon(Ionicons.male_outline),
                    ),
                    ButtonSegment<String>(
                      value: 'female',
                      label: Text('Femme'),
                      icon: Icon(Ionicons.female_outline),
                    ),
                    ButtonSegment<String>(
                      value: 'nonbinary',
                      label: Text('Autre'),
                      icon: Icon(Ionicons.male_female_outline),
                    ),
                  ],
                  selected: <String>{_gender},
                  showSelectedIcon: false,
                  onSelectionChanged: (Set<String> newSelection) {
                    setState(() => _gender = newSelection.first);
                  },
                ),
                const SizedBox(height: 30),
                _isLoading
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 50, vertical: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        onPressed: _submit,
                        child: const Text('Inscription'),
                      ),
                const SizedBox(height: 10),
                TextButton.icon(
                  icon: const Icon(Ionicons.help_buoy_outline),
                  label: const Text(
                      'Pourquoi avons-nous besoin de ces informations ?'),
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (context) => Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 40,
                              height: 5,
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            const SizedBox(height: 20),
                            Text(
                              'Pourquoi avons-nous besoin de ces informations ?',
                              style: Theme.of(context).textTheme.headlineSmall,
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'Les données de sommeil sont personnalisées en fonction de l\'âge et du genre. Ces informations sont donc nécessaires pour vous fournir des données précises.',
                              style: Theme.of(context).textTheme.titleMedium,
                              //textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 20),
                            TextButton(
                              child: const Text('Je comprends'),
                              onPressed: () => Navigator.of(context).pop(),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
