import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';


class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _page = 2;

  final List<Widget> _pages = [
    const HomePage(),
    // const CartScreen(),
    // const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: ColorName.background,
        color: ColorName.primary,
        buttonBackgroundColor: ColorName.primary,
        height: 50,
        items: <Widget>[
          Assets.icon.cart.svg(),
          // Assets.icon.home.svg(color: ColorName.background),
          // Assets.icon.profile.svg(),
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
