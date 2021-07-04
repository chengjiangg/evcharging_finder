import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Station {
  String name;
  String address;
  LatLng center;
  bool isAvailable;
  AssetImage providerPic;
  String imageURL;

  Station(this.name, this.address, this.center, this.isAvailable,
      this.providerPic, this.imageURL);
}
