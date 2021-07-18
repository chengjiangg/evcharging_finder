import 'package:google_maps_flutter/google_maps_flutter.dart';

class Booking {
  String name;
  String vehicleNumber;
  String bookingTiming;
  LatLng center;
  DateTime dateTimeBook;
  String bookingId;

  Booking(this.name, this.vehicleNumber, this.bookingTiming, this.center,
      this.dateTimeBook, this.bookingId);
}
