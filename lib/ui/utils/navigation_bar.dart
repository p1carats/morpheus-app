import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ionicons/ionicons.dart';
import 'package:morpheus/ui/analytics_screen.dart';
import 'package:morpheus/ui/dreams/dream_screen.dart';
import 'package:morpheus/ui/home_screen.dart';
import 'package:morpheus/ui/settings/settings_screen.dart';
import 'package:morpheus/ui/sleep_screen.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({Key? key}) : super(key: key);

  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int currentPageIndex = 0;

  final List<Widget> pages = [
    const HomeScreen(),
    const AnalyticsMainScreen(),
    const SleepMainScreen(),
    const DreamMainScreen(),
    const SettingsMainScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[currentPageIndex],
      bottomNavigationBar: NavigationBar(
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        selectedIndex: currentPageIndex,
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        destinations: const <NavigationDestination>[
          NavigationDestination(
            selectedIcon: Icon(Ionicons.home),
            icon: Icon(Ionicons.home_outline),
            label: 'Accueil',
          ),
          NavigationDestination(
            selectedIcon: Icon(Ionicons.stats_chart),
            icon: Icon(Ionicons.stats_chart_outline),
            label: 'Analyses',
          ),
          NavigationDestination(
            selectedIcon: Icon(Ionicons.bed),
            icon: Icon(Ionicons.bed_outline),
            label: 'Sommeil',
          ),
          NavigationDestination(
            selectedIcon: Icon(Ionicons.moon),
            icon: Icon(Ionicons.moon_outline),
            label: 'Rêves',
          ),
          NavigationDestination(
            selectedIcon: Icon(Ionicons.cog),
            icon: Icon(Ionicons.cog_outline),
            label: 'Réglages',
          ),
        ],
      ),
    );
  }
}
