import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:evcharging_finder/screens/app.dart';
import 'package:evcharging_finder/routes.dart';
import 'package:evcharging_finder/screens/splash/Splash_Screen.dart';
import 'package:evcharging_finder/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Locate Nearest Charging Point',
      debugShowCheckedModeBanner: false,
      //home: MainApp(),
      theme: theme(),
      initialRoute: SplashScreen.routeName,
      routes: routes,
    );
  }
}
