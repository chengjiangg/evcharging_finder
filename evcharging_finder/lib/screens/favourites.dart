import 'package:flutter/material.dart';
import 'package:evcharging_finder/models/station.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Favourites extends StatefulWidget {
  @override
  _FavouritesState createState() => _FavouritesState();
}

class _FavouritesState extends State<Favourites> {
  List<Station> stations = getStations();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new AppBar(
          title: new Text("Favourites"),
        ),
        body: Container(
          child: ListView.builder(
            itemCount: stations.length,
            itemBuilder: (context, index) => Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Dismissible(
                key: Key(stations[index].name),
                onDismissed: (direction) {
                  setState(() {
                    stations.removeAt(index);
                  });
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
                child: favoriteCard(stations[index]),
              ),
            ),
          ),
        ));
  }
}

Widget favoriteCard(Station station) {
  return Container(
      color: Colors.white,
      child: Row(children: [
        SizedBox(width: 8.0),
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
              child: Image.asset(station.imageURL),
            ),
          ),
        ),
        SizedBox(width: 20),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 190.0,
              child: Text(
                station.name,
                style: TextStyle(color: Colors.black, fontSize: 15),
                maxLines: 2,
              ),
            ),
            SizedBox(height: 10),
            Container(
                width: 190.0,
                child: Text.rich(TextSpan(
                    text: "Available",
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Color(0xFFB2FF59)))))
          ],
        ),
        SizedBox(width: 20),
        Container(
            alignment: Alignment.centerRight,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  ElevatedButton(
                    child: FaIcon(FontAwesomeIcons.directions),
                    style: ElevatedButton.styleFrom(
                      primary: Color(0xFF3EBACE),
                      minimumSize: Size(100, 40),
                    ),
                    onPressed: () {
                      print('Pressed');
                    },
                  ),
                  ElevatedButton(
                      child: FaIcon(FontAwesomeIcons.ticketAlt),
                      style: ElevatedButton.styleFrom(
                        primary: Color(0xFFF9A825),
                        minimumSize: Size(100, 40),
                      ),
                      onPressed: () {
                        print('Pressed');
                      }),
                ])),
      ]));
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
