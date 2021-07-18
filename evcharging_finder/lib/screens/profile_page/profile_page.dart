import 'package:evcharging_finder/screens/profile_page/components/profile_data.dart';
import 'package:flutter/material.dart';

import 'components/body.dart';

class Profilepage extends StatelessWidget {
  static String routeName = "/profile_page";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Profile",
        ),
      ),
      body: Body(),
    );
  }
}
