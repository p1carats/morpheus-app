import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:ionicons/ionicons.dart';

import '../../models/dream_model.dart';

import '../../providers/user_provider.dart';
import '../../providers/dream_provider.dart';

class DreamEditScreen extends StatefulWidget {
  const DreamEditScreen({Key? key, required this.id}) : super(key: key);
  final String id;

  @override
  State<DreamEditScreen> createState() => _DreamEditScreenState();
}

class _DreamEditScreenState extends State<DreamEditScreen>
    with TickerProviderStateMixin {
  late final TabController _tabController;
  final _formKey = GlobalKey<FormState>();

  DreamModel? _dream;

  bool _isLoading = false;

  String _title = '';
  String _description = '';
  DateTime _date = DateTime.now();
  String _type = 'dream';
  double _rating = 1;
  bool _isLucid = false;
  bool _isControllable = false;

  void _onTabDataChanged(String field, dynamic value) {
    setState(() {
      switch (field) {
        case 'title':
          _title = value;
          break;
        case 'description':
          _description = value;
          break;
        case 'date':
          _date = value;
          break;
        case 'type':
          _type = value;
          break;
        case 'rating':
          _rating = value;
          break;
        case 'isLucid':
          _isLucid = value;
          break;
        case 'isControllable':
          _isControllable = value;
          break;
      }
    });
  }

  void _submit() async {
    setState(() {
      _isLoading = true;
    });

    final isValid = _formKey.currentState!.validate();
    if (!isValid) {
      return;
    } else {
      _formKey.currentState!.save();
      try {
        await Provider.of<DreamProvider>(context, listen: false).updateDream(
          Provider.of<UserProvider>(context, listen: false).user!.uid,
          widget.id,
          _dream!,
        );
        if (context.mounted) context.pop();
      } catch (err) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(err.toString()),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadDream();
  }

  Future<void> _loadDream() async {
    final dream =
        await Provider.of<DreamProvider>(context, listen: false).getDream(
      Provider.of<UserProvider>(context, listen: false).user!.uid,
      widget.id,
    );
    setState(() {
      _dream = dream;
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_dream == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Modifier un rêve'),
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
        child: Stack(
          children: <Widget>[
            Form(
              key: _formKey,
              child: TabBarView(
                controller: _tabController,
                children: <Widget>[
                  DreamAddScreenNarrativeTab(onChanged: _onTabDataChanged),
                  DreamAddScreenDetailsTab(onChanged: _onTabDataChanged),
                  DreamAddScreenLucidityTab(onChanged: _onTabDataChanged),
                ],
              ),
            ),
            if (_isLoading) const Center(child: CircularProgressIndicator()),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Ionicons.create_outline),
        label: const Text('Modifier'),
        onPressed: _submit,
      ),
    );
  }
}

class DreamAddScreenNarrativeTab extends StatefulWidget {
  final Function(String, dynamic) onChanged;
  const DreamAddScreenNarrativeTab({
    Key? key,
    required this.onChanged,
  }) : super(key: key);

  @override
  _DreamAddScreenNarrativeTabState createState() =>
      _DreamAddScreenNarrativeTabState();
}

class _DreamAddScreenNarrativeTabState extends State<DreamAddScreenNarrativeTab>
    with AutomaticKeepAliveClientMixin {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _titleController.addListener(() {
      widget.onChanged('title', _titleController.text);
    });
    _descriptionController.addListener(() {
      widget.onChanged('description', _descriptionController.text);
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SingleChildScrollView(
      child: Column(
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
            controller: _titleController,
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
            controller: _descriptionController,
          ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class DreamAddScreenDetailsTab extends StatefulWidget {
  final Function(String, dynamic) onChanged;
  const DreamAddScreenDetailsTab({
    Key? key,
    required this.onChanged,
  }) : super(key: key);

  @override
  _DreamAddScreenDetailsTabState createState() =>
      _DreamAddScreenDetailsTabState();
}

class _DreamAddScreenDetailsTabState extends State<DreamAddScreenDetailsTab>
    with AutomaticKeepAliveClientMixin {
  DateTime _date = DateTime.now();
  String _type = 'dream';
  double _rating = 1;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2000),
      lastDate: DateTime(DateTime.now().year + 1),
    );
    if (picked != null) {
      setState(() {
        _date = picked;
      });
      widget.onChanged('date', _date);
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SingleChildScrollView(
      child: Column(
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
              widget.onChanged('type', _type);
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
              widget.onChanged('rating', _rating);
            },
          ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class DreamAddScreenLucidityTab extends StatefulWidget {
  final Function(String, dynamic) onChanged;
  const DreamAddScreenLucidityTab({
    Key? key,
    required this.onChanged,
  }) : super(key: key);

  @override
  _DreamAddScreenLucidityTabState createState() =>
      _DreamAddScreenLucidityTabState();
}

class _DreamAddScreenLucidityTabState extends State<DreamAddScreenLucidityTab>
    with AutomaticKeepAliveClientMixin {
  bool _isLucid = false;
  bool _isControllable = false;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SwitchListTile(
            title: const Text('Rêve lucide'),
            value: _isLucid,
            onChanged: (bool value) {
              setState(
                () => _isLucid = value,
              );
              widget.onChanged('isLucid', _isLucid);
            },
          ),
          SwitchListTile(
            title: const Text('Rêve contrôlable'),
            value: _isControllable,
            onChanged: (bool value) {
              setState(
                () => _isControllable = value,
              );
              widget.onChanged('isControllable', _isControllable);
            },
          ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
