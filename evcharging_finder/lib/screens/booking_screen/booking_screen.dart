import 'package:evcharging_finder/components/custom_bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:evcharging_finder/screens/booking_screen/components/booking_page.dart';

import '../../enums.dart';

class BookingScreen extends StatelessWidget {
  static String routeName = "/booking_screen";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Bookings",
            style: TextStyle(color: Colors.black, fontSize: 18)),
        toolbarHeight: 45.0,
        automaticallyImplyLeading: false,
        backgroundColor: Color(0xFF3EBACE),
      ),
      body: BookingPage(),
      bottomNavigationBar: CustomBottomNavBar(selectedMenu: MenuState.home),
    );
  }
}
