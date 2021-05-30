import 'dart:async';
import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:evcharging_finder/models/station.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  GoogleMapController mapController;
  HashMap _savedStations = new HashMap<String, Station>();

  final LatLng _center = const LatLng(1.2984665333700876, 103.77618826160976);

  Future<Position> _getPosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Permission.location.request();
      //return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      if (permission == LocationPermission.denied) {
        await Permission.location.request();
        //return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      openAppSettings();
      /*return Future.error(
          'Location permission are permanently denied, we can request permissions.');*/
    }

    return await Geolocator.getCurrentPosition();
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  Widget stationCard(Station station) {
    bool alreadySaved = _savedStations.containsKey(station.name);

    return Container(
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.only(right: 20),
        width: 200.0,
        height: 100.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          color: Colors.white,
          boxShadow: [
            new BoxShadow(
              color: Colors.grey,
              blurRadius: 20.0,
            ),
          ],
        ),
        child: Column(children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(top: 5),
                child: CircleAvatar(
                  backgroundImage: station.providerPic,
                  radius: 35,
                ),
              ),
            ],
          ),
          Container(
              margin: EdgeInsets.only(top: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(station.name,
                      style: TextStyle(fontWeight: FontWeight.bold))
                ],
              )),
          Container(
            margin: EdgeInsets.only(top: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text.rich(TextSpan(
                    text: "Available",
                    style: TextStyle(
                        fontWeight: FontWeight.w600, color: Color(0xFFB2FF59))))
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[Text("0.55km away")],
            ),
          ),
          Container(
              margin: EdgeInsets.only(top: 12),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    ElevatedButton(
                      child: FaIcon(FontAwesomeIcons.directions),
                      style: ElevatedButton.styleFrom(
                        primary: Color(0xFF3EBACE),
                      ),
                      onPressed: () {
                        FirebaseFirestore.instance
                            .collection('test')
                            .add({'text': 'data added through'});
                      },
                    ),
                    ElevatedButton(
                      child: FaIcon(FontAwesomeIcons.ticketAlt),
                      style: ElevatedButton.styleFrom(
                        primary: Color(0xFFF9A825),
                      ),
                      onPressed: () {
                        print('Pressed');
                      },
                    ),
                    GestureDetector(
                        onTap: () {
                          setState(() {
                            if (alreadySaved) {
                              _savedStations.remove(station.name);
                              print("Removed");
                              //print(_savedStations.length);
                            } else {
                              _savedStations.putIfAbsent(
                                  station.name, () => station);
                              print("Added");
                              //print(_savedStations.length);
                            }
                          });
                        },
                        child: FaIcon(
                            alreadySaved
                                ? FontAwesomeIcons.solidHeart
                                : FontAwesomeIcons.heart,
                            color: alreadySaved ? Colors.red : Colors.black)),
                  ]))
        ]));
  }

  List<Widget> getStationsInArea() {
    List<Station> stations = getStations();
    List<Widget> cards = [];
    for (Station station in stations) {
      cards.add(stationCard(station));
    }
    return cards;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          body: Stack(
        children: <Widget>[
          GoogleMap(
            onMapCreated: _onMapCreated,
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            initialCameraPosition: CameraPosition(
              target: _center,
              zoom: 11.0,
            ),
            markers: _createMarker(),
          ),
          Container(
            margin: EdgeInsets.only(bottom: 600),
            child: Center(
              child: Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  boxShadow: [
                    new BoxShadow(
                      color: Colors.grey,
                      blurRadius: 20.0,
                    ),
                  ],
                  color: Colors.white,
                ),
                height: 50,
                width: 300,
                child: TextField(
                  cursorColor: Colors.black,
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                      hintText: "Search for Charging Point",
                      hintStyle: TextStyle(fontFamily: 'Gotham', fontSize: 15),
                      icon: Icon(Icons.search, color: Colors.black),
                      border: InputBorder.none,
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.transparent))),
                ),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: 550, bottom: 50),
            child: ListView(
              padding: EdgeInsets.only(left: 20),
              children: getStationsInArea(),
              scrollDirection: Axis.horizontal,
            ),
          )
        ],
      )),
    );
  }
}

List<Station> getStations() {
  List<Station> stations = [];
  AssetImage shellLogo = new AssetImage("lib/assets/shell.png");
  AssetImage spgroupLogo = new AssetImage("lib/assets/spgroup.png");
  Station shellAlexendra = new Station(
      "Shell Alexandra",
      "358 ALEXANDRA ROAD",
      0.55,
      LatLng(1.2912767667584444, 103.80690717301131),
      shellLogo,
      "lib/assets/shell.png");
  stations.add(shellAlexendra);
  Station spGroupSciencePark = new Station(
      "5 Science Park Drive",
      "5 SCIENCE PARK DRIVE",
      0.4822,
      LatLng(1.2925819221245278, 103.78717825220126),
      spgroupLogo,
      "lib/assets/spgroup.png");
  stations.add(spGroupSciencePark);
  Station shellBoonLay = new Station(
      "Shell Boon Lay",
      "2 BOON LAY AVE",
      0.55,
      LatLng(1.3442174461123866, 103.70782615475888),
      shellLogo,
      "lib/assets/shell.png");
  stations.add(shellBoonLay);
  return stations;
}

Set<Marker> _createMarker() {
  List<Station> stations = getStations();
  return {
    Marker(
        markerId: MarkerId("marker_1"),
        position: stations[0].center,
        infoWindow: InfoWindow(title: stations[0].name)),
    Marker(
        markerId: MarkerId("marker_2"),
        position: stations[1].center,
        infoWindow: InfoWindow(title: stations[1].name)),
    Marker(
        markerId: MarkerId("marker_3"),
        position: stations[2].center,
        infoWindow: InfoWindow(title: stations[2].name)),
  };
}

/* Retrieve FutureValue
@override
  Widget build(BuildContext context) {

    return FutureBuilder(
        future: _getPosition(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              Position snapshotData = snapshot.data;
              LatLng _userLocation =
                  LatLng(snapshotData.latitude, snapshotData.longitude);
              return GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: _userLocation,
                  zoom: 12,
                ),
              );
            } else {
              return Center(child: Text("Failed"));
            }
          }
        });
  }*/
