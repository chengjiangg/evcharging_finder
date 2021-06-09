import 'package:evcharging_finder/components/custom_bottom_nav_bar.dart';
import "package:flutter/material.dart";

import '../../enums.dart';

class ProfileScreen extends StatelessWidget {
  static String routeName = "/profile_screen";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Profile"),
      ),
      bottomNavigationBar: CustomBottomNavBar(selectedMenu: MenuState.home),
    );
  }
}