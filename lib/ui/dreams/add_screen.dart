import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:ionicons/ionicons.dart';

import '../../models/dream_model.dart';

import '../../providers/user_provider.dart';
import '../../providers/dream_provider.dart';

class DreamAddScreen extends StatefulWidget {
  const DreamAddScreen({Key? key}) : super(key: key);

  @override
  State<DreamAddScreen> createState() => _DreamAddScreenState();
}

class _DreamAddScreenState extends State<DreamAddScreen>
    with TickerProviderStateMixin {
  late final TabController _tabController;
  final _formKey = GlobalKey<FormState>();

  bool _isLoading = false;

  String _title = '';
  String _description = '';
  DateTime _date = DateTime.now();
  DreamType _type = DreamType.dream;
  double _rating = 1;
  bool _isRecurrent = false;
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
        case 'isRecurrent':
          _isRecurrent = value;
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
        await Provider.of<DreamProvider>(context, listen: false).addDream(
          Provider.of<UserProvider>(context, listen: false).user!.uid,
          DreamModel(
            title: _title,
            description: _description,
            date: _date,
            type: _type,
            rating: _rating.toInt(),
            isRecurrent: _isRecurrent,
            isLucid: _isLucid,
            isControllable: _isControllable,
          ),
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
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
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
        icon: const Icon(Ionicons.add_outline),
        label: const Text('Ajouter'),
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

  bool isExpanded = false;

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
            keyboardType: TextInputType.multiline,
            validator: (value) {
              if (value!.isEmpty) {
                return 'La description ne peut pas être vide.';
              } else {
                return null;
              }
            },
            controller: _descriptionController,
          ),
          const SizedBox(height: 20),
          const Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(5)),
            ),
            child: Padding(
              padding: EdgeInsets.all(8),
              child: ListTile(
                title: Text(
                  'A quoi servent les rêves et pourquoi s\'en souvenir ?',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  'Il existe de nombreuses raisons de vouloir se souvenir de ses rêves : par curiosité, pour tenter de démêler leur aspect intriguant, pour trouver l’inspiration...\nLa bonne nouvelle, c’est qu’être un petit rêveur n’est pas une fatalité : avec de l’entraînement, il est possible de mieux se rappeler ses rêves.\nLe but est de développer le réflexe de se focaliser sur eux dès le réveil : la mémoire du rêve est éphémère, il faut faire un effort conscient pour consolider le rêve en mémoire à long terme. La stratégie la plus efficace est donc de consigner ses rêves dès le réveil dans un journal personnel.',
                  textAlign: TextAlign.justify,
                ),
              ),
            ),
          ),
          const SizedBox(height: 45),
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
  DreamType _type = DreamType.dream;
  double _rating = 1;
  bool _isRecurrent = false;

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
          SegmentedButton<DreamType>(
            segments: const <ButtonSegment<DreamType>>[
              ButtonSegment<DreamType>(
                value: DreamType.dream,
                label: Text('Rêve'),
                icon: Icon(Ionicons.sunny_outline),
              ),
              ButtonSegment<DreamType>(
                value: DreamType.nightmare,
                label: Text('Cauchemar'),
                icon: Icon(Ionicons.thunderstorm_outline),
              ),
            ],
            selected: <DreamType>{_type},
            showSelectedIcon: false,
            onSelectionChanged: (Set<DreamType> newSelection) {
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
          const SizedBox(height: 20),
          SwitchListTile(
            title: Row(
              children: [
                const Text('Rêve récurrent'),
                IconButton(
                  icon: const Icon(Ionicons.help_circle_outline),
                  onPressed: () {},
                ),
              ],
            ),
            value: _isRecurrent,
            onChanged: (bool value) {
              setState(() => _isRecurrent = value);
            },
          ),
          const SizedBox(height: 20),
          const Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(5)),
            ),
            child: Padding(
              padding: EdgeInsets.all(8),
              child: ListTile(
                title: Text(
                  'En quoi consistent les rêves récurrents ?',
                  style: TextStyle(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                subtitle: Text(
                  'Les rêves récurrents sont des rêves qu’un individu peut faire à répétition. On remarque qu’ils surviennent souvent en période de stress ou sur de longues périodes, parfois même sur plusieurs années, voire une vie entière.',
                  textAlign: TextAlign.justify,
                ),
              ),
            ),
          ),
          const SizedBox(height: 45),
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

  aboutDialog() {
    return showModalBottomSheet(
      context: context,
      builder: (context) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
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
              'À propos des rêves lucides et contrôlables',
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            const Text(
              'Les rêves lucides consistent à avoir conscience de rêver pendant le rêve. On estime que 55% des adultes font au moins un rêve lucide au cours de leur vie, et que près 23% en feraient plusieurs chaque mois.',
              textAlign: TextAlign.justify,
            ),
            const SizedBox(height: 8),
            const Text(
              'Dans un tiers des cas, les rêveurs lucides seraient aussi capables d’exercer une forme de contrôle sur leur rêve, par exemple en changeant de lieu ou en choisissant délibérément de se réveiller : on parle alors de rêve contrôlable.',
              textAlign: TextAlign.justify,
            ),
            const SizedBox(height: 8),
            const Text(
              'Cependant, même chez les personnes qui expériencent régulièrement des rêves lucides, ceux-ci ne représentent qu’une petite partie de leurs rêves.',
              textAlign: TextAlign.justify,
            ),
            const SizedBox(height: 20),
            Center(
              child: TextButton(
                child: const Text('Je comprends'),
                onPressed: () => context.pop(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SwitchListTile(
            title: Row(
              children: [
                const Text('Rêve lucide'),
                IconButton(
                  icon: const Icon(Ionicons.help_circle_outline),
                  onPressed: () => aboutDialog(),
                ),
              ],
            ),
            value: _isLucid,
            onChanged: (bool value) {
              setState(() => _isLucid = value);
              widget.onChanged('isLucid', _isLucid);
            },
          ),
          SwitchListTile(
            title: Row(
              children: [
                const Text('Rêve contrôlable'),
                IconButton(
                  icon: const Icon(Ionicons.help_circle_outline),
                  onPressed: () => aboutDialog(),
                ),
              ],
            ),
            value: _isLucid,
            onChanged: (bool value) {
              setState(() => _isControllable = value);
              widget.onChanged('isControllable', _isControllable);
            },
          ),
          const SizedBox(height: 20),
          const Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            child: Padding(
              padding: EdgeInsets.all(5),
              child: ListTile(
                //leading: Icon(Ionicons.information_circle_outline),
                title: Text(
                  'Comment favoriser les rêves lucides ?',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  'Jsp c\'est le job de Théo ça',
                  style: TextStyle(fontSize: 14),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
