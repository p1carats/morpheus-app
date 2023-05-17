import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:ionicons/ionicons.dart';

class DreamAddScreen extends StatefulWidget {
  const DreamAddScreen({Key? key}) : super(key: key);

  @override
  State<DreamAddScreen> createState() => _DreamAddScreenState();
}

class _DreamAddScreenState extends State<DreamAddScreen>
    with TickerProviderStateMixin {
  late final TabController _tabController;

  String _title = '';
  String _description = '';
  DateTime _date = DateTime.now();
  String _type = 'dream';
  double _rating = 1;
  bool _isLucid = false;
  bool _isControllable = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2000),
      lastDate: DateTime(DateTime.now().year + 1),
    );
    if (picked != null && picked != _date) {
      setState(() {
        _date = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nouveau rêve'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const <Widget>[
            Tab(
              icon: Icon(Icons.book_outlined),
              text: 'Récit',
            ),
            Tab(
              icon: Icon(Icons.brush_outlined),
              text: 'Détails',
            ),
            Tab(
              icon: Icon(Ionicons.moon_outline),
              text: 'Lucidité',
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 30, 20, 20),
        child: Form(
          child: TabBarView(
            controller: _tabController,
            children: <Widget>[
              ListView(
                children: [
                  const SizedBox(height: 5),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Titre du rêve',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Ionicons.eye_outline),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Le titre ne peut pas être vide.';
                      } else {
                        return null;
                      }
                    },
                    onSaved: (value) {
                      _title = value!;
                    },
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    maxLines: 6,
                    decoration: const InputDecoration(
                      labelText: 'Description',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Ionicons.journal_outline),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'La description ne peut pas être vide.';
                      } else {
                        return null;
                      }
                    },
                    onSaved: (value) {
                      _description = value!;
                    },
                  ),
                ],
              ),
              ListView(
                children: [
                  const SizedBox(height: 5),
                  TextFormField(
                    readOnly: true,
                    decoration: const InputDecoration(
                      labelText: 'Date du rêve',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Ionicons.calendar_outline),
                    ),
                    onTap: () => _selectDate(context),
                    controller: TextEditingController(
                      text: DateFormat('dd/MM/yyyy').format(_date),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text('Type de rêve'),
                  SegmentedButton<String>(
                    segments: const <ButtonSegment<String>>[
                      ButtonSegment<String>(
                        value: 'dream',
                        label: Text('Rêve'),
                        icon: Icon(Ionicons.sunny_outline),
                      ),
                      ButtonSegment<String>(
                        value: 'nightmare',
                        label: Text('Cauchemar'),
                        icon: Icon(Ionicons.thunderstorm_outline),
                      ),
                    ],
                    selected: <String>{_type},
                    showSelectedIcon: false,
                    onSelectionChanged: (Set<String> newSelection) {
                      setState(() {
                        _type = newSelection.first;
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  const Text('Note du rêve'),
                  Slider(
                    value: _rating,
                    min: 1,
                    max: 5,
                    divisions: 4,
                    label: _rating.round().toString(),
                    onChanged: (double value) {
                      setState(() {
                        _rating = value;
                      });
                    },
                  ),
                ],
              ),
              ListView(
                children: [
                  Switch(
                    value: _isLucid,
                    onChanged: (bool value) {
                      setState(
                        () => _isLucid = value,
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  Switch(
                    value: _isControllable,
                    onChanged: (bool value) {
                      setState(
                        () => _isControllable = value,
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Ionicons.add_outline),
        label: const Text('Ajouter'),
        onPressed: () => context.pop(),
      ),
    );
  }
}
