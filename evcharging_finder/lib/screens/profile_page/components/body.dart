import 'package:evcharging_finder/models/user.dart';
import 'package:evcharging_finder/screens/profile_page/components/profile_data.dart';
import 'package:evcharging_finder/services/firebase_services.dart';
import 'package:flutter/material.dart';

class Body extends StatefulWidget {
  @override
  _Body createState() => _Body();
}

class _Body extends State<Body> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Container(
            child: Align(
              alignment: Alignment.center,
              child: Column(
                children: [
                  FutureBuilder<AppUser>(
                    future: FirebaseFunctions().getUser(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return ProfileData(
                          docSnapshot: snapshot,
                        );
                      } else {
                        return Center(
                          child: CircularProgressIndicator(
                              // backgroundColor: Colors.white,
                              ),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
