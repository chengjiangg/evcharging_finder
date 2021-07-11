import 'package:evcharging_finder/screens/search/components/search_form.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatelessWidget {
  static String routeName = "/search";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Search Stations",
        ),
      ),
      body: SearchForm(),
    );
  }
}
