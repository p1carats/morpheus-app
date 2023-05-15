import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ionicons/ionicons.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar(this.child, {Key? key}) : super(key: key);
  final Widget child;

  @override
  Widget build(BuildContext context) {
    int currentPageIndex = 0;
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        selectedIndex: currentPageIndex,
        onDestinationSelected: (int index) {
          currentPageIndex = index;
        },
        destinations: const <Widget>[
          NavigationDestination(
            selectedIcon: Icon(Ionicons.home),
            icon: Icon(Ionicons.home_outline),
            label: 'Home',
          ),
          NavigationDestination(
            selectedIcon: Icon(Ionicons.bar_chart),
            icon: Icon(Ionicons.bar_chart_outline),
            label: 'Analytics',
          ),
          NavigationDestination(
            selectedIcon: Icon(Ionicons.journal),
            icon: Icon(Ionicons.journal_outline),
            label: 'Dreams',
          ),
          NavigationDestination(
            selectedIcon: Icon(Ionicons.cog),
            icon: Icon(Ionicons.cog_outline),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}
