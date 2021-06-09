import 'package:evcharging_finder/components/custom_bottom_nav_bar.dart';
import 'package:flutter/material.dart';

import '../../enums.dart';

class BookingScreen extends StatelessWidget {
  static String routeName = "/booking_screen";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Bookings"),
      ),
      bottomNavigationBar: CustomBottomNavBar(selectedMenu: MenuState.home),
    );
  }
}
