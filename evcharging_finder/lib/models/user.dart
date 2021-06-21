class AppUser {
  String firstName;
  String lastName;
  String phoneNumber;
  String address;
  // String dpURL;
  bool hasCompleteProfile = false;

  AppUser();

  Map<String, dynamic> toMap() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'phoneNumber': phoneNumber,
      'address': address,
      // 'dpURL': dpURL,
      'hasCompletedProfile': hasCompleteProfile,
    };
  }

  AppUser.fromMap(Map<String, dynamic> data) {
    firstName = data['firstName'];
    lastName = data['lastName'];
    phoneNumber = data['phoneNumber'];
    address = data['address'];
    // dpURL = data['dpURL'];
    hasCompleteProfile = data['hasCompleteProfile'];
  }
}
