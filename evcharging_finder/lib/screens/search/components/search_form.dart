import 'package:flutter/material.dart';
import 'package:evcharging_finder/models/station.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:evcharging_finder/size_config.dart';
import 'package:evcharging_finder/screens/booking_form/booking_form.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:evcharging_finder/screens/sign_in/sign_in_screen.dart';

class SearchForm extends StatefulWidget {
  @override
  _SearchFormState createState() => _SearchFormState();
}

class _SearchFormState extends State<SearchForm> {
  TextEditingController _searchController = TextEditingController();

  List _stations = [];
  List _results = [];

  @override
  void initState() {
    getinfo();
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  _onSearchChanged() {
    searchResultList();
  }

  searchResultList() {
    var showResults = [];

    if (_searchController.text != "") {
      // If we have a param
      for (var station in _stations) {
        var title = station.name.toLowerCase();

        if (title.contains(_searchController.text.toLowerCase())) {
          showResults.add(station);
        }
      }
    } else {
      showResults = List.from(_stations);
    }
    setState(() {
      _results = showResults;
    });
  }

  void getinfo() async {
    // final prefs = await SharedPreferences.getInstance();
    // final keys = prefs.getKeys();

    String timeNow = DateTime.now().hour.toString() + "00";
    if (timeNow.length == 3) {
      timeNow = "0" + timeNow;
    }
    FirebaseFirestore.instance
        .collection("stations")
        .get()
        .then((querySnapshot) {
      querySnapshot.docs.forEach((element) {
        FirebaseFirestore.instance
            .collection("stations")
            .doc(element.id)
            .get()
            .then((result) {
          String name = result.data()["name"];
          String address = result.data()["address"];
          var latLng =
              LatLng(result.data()["latitude"], result.data()["longitude"]);
          var image = new AssetImage("assets/images/shell.png");
          var imageAddress = "assets/images/shell.png";
          FirebaseFirestore.instance
              .collection("stations")
              .doc(element.id)
              .collection("timeslots")
              .doc(timeNow)
              .get()
              .then((result) {
            var isAvailable = result.data()["isAvailable"];
            Station station = new Station(
                name, address, latLng, isAvailable, image, imageAddress);
            setState(() {
              _stations.add(station);
            });
          });
        });
      });
    });
    searchResultList();
  }

  void handleChange(String stationId) {
    setState(() {
      _stations.clear();
      getinfo();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      color: Color(0xFFF5F5F5),
      child: Column(
        children: [
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.search),
              hintText: "Search for Stations",
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _results.length,
              itemBuilder: (context, index) => Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: favoriteCard(_results[index], context, handleChange),
              ),
            ),
          ),
        ],
      ),
    ));
  }
}

void _showBookingPanel(
    BuildContext context, Station station, ValueChanged<String> stationId) {
  showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
            padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 60.0),
            child: BookingForm(
                stationName: station.name,
                latitude: station.center.latitude.toString(),
                longitude: station.center.longitude.toString(),
                onChanged: stationId));
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

Widget favoriteCard(
    Station station, BuildContext context, ValueChanged<String> stationId) {
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
                    text: station.isAvailable ? "Available" : "Not Available",
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: station.isAvailable
                            ? Color(0xFFB2FF59)
                            : Color(0xFFF44336)))))
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
                        if (FirebaseAuth.instance.currentUser == null) {
                          Fluttertoast.showToast(
                            msg: "Please Sign In to Continue",
                            gravity: ToastGravity.CENTER,
                            timeInSecForIosWeb: 2,
                          );
                          Navigator.pushNamed(context, SignInScreen.routeName);
                        } else {
                          _showBookingPanel(context, station, stationId);
                        }
                      }),
                ])),
        SizedBox(width: getProportionateScreenWidth(5.0)),
      ]));
}
