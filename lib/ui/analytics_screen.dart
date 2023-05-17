import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ionicons/ionicons.dart';

class AnalyticsMainScreen extends StatefulWidget {
  const AnalyticsMainScreen({Key? key}) : super(key: key);

  @override
  State<AnalyticsMainScreen> createState() => _AnalyticsMainScreenState();
}

class _AnalyticsMainScreenState extends State<AnalyticsMainScreen>
    with TickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
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
        title: const Text('Analyses'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const <Widget>[
            Tab(
              icon: Icon(Icons.book_outlined),
              text: 'Sommeil',
            ),
            Tab(
              icon: Icon(Ionicons.eye_outline),
              text: 'Rêves',
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: <Widget>[
          ListView(
            children: const [
              Placeholder(),
            ],
          ),
          ListView(
            children: const [
              Placeholder(),
            ],
          ),
        ],
      ),
    );
  }
}
