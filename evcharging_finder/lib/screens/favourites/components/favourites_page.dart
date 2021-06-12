import 'package:flutter/material.dart';
import 'package:evcharging_finder/models/station.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FavouritesPage extends StatefulWidget {
  @override
  _FavouritesPageState createState() => _FavouritesPageState();
}

class _FavouritesPageState extends State<FavouritesPage> {
  List<Station> stations = [];

  @override
  void initState() {
    getFav();
    super.initState();
  }

  void getFav() async {
    final prefs = await SharedPreferences.getInstance();
    final keys = prefs.getKeys();
    keys.forEach((element) {
      FirebaseFirestore.instance
          .collection("stations")
          .doc(element)
          .get()
          .then((result) {
        Station station = new Station(
            result.data()["name"],
            result.data()["address"],
            0.55,
            LatLng(result.data()["latitude"], result.data()["longitude"]),
            new AssetImage("assets/images/shell.png"),
            "assets/images/shell.png");
        setState(() {
          stations.add(station);
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      child: ListView.builder(
        itemCount: stations.length,
        itemBuilder: (context, index) => Padding(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Dismissible(
            key: Key(stations[index].name),
            direction: DismissDirection.endToStart,
            onDismissed: (direction) async {
              final prefs = await SharedPreferences.getInstance();
              setState(() {
                stations.removeAt(index);
                prefs.remove(stations[index].name);
              });
            },
            background: Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: Color(0xFFFFE6E6),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Row(
                children: [
                  Spacer(),
                  FaIcon(FontAwesomeIcons.trash),
                ],
              ),
            ),
            child: favoriteCard(stations[index]),
          ),
        ),
      ),
    ));
  }
}

Widget favoriteCard(Station station) {
  return Container(
      color: Colors.white,
      child: Row(children: [
        SizedBox(width: 8.0),
        SizedBox(
          width: 70,
          child: AspectRatio(
            aspectRatio: 0.70,
            child: Container(
              padding: EdgeInsets.all(5.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Image.asset(station.imageURL),
            ),
          ),
        ),
        SizedBox(width: 20),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 190.0,
              child: Text(
                station.name,
                style: TextStyle(color: Colors.black, fontSize: 15),
                maxLines: 2,
              ),
            ),
            SizedBox(height: 10),
            Container(
                width: 190.0,
                child: Text.rich(TextSpan(
                    text: "Available",
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Color(0xFFB2FF59)))))
          ],
        ),
        SizedBox(width: 20),
        Container(
            alignment: Alignment.centerRight,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  ElevatedButton(
                    child: FaIcon(FontAwesomeIcons.directions),
                    style: ElevatedButton.styleFrom(
                      primary: Color(0xFF3EBACE),
                      minimumSize: Size(100, 40),
                    ),
                    onPressed: () {
                      print('Pressed');
                    },
                  ),
                  ElevatedButton(
                      child: FaIcon(FontAwesomeIcons.ticketAlt),
                      style: ElevatedButton.styleFrom(
                        primary: Color(0xFFF9A825),
                        minimumSize: Size(100, 40),
                      ),
                      onPressed: () {
                        print('Pressed');
                      }),
                ])),
      ]));
}
