import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:evcharging_finder/screens/home_screen.dart';
import 'package:evcharging_finder/screens/favourites.dart';

class MainApp extends StatefulWidget {
  MainApp({Key key}) : super(key: key);

  @override
  _MainApp createState() => _MainApp();
}

class _MainApp extends State<MainApp> {
  PageController _pageController = PageController();

  final List<Widget> _screens = [
    HomeScreen(),
    Favourites(),
  ];

  int _currentTab = 0;
  void _onPageChanged(int index) {
    setState(() {
      _currentTab = index;
    });
  }

  void _onItemTapped(int selectedIndex) {
    _pageController.jumpToPage(selectedIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        children: _screens,
        onPageChanged: _onPageChanged,
        physics: NeverScrollableScrollPhysics(),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentTab,
        onTap: _onItemTapped,
        iconSize: 25,
        items: [
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.mapMarkerAlt),
            label: "Nearby",
          ),
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.solidHeart),
            label: "Favourites",
          ),
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.scroll),
            label: "Bookings",
          ),
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.userAlt),
            label: "Account",
          )
        ],
      ),
    );
  }
}
