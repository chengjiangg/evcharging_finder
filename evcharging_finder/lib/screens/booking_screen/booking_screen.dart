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
      body: _buildListView(),
      bottomNavigationBar: CustomBottomNavBar(selectedMenu: MenuState.home),
    );
  }

  ListView _buildListView() {
    return ListView.builder(
        itemCount: 10,
        itemBuilder: (_, index) {
          return ListTile(
            title: Text("This is booking number #$index"),
            leading: Image.asset("assets/images/shell.png"),
          );
        });
  }
}
