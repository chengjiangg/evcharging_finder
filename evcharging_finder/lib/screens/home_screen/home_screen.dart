import 'package:evcharging_finder/screens/home_screen/components/home_page.dart';
import 'package:evcharging_finder/components/custom_bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:evcharging_finder/enums.dart';

class HomeScreen extends StatelessWidget {
  static String routeName = "/home_screen";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Search"),
      ),
      body: HomePage(),
      bottomNavigationBar: CustomBottomNavBar(selectedMenu: MenuState.home),
    );
  }
}
