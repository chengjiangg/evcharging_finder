class AppUser {
  String firstName;
  String lastName;
  String phoneNumber;
  String address;
  String emailID;
  // String dpURL;
  bool hasCompleteProfile = false;
  String uuid;

  AppUser();

  Map<String, dynamic> toMap() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'phoneNumber': phoneNumber,
      // 'dpURL': dpURL,
      'hasCompletedProfile': hasCompleteProfile,
      'emailID': emailID,
    };
  }

  AppUser.fromMap(Map<String, dynamic> data) {
    firstName = data['firstName'];
    lastName = data['lastName'];
    phoneNumber = data['phoneNumber'];
    // dpURL = data['dpURL'];
    hasCompleteProfile = data['hasCompleteProfile'];
    emailID = data['emailID'];
  }
}

class BookingUser {
  String vehicleNumber;
  String timing;
  String station;
  String latitude;
  String longitude;
  String dateTimeBooked;

  BookingUser();

  Map<String, dynamic> toMap() {
    return {
      "vehicleNumber": vehicleNumber,
      "timing": timing,
      "station": station,
      "latitude": latitude,
      "longitude": longitude,
      "dateTimeBooked": dateTimeBooked,
    };
  }

  BookingUser.fromMap(Map<String, dynamic> data) {
    vehicleNumber = data["vehicleNumber"];
    timing = data["timing"];
  }
}
