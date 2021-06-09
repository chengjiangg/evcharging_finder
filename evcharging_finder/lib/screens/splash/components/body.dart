import 'package:evcharging_finder/screens/home_screen/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:evcharging_finder/components/default_button.dart';
import 'package:evcharging_finder/screens/sign_in/sign_in_screen.dart';
import 'package:evcharging_finder/size_config.dart';
import '../components/splash_content.dart';

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: SizedBox(
      width: double.infinity,
      child: Column(
        children: <Widget>[
          Expanded(
              flex: 3,
              child: SplashContent(
                  image: "assets/images/App_logo.png",
                  text: 'Redefining Convenience')),
          Expanded(
              flex: 2,
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: getProportionateScreenWidth(20)),
                child: Column(
                  children: <Widget>[
                    Spacer(flex: 3),
                    DefaultButton(
                      text: "Continue as Guest",
                      press: () {
                        Navigator.pushNamed(context, HomeScreen.routeName);
                      },
                    ),
                    SizedBox(height: getProportionateScreenHeight(30)),
                    DefaultButton(
                      text: "Continue as User",
                      press: () {
                        Navigator.pushNamed(context, SignInScreen.routeName);
                      },
                    ),
                    Spacer(),
                  ],
                ),
              )),
        ],
      ),
    ));
  }
}
