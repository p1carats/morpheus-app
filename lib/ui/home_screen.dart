import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:ionicons/ionicons.dart';

import '../providers/user_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar.large(
            flexibleSpace: FlexibleSpaceBar(
              title: Text('Bonjour ${userProvider.user!.name} !'),
              background: Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/banner.jpg'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              Card(
                child: Container(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const <Widget>[
                      Text(
                        'Ma dernière nuit de sommeil',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 10),
                      Text('Un résumé...'),
                    ],
                  ),
                ),
              ),
              Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                    color: Theme.of(context).colorScheme.outline,
                  ),
                  borderRadius: const BorderRadius.all(Radius.circular(12)),
                ),
                child: const SizedBox(
                  width: 400,
                  height: 200,
                  child: Center(
                    child: Text(
                        'Un rêve lucide est un rêve dans lequel le rêveur est conscient qu’il est en train de rêver. Il peut alors prendre le contrôle de son rêve et faire ce qu’il veut.'),
                  ),
                ),
              )
            ]),
          ),
        ],
      ),
    );
  }
}
