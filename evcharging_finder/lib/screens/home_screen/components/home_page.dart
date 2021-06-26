import 'dart:async';
import 'dart:math' show cos, sqrt, asin;
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:evcharging_finder/models/station.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:evcharging_finder/screens/home_screen/components/stationCard.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:location/location.dart';
import 'package:evcharging_finder/size_config.dart';

const LatLng SOURCE_LOCATION = LatLng(1.2984665333700876, 103.77618826160976);

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  Completer<GoogleMapController> _controller = Completer();

  //Markers
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  BitmapDescriptor sourceIcon;

  //Draw routes on map
  Set<Polyline> _polylines = Set<Polyline>();
  List<LatLng> polylineCoordinates = [];
  PolylinePoints polylinePoints;

  //User's inital location and current location as it moves
  LocationData currentLocation;
  Location location;
  LatLng _center;

  @override
  void initState() {
    super.initState();
    location = new Location();
    location.onLocationChanged.listen((LocationData _currentLocation) {
      print("${_currentLocation.latitude} : ${_currentLocation.longitude}");
      currentLocation = _currentLocation;
      _center = LatLng(currentLocation.latitude, currentLocation.longitude);
      //updatePinOnMap();
    });
    setInitialLocation();
    populateStations();
    polylinePoints = PolylinePoints();
  }

  void setInitialLocation() async {
    currentLocation = await location.getLocation();
    CameraPosition cPosition = CameraPosition(
      zoom: 13.0,
      target: LatLng(currentLocation.latitude, currentLocation.longitude),
    );

    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(cPosition));
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
          showModalBottomSheet(
              context: context,
              backgroundColor: Colors.white,
              builder: (BuildContext context) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    StationCard(
                      documentSnapshot: querySnapshot,
                      name: station.name,
                      distanceAway:
                          double.parse((totalDistance).toStringAsFixed(2)),
                      providerPic: station.providerPic,
                      alreadySaved: alreadySaved,
                      latitude: station.center.latitude.toString(),
                      longitude: station.center.longitude.toString(),
                      onChanged: _handleTapboxChanged,
                    ),
                  ],
                );
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
    CameraPosition initialCPosition;
    if (currentLocation != null) {
      initialCPosition = CameraPosition(
        zoom: 13.0,
        target: LatLng(currentLocation.latitude, currentLocation.longitude),
      );
    } else {
      initialCPosition = CameraPosition(
        zoom: 13.0,
        target: SOURCE_LOCATION,
      );
    }
    return MaterialApp(
      home: Scaffold(
          body: Stack(
        children: <Widget>[
          GoogleMap(
              initialCameraPosition: initialCPosition,
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
                controller.animateCamera(
                    CameraUpdate.newCameraPosition(initialCPosition));
              },
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              polylines: _polylines,
              markers: Set<Marker>.of(markers.values),
              zoomGesturesEnabled: true,
              scrollGesturesEnabled: true,
              gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>[
                new Factory<OneSequenceGestureRecognizer>(
                  () => new EagerGestureRecognizer(),
                ),
              ].toSet()),
          Container(
            margin: EdgeInsets.only(bottom: getProportionateScreenHeight(500)),
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

  void updatePinOnMap() async {
    //Create a new CameraPosition instance everytime location changes
    CameraPosition cPosition = CameraPosition(
      zoom: 13.0,
      target: LatLng(currentLocation.latitude, currentLocation.longitude),
    );

    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(cPosition));
  }
}
