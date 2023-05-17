import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ionicons/ionicons.dart';

import '../../models/dream_model.dart';
import '../../services/dream_data_service.dart';

class DreamMainScreen extends StatefulWidget {
  const DreamMainScreen({Key? key}) : super(key: key);

  @override
  State<DreamMainScreen> createState() => _DreamMainScreenState();
}

class _DreamMainScreenState extends State<DreamMainScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DreamDataService _dreamService = DreamDataService();

  late Stream<List<DreamModel>> _dreamStream;

  @override
  void initState() {
    super.initState();
    _dreamStream = _dreamService.getDreams(_auth.currentUser!.uid);
  }

  Future<void> _refreshDreams() async {
    setState(() {
      _dreamStream = _dreamService.getDreams(_auth.currentUser!.uid);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rêves'),
        actions: <Widget>[
          TextButton.icon(
            icon: const Icon(Ionicons.add_outline),
            label: const Text('Nouveau rêve'),
            onPressed: () => context.pushNamed('add'),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refreshDreams,
        child: StreamBuilder<List<DreamModel>>(
          stream: _dreamStream,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (snapshot.hasData && snapshot.data!.isEmpty) {
              return const Text('Aucun rêve n\'a été enregistré.');
            } else {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  DreamModel dream = snapshot.data![index];
                  return Card(
                    child: ListTile(
                      title: Text(
                        dream.title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(dream.description),
                      trailing: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            '${dream.date.day}',
                            style: const TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            DateFormat('MMM').format(dream.date),
                            style: const TextStyle(
                              fontSize: 12.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
