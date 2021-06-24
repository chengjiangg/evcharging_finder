import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:evcharging_finder/screens/booking_form/booking_form.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:fluttertoast/fluttertoast.dart';

class StationCard extends StatefulWidget {
  final String name;
  final double distanceAway;
  final AssetImage providerPic;
  final DocumentSnapshot documentSnapshot;
  final ValueChanged<String> onChanged;
  final bool alreadySaved;
  final String latitude;
  final String longitude;
  StationCard({
    @required this.name,
    @required this.distanceAway,
    @required this.providerPic,
    @required this.documentSnapshot,
    @required this.onChanged,
    @required this.latitude,
    @required this.longitude,
    this.alreadySaved: false,
  });

  @override
  _StationCardState createState() => _StationCardState();
}

class _StationCardState extends State<StationCard> {
  bool isSaved;

  @override
  void initState() {
    isSaved = widget.alreadySaved;
    super.initState();
  }

  void _handleTap() {
    widget.onChanged(widget.name);
    setState(() {
      isSaved = !isSaved;
    });
    if (isSaved) {
      Fluttertoast.showToast(
        msg: "Station Added",
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 2,
      );
    } else {
      Fluttertoast.showToast(
        msg: "Station Removed",
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 2,
      );
    }
  }

  _launchMap() async {
    String lat = widget.latitude;
    String lng = widget.longitude;
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

  @override
  Widget build(BuildContext context) {
    void _showBookingPanel() {
      showModalBottomSheet(
          context: context,
          builder: (context) {
            return Container(
                padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 60.0),
                child: BookingForm());
          });
    }

    return Container(
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.only(right: 20),
        width: 200.0,
        height: 250.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          color: Colors.white,
        ),
        child: Column(children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(top: 5),
                child: CircleAvatar(
                  backgroundImage: widget.providerPic,
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
                    Flexible(
                        child: new Container(
                            child: new Text(widget.name,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(fontWeight: FontWeight.bold))))
                  ])),
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
              children: <Widget>[Text(widget.distanceAway.toString() + " km")],
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
                        _launchMap();
                      },
                    ),
                    ElevatedButton(
                      child: FaIcon(FontAwesomeIcons.ticketAlt),
                      style: ElevatedButton.styleFrom(
                        primary: Color(0xFFF9A825),
                      ),
                      onPressed: () {
                        _showBookingPanel();
                      },
                    ),
                    GestureDetector(
                        onTap: _handleTap,
                        child: FaIcon(
                            isSaved
                                ? FontAwesomeIcons.solidHeart
                                : FontAwesomeIcons.heart,
                            color: isSaved ? Colors.red : Colors.black)),
                  ]))
        ]));
  }
}
