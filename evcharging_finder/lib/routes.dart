//import 'dart:js';

import 'package:evcharging_finder/screens/home_screen/home_screen.dart';
import 'package:flutter/widgets.dart';
import 'package:evcharging_finder/screens/complete_profile/complete_profile_screen.dart';
import 'package:evcharging_finder/screens/forgot_password/forgot_password.dart';
import 'package:evcharging_finder/screens/login_success/login_success_screen.dart';
import 'package:evcharging_finder/screens/sign_in/sign_in_screen.dart';
import 'package:evcharging_finder/screens/sign_up/sign_up_screen.dart';
import 'package:evcharging_finder/screens/splash/Splash_Screen.dart';
import 'package:evcharging_finder/screens/favourites/favourites_screen.dart';
import 'package:evcharging_finder/screens/booking_screen/booking_screen.dart';
import 'package:evcharging_finder/screens/profile/profile_screen.dart';
import 'package:evcharging_finder/screens/search/search_screen.dart';

final Map<String, WidgetBuilder> routes = {
  SplashScreen.routeName: (context) => SplashScreen(),
  SignInScreen.routeName: (context) => SignInScreen(),
  ForgotPasswordScreen.routeName: (context) => ForgotPasswordScreen(),
  LoginSuccessScreen.routeName: (context) => LoginSuccessScreen(),
  SignUpScreen.routeName: (context) => SignUpScreen(),
  CompleteProfileScreen.routeName: (context) => CompleteProfileScreen(),
  HomeScreen.routeName: (context) => HomeScreen(),
  FavouritesScreen.routeName: (context) => FavouritesScreen(),
  BookingScreen.routeName: (context) => BookingScreen(),
  ProfileScreen.routeName: (context) => ProfileScreen(),
  SearchScreen.routeName: (context) => SearchScreen(),
};
