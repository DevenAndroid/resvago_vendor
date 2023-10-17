import 'dart:convert';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import '../model/signup_model.dart';

class FirebaseService {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future manageRegisterUsers({
    dynamic restaurantName,
    dynamic category,
    dynamic email,
    dynamic docid,
    dynamic mobileNumber,
    dynamic address,
    dynamic password,
    dynamic confirmPassword,
    dynamic image,
    dynamic userID,
  }) async {
    try {
      CollectionReference collection =
          FirebaseFirestore.instance.collection('vendor_users');
      var DocumentReference = collection.doc();
      String documentId = DocumentReference.id;

      DocumentReference.set({
        "restaurantName": restaurantName,
        "category": category,
        "email": email,
        "docid": docid,
        "mobileNumber": mobileNumber,
        "address": address,
        "password": password,
        "confirmPassword": confirmPassword,
        "image": image,
        "userID": documentId,
      });
    } catch (e) {
      throw Exception(e);
    }
  }

  Future manageMenu(
      {dynamic dishName,
      dynamic category,
      dynamic price,
      dynamic docid,
      dynamic discount,
      dynamic description,
      dynamic image,
      required booking}) async {
    try {
      await FirebaseFirestore.instance.collection('vendor_menu').add({
        "dishName": dishName,
        "category": category,
        "price": price,
        "docid": docid,
        "discount": discount,
        "description": description,
        "image": image,
        "booking": booking
      });
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<RegisterData?> getUserInfo({required String uid}) async {
    RegisterData? vendorModel;
    DocumentSnapshot docSnap =
        await firestore.collection("vendor_users").doc(uid.trim()).get();
    if (kDebugMode) {
      if (kDebugMode) print(docSnap.exists);
    }
    if (docSnap.data() != null) {
      vendorModel =
          RegisterData.fromMap(docSnap.data() as Map<String, dynamic>);
      log(jsonEncode(docSnap.data()));
    }
    return vendorModel;
  }
}
