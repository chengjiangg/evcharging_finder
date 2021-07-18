import 'package:flutter/material.dart';
import 'package:evcharging_finder/models/booking.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:evcharging_finder/size_config.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:fluttertoast/fluttertoast.dart';

class BookingPage extends StatefulWidget {
  @override
  _BookingPageState createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  List<Booking> bookings = [];

  @override
  void initState() {
    getBookings();
    super.initState();
  }

  void getBookings() {
    User currentUser = FirebaseAuth.instance.currentUser;

    if (FirebaseAuth.instance.currentUser != null) {
      FirebaseFirestore.instance
          .collection("users")
          .doc(currentUser.uid)
          .get()
          .then((result) {
        FirebaseFirestore.instance
            .collection("users")
            .doc(currentUser.uid)
            .collection("booking_details")
            .get()
            .then((querySnapshot) {
          querySnapshot.docs.forEach((result) {
            Booking booking = new Booking(
                result.data()["station"],
                result.data()["vehicleNumber"],
                result.data()["timing"],
                LatLng(double.parse(result.data()["latitude"]),
                    double.parse(result.data()["longitude"])),
                DateTime.parse(result.data()["dateTimeBooked"]),
                result.id);
            setState(() {
              bookings.add(booking);
              bookings.sort((a, b) {
                return b.dateTimeBook.compareTo(a.dateTimeBook);
              });
            });
          });
        });
      });
    }
  }

  bool canCancel(DateTime dateTimeBooked, String timeslot) {
    DateTime dateTimeNow = DateTime.now();
    int timeNow = dateTimeNow.hour;
    int bookedTimeslot = int.parse(timeslot.substring(0, 2));
    DateTime dateNow =
        new DateTime(dateTimeNow.year, dateTimeNow.month, dateTimeNow.day);
    DateTime dateBooked = new DateTime(
        dateTimeBooked.year, dateTimeBooked.month, dateTimeBooked.day);
    if (dateNow.compareTo(dateBooked) == 0 && bookedTimeslot >= timeNow) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            color: Color(0xFFF5F5F5),
            child: ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: bookings.length,
              itemBuilder: (context, index) => Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Dismissible(
                  key: Key(bookings[index].bookingId),
                  direction: canCancel(bookings[index].dateTimeBook,
                          bookings[index].bookingTiming)
                      ? DismissDirection.endToStart
                      : DismissDirection.none,
                  onDismissed: (direction) async {
                    print(bookings[index].bookingId);
                    User currentUser = FirebaseAuth.instance.currentUser;
                    await FirebaseFirestore.instance
                        .collection("users")
                        .doc(currentUser.uid)
                        .get()
                        .then((result) {
                      FirebaseFirestore.instance
                          .collection("users")
                          .doc(currentUser.uid)
                          .collection("booking_details")
                          .doc(bookings[index].bookingId)
                          .delete()
                          .then((_) {
                        print("success!");
                      });
                    });
                    await FirebaseFirestore.instance
                        .collection("stations")
                        .doc(bookings[index].name)
                        .get()
                        .then((result) {
                      FirebaseFirestore.instance
                          .collection("stations")
                          .doc(bookings[index].name)
                          .collection("timeslots")
                          .doc(bookings[index].bookingTiming)
                          .update(
                              {"dateTimeBooked": "2021-01-01 00:00:00.000000"});
                    });
                    setState(() {
                      bookings.removeAt(index);
                    });
                    Fluttertoast.showToast(
                      msg: "Booking Canceled",
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
                  child: bookingCard(bookings[index]),
                ),
              ),
            )));
  }
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

Widget bookingCard(Booking booking) {
  String bookingSlotIntEnd =
      (int.parse(booking.bookingTiming.substring(0, 2)) + 1).toString() + "00";
  if (bookingSlotIntEnd.length == 3) {
    bookingSlotIntEnd = "0" + bookingSlotIntEnd;
  }
  String bookingSlot = booking.bookingTiming + " - " + bookingSlotIntEnd;
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
              child: Image.asset("assets/images/shell.png"),
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
                booking.name,
                style: TextStyle(color: Colors.black, fontSize: 15),
                maxLines: 2,
              ),
            ),
            SizedBox(height: 10),
            Container(width: 190.0, child: Text(bookingSlot)),
            SizedBox(height: 10),
            Container(
              width: 190.0,
              child: Text(booking.dateTimeBook.toString().substring(0, 19)),
            )
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
                      _launchMap(booking.center.latitude.toString(),
                          booking.center.longitude.toString());
                    },
                  ),
                ])),
        SizedBox(width: getProportionateScreenWidth(5.0)),
      ]));
}
