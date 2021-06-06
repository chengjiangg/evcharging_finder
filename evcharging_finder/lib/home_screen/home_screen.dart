import 'package:evcharging_finder/home_screen/components/home_page.dart';
import "package:flutter/material.dart";

class HomeScreen extends StatelessWidget {
  static String routeName = "/home_screen";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: HomePage(),
    );
  }
}
