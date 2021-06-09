import 'package:evcharging_finder/components/custom_bottom_nav_bar.dart';
import 'package:evcharging_finder/screens/favourites/components/favourites_page.dart';
import 'package:flutter/material.dart';

import '../../enums.dart';

class FavouritesScreen extends StatelessWidget {
  static String routeName = "/favourites_screen";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Favourites"),
      ),
      body: FavouritesPage(),
      bottomNavigationBar: CustomBottomNavBar(selectedMenu: MenuState.home),
    );
  }
}
