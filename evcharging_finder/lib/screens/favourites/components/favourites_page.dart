import 'package:flutter/material.dart';
import 'package:evcharging_finder/models/station.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:evcharging_finder/size_config.dart';
import 'package:evcharging_finder/screens/booking_form/booking_form.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:fluttertoast/fluttertoast.dart';

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
      color: Color(0xFFF5F5F5),
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
                prefs.remove(stations[index].name);
                stations.removeAt(index);
              });
              Fluttertoast.showToast(
                msg: "Station Removed",
                gravity: ToastGravity.CENTER,
                timeInSecForIosWeb: 2,
              );
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
            child: favoriteCard(stations[index], context),
          ),
        ),
      ),
    ));
  }
}

void _showBookingPanel(BuildContext context) {
  showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
            padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 60.0),
            child: BookingForm());
      });
}

void _launchMap(String lat, String lng) async {
  final String googleMapsUrl = "comgooglemaps://?center=$lat,$lng";
  final String appleMapsUrl = "https://maps.apple.com/?q=$lat,$lng";

  if (await canLaunch(googleMapsUrl)) {
    await launch(googleMapsUrl);
  }
  if (await canLaunch(appleMapsUrl)) {
    await launch(appleMapsUrl, forceSafariVC: false);
  } else {
    throw "Couldn't launch URL";
  }
}

Widget favoriteCard(Station station, BuildContext context) {
  return Container(
      color: Colors.white,
      child: Row(children: [
        SizedBox(width: getProportionateScreenWidth(5.0)),
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
        SizedBox(width: getProportionateScreenWidth(10.0)),
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
        SizedBox(width: getProportionateScreenWidth(10.0)),
        Container(
            alignment: Alignment.centerRight,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  ElevatedButton(
                    child: FaIcon(FontAwesomeIcons.directions),
                    style: ElevatedButton.styleFrom(
                      primary: Color(0xFF3EBACE),
                      minimumSize: Size(getProportionateScreenHeight(80.0),
                          getProportionateScreenWidth(35.0)),
                    ),
                    onPressed: () {
                      _launchMap(station.center.latitude.toString(),
                          station.center.longitude.toString());
                    },
                  ),
                  ElevatedButton(
                      child: FaIcon(FontAwesomeIcons.ticketAlt),
                      style: ElevatedButton.styleFrom(
                        primary: Color(0xFFF9A825),
                        minimumSize: Size(getProportionateScreenHeight(80),
                            getProportionateScreenWidth(35.0)),
                      ),
                      onPressed: () {
                        _showBookingPanel(context);
                      }),
                ])),
        SizedBox(width: getProportionateScreenWidth(5.0)),
      ]));
}
