import 'package:flutter/material.dart';

class BookingForm extends StatefulWidget {
  @override
  _BookingFormState createState() => _BookingFormState();
}

class _BookingFormState extends State<BookingForm> {
  final _formkey = GlobalKey<FormState>();
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

  String _carPlate;
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
            validator: (val) =>
                val.isEmpty ? "Please enter carplate number" : null,
            onChanged: (val) => setState(() => _carPlate = val),
            decoration: InputDecoration(
              hintText: "Enter your car plate number",
              floatingLabelBehavior: FloatingLabelBehavior.always,
            ),
          ),
          SizedBox(height: 20),
          DropdownButtonFormField(
            items: time.map((timing) {
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
              print(_carPlate);
              print(_timing);
            },
          )
        ],
      ),
    );
  }
}
