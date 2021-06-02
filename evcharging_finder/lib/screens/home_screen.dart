import 'dart:async';
import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:evcharging_finder/models/station.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:evcharging_finder/widgets/stationCard.dart';
import 'package:evcharging_finder/models/station.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  GoogleMapController mapController;
  HashMap _savedStations = new HashMap<String, Station>();

  final LatLng _center = const LatLng(1.2984665333700876, 103.77618826160976);

  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

  @override
  void initState() {
    _getPosition();
    populateStations();
    super.initState();
  }

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

  populateStations() {
    FirebaseFirestore.instance
        .collection("stations")
        .get()
        .then((querySnapshot) {
      querySnapshot.docs.forEach((result) {
        initMarker(result.data(), result.data()["name"], result);
      });
    });
  }

  void initMarker(station, stationId, querySnapshot) {
    var markerIdVal = stationId;
    final MarkerId markerId = MarkerId(markerIdVal);

    final Marker marker = Marker(
        markerId: markerId,
        position: LatLng(station["latitude"], station["longitude"]),
        //infoWindow: InfoWindow(title: station["name"]),
        onTap: () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return Container(
                  padding: EdgeInsets.only(
                      top: 550, bottom: 50, left: 100, right: 100),
                  child: StationCard(
                    documentSnapshot: querySnapshot,
                    name: station["name"],
                    distanceAway: 0.55,
                    providerPic: new AssetImage("lib/assets/shell.png"),
                  ),
                );
              });
        });
    setState(() {
      markers[markerId] = marker;
    });
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
              zoom: 13.0,
            ),
            markers: Set<Marker>.of(markers.values),
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
          /*Container(
              padding: EdgeInsets.only(top: 550, bottom: 50),
              child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection("stations")
                      .snapshots(),
                  builder: (context, snapshot) {
                    return !snapshot.hasData
                        ? Center(child: CircularProgressIndicator())
                        : ListView.builder(
                            padding: EdgeInsets.only(left: 20),
                            scrollDirection: Axis.horizontal,
                            itemCount: snapshot.data.docs.length,
                            itemBuilder: (context, index) {
                              DocumentSnapshot data = snapshot.data.docs[index];
                              return StationCard(
                                documentSnapshot: data,
                                name: data["name"],
                                distanceAway: 0.55,
                                providerPic:
                                    new AssetImage("lib/assets/shell.png"),
                              );
                            },
                          );
                  }))*/
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
