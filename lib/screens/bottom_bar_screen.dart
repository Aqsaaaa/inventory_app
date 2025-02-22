import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:inventory/gen/assets.gen.dart';
import 'package:inventory/gen/colors.gen.dart';
import 'package:inventory/screens/items_screen.dart';
import 'package:inventory/screens/stats_screen.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _page = 1;

  final List<Widget> _pages = [
    const ItemsScreen(),
    const ItemStatsScreen(),
    const ItemsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: ColorName.background,
        color: ColorName.primary,
        buttonBackgroundColor: ColorName.primary,
        height: 70,
        items: <Widget>[
          Assets.icon.inventory.svg(width: 50, color: ColorName.background),
          Assets.icon.home.svg(width: 50, color: ColorName.background),
          Assets.icon.history.svg(width: 50, color: ColorName.background),
        ],
        onTap: (index) {
          setState(() {
            _page = index;
          });
        },
        index: _page,
      ),
      body: _pages[_page],
    );
  }
}
