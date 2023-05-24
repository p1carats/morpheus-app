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

  late final ValueNotifier<String> _title = ValueNotifier<String>('');
  late final ValueNotifier<String> _description = ValueNotifier<String>('');
  late final ValueNotifier<DateTime> _date =
      ValueNotifier<DateTime>(DateTime.now());
  late final ValueNotifier<DreamType> _type =
      ValueNotifier<DreamType>(DreamType.dream);
  late final ValueNotifier<double> _rating = ValueNotifier<double>(1);
  late final ValueNotifier<bool> _isRecurrent = ValueNotifier<bool>(false);
  late final ValueNotifier<bool> _isLucid = ValueNotifier<bool>(false);
  late final ValueNotifier<bool> _isControllable = ValueNotifier<bool>(false);

  void _onTabDataChanged(String field, dynamic value) {
    setState(() {
      switch (field) {
        case 'title':
          _title.value = value;
          break;
        case 'description':
          _description.value = value;
          break;
        case 'date':
          _date.value = value;
          break;
        case 'type':
          _type.value = value;
          break;
        case 'rating':
          _rating.value = value;
          break;
        case '_isRecurrent':
          _isRecurrent.value = value;
          break;
        case 'isLucid':
          _isLucid.value = value;
          break;
        case 'isControllable':
          _isControllable.value = value;
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
      _title.value = _dream!.title;
      _description.value = _dream!.description;
      _date.value = _dream!.date;
      _type.value = _dream!.type;
      _rating.value = _dream!.rating.toDouble();
      _isRecurrent.value = _dream!.isRecurrent;
      _isLucid.value = _dream!.isLucid;
      _isControllable.value = _dream!.isControllable;
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
        actions: <Widget>[
          IconButton(
            icon: const Icon(Ionicons.trash_outline),
            tooltip: 'Supprimer',
            onPressed: () async {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Suppression du rêve'),
                  content: const Text(
                      'Êtes-vous sûr de vouloir supprimer ce rêve ? Cette action est irréversible.'),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () => context.pop(),
                      child: const Text('Annuler'),
                    ),
                    TextButton(
                      onPressed: () async {
                        String user =
                            Provider.of<UserProvider>(context, listen: false)
                                .user!
                                .uid;
                        await Provider.of<DreamProvider>(context, listen: false)
                            .deleteDream(user, widget.id);
                        if (context.mounted) {
                          context.pop();
                          context.pop();
                          context.pop();
                        }
                      },
                      child: const Text('Supprimer'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
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
                  DreamAddScreenNarrativeTab(
                    onChanged: _onTabDataChanged,
                    titleNotifier: _title,
                    descriptionNotifier: _description,
                  ),
                  DreamAddScreenDetailsTab(
                    onChanged: _onTabDataChanged,
                    dateNotifier: _date,
                    typeNotifier: _type,
                    ratingNotifier: _rating,
                    recurrentNotifier: _isRecurrent,
                  ),
                  DreamAddScreenLucidityTab(
                    onChanged: _onTabDataChanged,
                    lucidNotifier: _isLucid,
                    controllableNotifier: _isControllable,
                  ),
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
  final ValueNotifier<String> titleNotifier;
  final ValueNotifier<String> descriptionNotifier;
  const DreamAddScreenNarrativeTab({
    Key? key,
    required this.onChanged,
    required this.titleNotifier,
    required this.descriptionNotifier,
  }) : super(key: key);

  @override
  _DreamAddScreenNarrativeTabState createState() =>
      _DreamAddScreenNarrativeTabState();
}

class _DreamAddScreenNarrativeTabState extends State<DreamAddScreenNarrativeTab>
    with AutomaticKeepAliveClientMixin {
  String _title = '';
  String _description = '';

  @override
  void initState() {
    super.initState();
    _title = widget.titleNotifier.value;
    widget.titleNotifier.addListener(() {
      setState(() {
        _title = widget.titleNotifier.value;
      });
    });
    _description = widget.descriptionNotifier.value;
    widget.descriptionNotifier.addListener(() {
      setState(() {
        _description = widget.descriptionNotifier.value;
      });
    });
  }

  @override
  void dispose() {
    widget.titleNotifier.removeListener(() {});
    widget.descriptionNotifier.removeListener(() {});
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
            initialValue: widget.titleNotifier.value,
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
            onChanged: (value) {
              widget.titleNotifier.value = value;
              widget.onChanged('title', value);
            },
          ),
          const SizedBox(height: 20),
          TextFormField(
            initialValue: widget.descriptionNotifier.value,
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
            onChanged: (value) {
              widget.descriptionNotifier.value = value;
              widget.onChanged('description', value);
            },
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
  final ValueNotifier<DateTime> dateNotifier;
  final ValueNotifier<DreamType> typeNotifier;
  final ValueNotifier<double> ratingNotifier;
  final ValueNotifier<bool> recurrentNotifier;
  const DreamAddScreenDetailsTab({
    Key? key,
    required this.onChanged,
    required this.dateNotifier,
    required this.typeNotifier,
    required this.ratingNotifier,
    required this.recurrentNotifier,
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
      initialDate: widget.dateNotifier.value,
      firstDate: DateTime(2000),
      lastDate: DateTime(DateTime.now().year + 1),
    );
    if (picked != null) {
      widget.dateNotifier.value = picked;
      widget.onChanged('date', picked);
    }
  }

  @override
  void initState() {
    super.initState();
    _date = widget.dateNotifier.value;
    widget.dateNotifier.addListener(() {
      setState(() {
        _date = widget.dateNotifier.value;
      });
    });
    _type = widget.typeNotifier.value;
    widget.typeNotifier.addListener(() {
      setState(() {
        _type = widget.typeNotifier.value;
      });
    });
    _rating = widget.ratingNotifier.value;
    widget.ratingNotifier.addListener(() {
      setState(() {
        _rating = widget.ratingNotifier.value;
      });
    });
    _isRecurrent = widget.recurrentNotifier.value;
    widget.recurrentNotifier.addListener(() {
      setState(() {
        _isRecurrent = widget.recurrentNotifier.value;
      });
    });
  }

  @override
  void dispose() {
    widget.dateNotifier.removeListener(() {});
    widget.typeNotifier.removeListener(() {});
    widget.ratingNotifier.removeListener(() {});
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
              widget.typeNotifier.value = newSelection.first;
              widget.onChanged('type', newSelection.first);
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
            onChanged: (double newValue) {
              widget.ratingNotifier.value = newValue;
              widget.onChanged('rating', newValue);
            },
          ),
          const SizedBox(height: 20),
          SwitchListTile(
            title: Row(
              children: [
                const Text('Rêve récurrent'),
                IconButton(
                  icon: const Icon(Ionicons.help_circle_outline),
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
                              'Qu\'est-ce qu\'un rêve récurrent ?',
                              style: Theme.of(context).textTheme.headlineSmall,
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'blablabla',
                              style: Theme.of(context).textTheme.titleMedium,
                              //textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 20),
                            Row(
                              children: [
                                TextButton(
                                  child: const Text('Ok !'),
                                  onPressed: () => context.pop(),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    );
                  },
                  tooltip: 'UwU',
                ),
              ],
            ),
            value: _isRecurrent,
            onChanged: (bool value) {
              setState(() => _isRecurrent = value);
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
  final ValueNotifier<bool> lucidNotifier;
  final ValueNotifier<bool> controllableNotifier;
  const DreamAddScreenLucidityTab({
    Key? key,
    required this.onChanged,
    required this.lucidNotifier,
    required this.controllableNotifier,
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
  void initState() {
    super.initState();
    _isLucid = widget.lucidNotifier.value;
    widget.lucidNotifier.addListener(() {
      setState(() {
        _isLucid = widget.lucidNotifier.value;
      });
    });
    _isControllable = widget.controllableNotifier.value;
    widget.controllableNotifier.addListener(() {
      setState(() {
        _isControllable = widget.controllableNotifier.value;
      });
    });
  }

  @override
  void dispose() {
    widget.lucidNotifier.removeListener(() {});
    widget.controllableNotifier.removeListener(() {});
    super.dispose();
  }

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
              widget.lucidNotifier.value = value;
              widget.onChanged('lucid', value);
            },
          ),
          SwitchListTile(
            title: const Text('Rêve contrôlable'),
            value: _isControllable,
            onChanged: (bool value) {
              widget.controllableNotifier.value = value;
              widget.onChanged('controlled', value);
            },
          ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
