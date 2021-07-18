import 'package:evcharging_finder/constants.dart';
import 'package:evcharging_finder/screens/profile/components/profile_pic.dart';
import 'package:evcharging_finder/screens/profile_page/profile_page.dart';
import 'package:evcharging_finder/screens/sign_in/sign_in_screen.dart';
import 'package:evcharging_finder/screens/splash/Splash_Screen.dart';
import 'package:evcharging_finder/services/auth_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";
import 'package:flutter_svg/svg.dart';

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ProfilePic(),
        SizedBox(height: 20),
        ProfileMenu(
          icon: "assets/icons/User Icon.svg",
          text: "My Account",
          press: () {
            if (FirebaseAuth.instance.currentUser == null) {
              Navigator.pushNamed(context, SignInScreen.routeName);
            } else {
              Navigator.pushNamed(context, Profilepage.routeName);
            }
          },
        ),
        FirebaseAuth.instance.currentUser == null
            ? ProfileMenu(
                icon: "assets/icons/Log out.svg",
                text: "Sign In To Save Your Data",
                press: () {
                  Navigator.pushNamed(context, SignInScreen.routeName);
                },
              )
            : ProfileMenu(
                icon: "assets/icons/Log out.svg",
                text: "Log Out",
                press: () {
                  AuthClass().signOut();
                  Navigator.pushNamed(context, SplashScreen.routeName);
                },
              ),
      ],
    );
  }
}

class ProfileMenu extends StatelessWidget {
  const ProfileMenu({
    Key key,
    @required this.text,
    @required this.icon,
    @required this.press,
  }) : super(key: key);
  final String text, icon;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: TextButton(
        style: TextButton.styleFrom(
          primary: Color(0xFFF5F6F9),
          padding: EdgeInsets.all(20),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        ),
        onPressed: press,
        child: Row(
          children: [
            SvgPicture.asset(
              icon,
              width: 22,
              color: kPrimaryColor,
            ),
            SizedBox(width: 20),
            Expanded(
                child: Text(
              text,
              style: Theme.of(context).textTheme.bodyText1,
            )),
            Icon(Icons.arrow_forward_ios)
          ],
        ),
      ),
    );
  }
}
