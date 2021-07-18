import 'package:evcharging_finder/models/user.dart';
import 'package:evcharging_finder/services/firebase_services.dart';
import 'package:flutter/material.dart';

class ProfileData extends StatelessWidget {
  final AsyncSnapshot<AppUser> docSnapshot;

  ProfileData({this.docSnapshot});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Column(
        children: [
          CircleAvatar(
            radius: 60,
            foregroundColor: Colors.blue,
            backgroundImage: AssetImage(
              'assets/images/App_logo.png',
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            docSnapshot.data.firstName,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            docSnapshot.data.lastName,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(
            height: 30,
          ),
          Text(
            docSnapshot.data.emailID,
            style: TextStyle(
              color: Colors.black87,
              fontSize: 12,
            ),
          ),
          SizedBox(
            height: 30,
          ),
        ],
      ),
    );
  }
}
