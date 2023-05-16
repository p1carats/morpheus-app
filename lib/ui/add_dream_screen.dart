import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ionicons/ionicons.dart';

class AddDreamScreen extends StatefulWidget {
  const AddDreamScreen({Key? key}) : super(key: key);

  @override
  State<AddDreamScreen> createState() => _AddDreamScreenState();
}

class _AddDreamScreenState extends State<AddDreamScreen>
    with TickerProviderStateMixin {
  late final TabController _tabController;

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
        padding: const EdgeInsets.fromLTRB(20, 40, 20, 20),
        child: Form(
          child: TabBarView(
            controller: _tabController,
            children: <Widget>[
              ListView(
                children: [
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Titre du rêve',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Ionicons.eye_outline),
                    ),
                    validator: (value) => value!.isEmpty
                        ? 'Le titre ne peut pas être vide.'
                        : null,
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    maxLines: 6,
                    decoration: const InputDecoration(
                      labelText: 'Description',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Ionicons.journal_outline),
                    ),
                    validator: (value) => value!.isEmpty
                        ? 'La description ne peut pas être vide.'
                        : null,
                  ),
                ],
              ),
              ListView(
                children: [
                  const Text('test mamene2'),
                ],
              ),
              ListView(
                children: [
                  const Text('test mamene3'),
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
