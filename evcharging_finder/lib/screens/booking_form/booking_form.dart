import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:evcharging_finder/models/user.dart';
import 'package:evcharging_finder/services/firebase_services.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class BookingForm extends StatefulWidget {
  final String stationName;
  final String latitude;
  final String longitude;
  final ValueChanged<String> onChanged;
  BookingForm({
    @required this.stationName,
    @required this.latitude,
    @required this.longitude,
    @required this.onChanged,
  });

  @override
  _BookingFormState createState() => _BookingFormState();
}

class _BookingFormState extends State<BookingForm> {
  TextEditingController _carPlate = TextEditingController();
  //TextEditingController _timing = TextEditingController();
  final db = FirebaseFirestore.instance;
  final _formkey = GlobalKey<FormState>();

  BookingUser customer = BookingUser();
  FirebaseFunctions firebaseFunctions = FirebaseFunctions();

  void initBookingUser(String dateTimeBooked) {
    customer.vehicleNumber = _carPlate.text;
    customer.timing = _timing;
    customer.station = widget.stationName;
    customer.latitude = widget.latitude;
    customer.longitude = widget.longitude;
    customer.dateTimeBooked = dateTimeBooked;
  }

  final List<String> time = [
    "00:00 - 01:00",
    "01:00 - 02:00",
    "02:00 - 03:00",
    "03:00 - 04:00",
    "04:00 - 05:00",
    "05:00 - 06:00",
    "06:00 - 07:00",
    "07:00 - 08:00",
    "08:00 - 09:00",
    "09:00 - 10:00",
    "10:00 - 11:00",
    "11:00 - 12:00",
    "12:00 - 13:00",
    "13:00 - 14:00",
    "14:00 - 15:00",
    "15:00 - 16:00",
    "16:00 - 17:00",
    "17:00 - 18:00",
    "18:00 - 19:00",
    "19:00 - 20:00",
    "20:00 - 21:00",
    "21:00 - 22:00",
    "22:00 - 23:00",
    "23:00 - 00:00"
  ];
  List<String> availTimes = [];

  @override
  void initState() {
    displayAvailTime();
    super.initState();
  }

  void displayAvailTime() {
    String timeNow = DateTime.now().hour.toString() + "00";
    if (timeNow.length == 3) {
      timeNow = "0" + timeNow;
    }
    int intTimeNow = int.parse(timeNow);
    for (int i = 0; i < time.length; i++) {
      String _timing = time[i].substring(0, 2) + time[i].substring(3, 5);
      FirebaseFirestore.instance
          .collection("stations")
          .doc(widget.stationName)
          .get()
          .then((result) {
        FirebaseFirestore.instance
            .collection("stations")
            .doc(widget.stationName)
            .collection("timeslots")
            .doc(_timing)
            .get()
            .then((result) {
          bool isAvailable =
              DateTime.parse(result.data()["dateTimeBooked"]).day ==
                      DateTime.now().day
                  ? false
                  : true;
          int dbTime = int.parse(result.data()["time"]);
          if (isAvailable && (dbTime >= intTimeNow)) {
            setState(() {
              availTimes.add(time[i]);
              availTimes.sort((a, b) {
                return a.compareTo(b);
              });
            });
          }
        });
      });
    }
  }

  String carPlate;
  String _timing;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formkey,
      child: Column(
        children: <Widget>[
          Text(
            "Book your Charging Lot",
            style: TextStyle(fontSize: 18.0),
          ),
          SizedBox(height: 20),
          TextFormField(
            controller: _carPlate,
            validator: (val) =>
                val.isEmpty ? "Please enter carplate number" : null,
            onChanged: (val) => setState(() => carPlate = val),
            decoration: InputDecoration(
              hintText: "Enter your car plate number",
              floatingLabelBehavior: FloatingLabelBehavior.always,
            ),
          ),
          SizedBox(height: 20),
          DropdownButtonFormField(
            items: availTimes.map((timing) {
              return DropdownMenuItem(
                value: timing,
                child: Text(timing),
              );
            }).toList(),
            onChanged: (val) => setState(() => _timing = val),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            child: Text(
              "Confirm Booking",
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () async {
              _timing = _timing.substring(0, 2) + _timing.substring(3, 5);
              FirebaseFirestore.instance
                  .collection("stations")
                  .doc(widget.stationName)
                  .get()
                  .then((result) {
                FirebaseFirestore.instance
                    .collection("stations")
                    .doc(widget.stationName)
                    .collection("timeslots")
                    .doc(_timing)
                    .get()
                    .then((result) {
                  bool available =
                      DateTime.parse(result.data()["dateTimeBooked"]).day ==
                              DateTime.now().day
                          ? false
                          : true;
                  if (available) {
                    FirebaseFirestore.instance
                        .collection("stations")
                        .doc(widget.stationName)
                        .get()
                        .then((result) {
                      FirebaseFirestore.instance
                          .collection("stations")
                          .doc(widget.stationName)
                          .collection("timeslots")
                          .doc(_timing)
                          .update({
                        "dateTimeBooked": DateTime.now().toString(),
                        "isAvailable": false,
                        "isPeak": false,
                        "time": _timing
                      });
                      widget.onChanged(widget.stationName);
                    });
                    Fluttertoast.showToast(
                      msg: "Booking Success!",
                      gravity: ToastGravity.CENTER,
                      timeInSecForIosWeb: 2,
                    );
                  } else {
                    Fluttertoast.showToast(
                      msg: "Booking Failed! Station Booked!",
                      gravity: ToastGravity.CENTER,
                      timeInSecForIosWeb: 2,
                    );
                  }
                });
              });
              initBookingUser(DateTime.now().toString());
              String isComplete =
                  await firebaseFunctions.uploadBookingInfo(customer.toMap());
              Navigator.pop(context);
              //print(_carPlate);
              //print(_timing);
            },
          )
        ],
      ),
    );
  }
}
