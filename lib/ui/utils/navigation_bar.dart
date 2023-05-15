import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ionicons/ionicons.dart';
import 'package:morpheus/ui/dreams_screen.dart';
import 'package:morpheus/ui/home_screen.dart';
import 'package:morpheus/ui/settings_screen.dart';
import 'package:morpheus/ui/sleep_screen.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({Key? key}) : super(key: key);

  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int currentPageIndex = 0;

  final List<Widget> pages = [
    // Define your pages here
    // For example: HomePage(), AnalyticsPage(), DreamsPage(), SettingsPage()
    const HomeScreen(),
    const SleepScreen(),
    const DreamsScreen(),
    const SettingsScreen(),
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
