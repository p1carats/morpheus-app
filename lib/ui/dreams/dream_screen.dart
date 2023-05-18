import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:ionicons/ionicons.dart';

import '../../models/user_model.dart';
import '../../models/dream_model.dart';

import '../../providers/user/auth_provider.dart';
import '../../services/dream/data_service.dart';

class DreamMainScreen extends StatefulWidget {
  const DreamMainScreen({Key? key}) : super(key: key);

  @override
  State<DreamMainScreen> createState() => _DreamMainScreenState();
}

class _DreamMainScreenState extends State<DreamMainScreen> {
  final DreamDataService _dreamService = DreamDataService();

  late Stream<List<DreamModel>> _dreamStream;

  @override
  void initState() {
    super.initState();
    final userAuthProvider =
        Provider.of<UserAuthProvider>(context, listen: false);
    final UserModel user = userAuthProvider.user!;
    _dreamStream = _dreamService.getDreams(user.uid);
  }

  Future<void> _refreshDreams() async {
    final userAuthProvider =
        Provider.of<UserAuthProvider>(context, listen: false);
    final UserModel user = userAuthProvider.user!;
    setState(() {
      _dreamStream = _dreamService.getDreams(user.uid);
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
