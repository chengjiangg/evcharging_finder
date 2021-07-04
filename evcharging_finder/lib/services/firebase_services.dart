import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:evcharging_finder/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/widgets.dart';

class FirebaseFunctions {
  final CollectionReference collectionReference =
      FirebaseFirestore.instance.collection("users");

  Future<String> uploadUserData(Map<String, dynamic> data) async {
    String isUploaded;

    User currentUser = FirebaseAuth.instance.currentUser;

    await collectionReference
        .doc(currentUser.uid)
        .set(data)
        .then((_) => isUploaded = 'true')
        .catchError((e) => isUploaded = e.message);

    return isUploaded;
  }

  Future<bool> hasUserCompletedProfile() async {
    CollectionReference collectionReference =
        FirebaseFirestore.instance.collection('users');

    User currentUser = FirebaseAuth.instance.currentUser;

    bool isComplete = false;
    await collectionReference.doc(currentUser.uid).get().then((docSnap) =>
        isComplete = AppUser.fromMap(docSnap.data()).hasCompleteProfile);
    print('iscomplete');
    print(isComplete);

    return isComplete;
  }

  // upload booking information
  Future<String> uploadBookingInfo(Map<String, dynamic> data) async {
    String isRegistered;
    User currentUser = FirebaseAuth.instance.currentUser;
    CollectionReference collectionReference = FirebaseFirestore.instance
        .collection('users/${currentUser.uid}/booking_details');

    await collectionReference
        .add(data)
        .then((_) => isRegistered = 'true')
        .catchError((e) => isRegistered = e.message);
    print(isRegistered);
    return isRegistered;
  }

  // Get data from firestore
  final uid = FirebaseAuth.instance.currentUser.uid;

  Future<AppUser> getUser() async {
    final userDoc = await collectionReference.doc(uid).get();

    if (userDoc.exists) {
      final userData = userDoc.data();

      final decodedData = AppUser.fromMap(userData);

      return decodedData;
    }
  }

  Future<BookingUser> getBooking(String key) async {
    CollectionReference collectionReference =
        FirebaseFirestore.instance.collection('users/$key/booking_details');
    final ownerDoc = await collectionReference.doc(key).get();
    // print('USer id:: ');
    // print(ownerDoc);

    if (ownerDoc.exists) {
      final ownerData = ownerDoc.data();
      // print('Owner Data :: ');
      // print(ownerData);
      final decodedData = BookingUser.fromMap(ownerData);
      // print(decodedData);
      return decodedData;
    }
  }
}
