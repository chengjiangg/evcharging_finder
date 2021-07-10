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
        title: Text("Nearest Station",
            style: TextStyle(color: Colors.black, fontSize: 18)),
        toolbarHeight: 45.0,
        backgroundColor: Color(0xFF3EBACE),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {},
          ),
        ],
      ),
      body: HomePage(),
      bottomNavigationBar: CustomBottomNavBar(selectedMenu: MenuState.home),
    );
  }
}
