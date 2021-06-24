import 'package:evcharging_finder/screens/booking_screen/booking_screen.dart';
import 'package:evcharging_finder/screens/favourites/favourites_screen.dart';
import 'package:evcharging_finder/screens/home_screen/home_screen.dart';
import 'package:evcharging_finder/screens/profile/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../constants.dart';
import '../enums.dart';

class CustomBottomNavBar extends StatefulWidget {
  final MenuState selectedMenu;
  const CustomBottomNavBar({
    Key key,
    @required this.selectedMenu,
  }) : super(key: key);

  @override
  _CustomBottomNavBarState createState() => _CustomBottomNavBarState();
}

class _CustomBottomNavBarState extends State<CustomBottomNavBar> {
  @override
  Widget build(BuildContext context) {
    final Color inActiveIconColor = Color(0xFFB6B6B6);
    return Container(
      padding: EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            offset: Offset(0, -15),
            blurRadius: 20,
            color: Color(0xFFDADADA).withOpacity(0.15),
          ),
        ],
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(40),
          topRight: Radius.circular(40),
        ),
      ),
      child: SafeArea(
          top: false,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                  icon: FaIcon(FontAwesomeIcons.mapMarkerAlt),
                  onPressed: () {
                    Navigator.pushNamed(context, HomeScreen.routeName)
                        .then((_) {
                      setState(() {});
                    });
                  }),
              IconButton(
                icon: FaIcon(FontAwesomeIcons.solidHeart),
                onPressed: () =>
                    Navigator.pushNamed(context, FavouritesScreen.routeName),
              ),
              IconButton(
                icon: FaIcon(FontAwesomeIcons.scroll),
                onPressed: () =>
                    Navigator.pushNamed(context, BookingScreen.routeName),
              ),
              IconButton(
                icon: FaIcon(FontAwesomeIcons.userAlt),
                onPressed: () =>
                    Navigator.pushNamed(context, ProfileScreen.routeName),
              )
            ],
          )),
    );
  }
}
