import 'dart:async';
import 'dart:math' show cos, sqrt, asin;
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:evcharging_finder/models/station.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:evcharging_finder/screens/home_screen/components/stationCard.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  GoogleMapController mapController;
  Completer<GoogleMapController> _controller = Completer();
  BitmapDescriptor sourceIcon;

  Set<Polyline> _polylines = Set<Polyline>();
  List<LatLng> polylineCoordinates = [];
  PolylinePoints polylinePoints;

  final LatLng _center = const LatLng(1.2984665333700876, 103.77618826160976);

  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

  @override
  void initState() {
    BitmapDescriptor.fromAssetImage(ImageConfiguration(devicePixelRatio: 2.5),
            'assets/images/carIcon.png')
        .then((onValue) {
      sourceIcon = onValue;
    });
    _getPosition();
    populateStations();
    polylinePoints = PolylinePoints();
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
        Station station = new Station(
            result.data()["name"],
            result.data()["address"],
            0.55,
            LatLng(result.data()["latitude"], result.data()["longitude"]),
            new AssetImage("assets/images/shell.png"),
            "assets/images/shell.png");
        initMarker(station, result.data()["name"].toString(), result);
      });
    });
  }

  double _coordinateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }

  void initMarker(station, stationId, querySnapshot) async {
    var markerIdVal = stationId;
    final MarkerId markerId = MarkerId(markerIdVal);
    bool alreadySaved;
    double totalDistance;

    final Marker marker = Marker(
        markerId: markerId,
        position: station.center,
        //infoWindow: InfoWindow(title: station["name"]),
        onTap: () async {
          final prefs = await SharedPreferences.getInstance();
          setState(() {
            _polylines.clear();
            polylineCoordinates = [];
            totalDistance = 0.0;
            alreadySaved = (prefs.getBool(stationId.toString()) ?? false);
          });
          PolylineResult result =
              await polylinePoints.getRouteBetweenCoordinates(
                  "AIzaSyCA6x5Bdw8K18FZ1JHGkOuZgLLh_OV-W0g",
                  PointLatLng(_center.latitude, _center.longitude),
                  PointLatLng(
                      station.center.latitude, station.center.longitude));

          if (result.status == 'OK') {
            result.points.forEach((PointLatLng point) {
              polylineCoordinates.add(LatLng(point.latitude, point.longitude));
            });

            setState(() {
              _polylines.add(Polyline(
                  width: 5,
                  polylineId: PolylineId('polyLine'),
                  color: Color(0xFF08A5CB),
                  points: polylineCoordinates));
            });
          }
          print(result.status);
          for (int i = 0; i < polylineCoordinates.length - 1; i++) {
            totalDistance += _coordinateDistance(
              polylineCoordinates[i].latitude,
              polylineCoordinates[i].longitude,
              polylineCoordinates[i + 1].latitude,
              polylineCoordinates[i + 1].longitude,
            );
          }
          print(totalDistance);
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return Container(
                    padding: EdgeInsets.only(
                        top: 550, bottom: 50, left: 100, right: 100),
                    child: StationCard(
                      documentSnapshot: querySnapshot,
                      name: station.name,
                      distanceAway:
                          double.parse((totalDistance).toStringAsFixed(2)),
                      providerPic: station.providerPic,
                      alreadySaved: alreadySaved,
                      onChanged: _handleTapboxChanged,
                    ));
              });
        });
    setState(() {
      markers[markerId] = marker;
    });
  }

  void setPolylines(LatLng source, LatLng dest) async {
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        "<GOOGLE_MAPS_API_KEY_HERE>",
        PointLatLng(source.latitude, source.longitude),
        PointLatLng(dest.latitude, dest.longitude));

    if (result.status == 'OK') {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });

      setState(() {
        _polylines.add(Polyline(
            width: 10,
            polylineId: PolylineId('polyLine'),
            color: Color(0xFF08A5CB),
            points: polylineCoordinates));
      });
    }
  }

  void _handleTapboxChanged(String stationId) async {
    bool alreadySaved;
    final prefs = await SharedPreferences.getInstance();
    alreadySaved = (prefs.getBool(stationId.toString()) ?? false);

    setState(() {
      if (alreadySaved) {
        prefs.remove(stationId.toString());
        print("Removed");
        //print(_savedStations.length);
      } else {
        prefs.setBool(stationId.toString(), true);
        print("Added");
        //print(_savedStations.length);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          body: Stack(
        children: <Widget>[
          GoogleMap(
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
              setState(() {
                markers[MarkerId("sourceLoc")] = Marker(
                  markerId: MarkerId("sourceLoc"),
                  position: _center,
                  icon: sourceIcon,
                  infoWindow: InfoWindow(title: "Home"),
                );
              });
            },
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            polylines: _polylines,
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
        ],
      )),
    );
  }
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
