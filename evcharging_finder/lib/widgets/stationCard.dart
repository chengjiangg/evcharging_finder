import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class StationCard extends StatefulWidget {
  final String name;
  final double distanceAway;
  final AssetImage providerPic;
  final DocumentSnapshot documentSnapshot;
  StationCard({
    @required this.name,
    @required this.distanceAway,
    @required this.providerPic,
    @required this.documentSnapshot,
  });

  @override
  _StationCardState createState() => _StationCardState();
}

class _StationCardState extends State<StationCard> {
  @override
  Widget build(BuildContext context) {
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
                        print("Pressed");
                      },
                    ),
                    /*
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
                            color: alreadySaved ? Colors.red : Colors.black)),*/
                  ]))
        ]));
  }
}
