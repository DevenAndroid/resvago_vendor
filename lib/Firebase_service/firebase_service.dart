
import 'dart:convert';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import '../model/signup_model.dart';

class FirebaseService {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future manageCategoryProduct({
    required DocumentReference documentReference,
    dynamic restaurantName,
    dynamic category,
    dynamic email,
    dynamic docid,
    dynamic mobileNumber,
    dynamic address,
    dynamic password,
    dynamic confirmPassword,
    dynamic image,
  }) async {
    try {
        await documentReference.set({
          "restaurantName": restaurantName,
          "category": category,
          "email": email,
          "docid": docid,
          "mobileNumber": mobileNumber,
          "address": address,
          "password": password,
          "confirmPassword": confirmPassword,
          "image": image,
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
      vendorModel = RegisterData.fromMap(docSnap.data() as Map<String, dynamic>);
      log(jsonEncode(docSnap.data()));
    }
    return vendorModel;
  }
}
