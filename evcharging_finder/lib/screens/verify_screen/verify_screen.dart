import 'package:flutter/material.dart';

import 'components/body.dart';

class VerifyScreen extends StatelessWidget {
  static String routeName = "/verify_screen";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Verify Email"),
        automaticallyImplyLeading: false,
      ),
      body: Body(),
    );
  }
}
