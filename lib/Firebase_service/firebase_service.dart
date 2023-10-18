import 'dart:convert';
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:resvago_vendor/screen/user_profile.dart';
import '../helper.dart';
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
      var DocumentReference = collection.doc("+91${mobileNumber}");

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
        "userID": "+91${mobileNumber}",
      });

    } catch (e) {
      throw Exception(e);
    }
  }

  Future manageMenu({
    required String menuId,
    dynamic vendorId,
    dynamic dishName,
    dynamic category,
    dynamic price,
    dynamic docid,
    dynamic discount,
    dynamic description,
    dynamic image,
    dynamic booking,
    dynamic time,
    dynamic searchName,
  }) async {
    try {
      await FirebaseFirestore.instance.collection('vendor_menu').doc(FirebaseAuth.instance.currentUser!.phoneNumber).collection("menus").doc(menuId).set({
        "menuId":menuId,
        "vendorId": vendorId,
        "dishName": dishName,
        "category": category,
        "price": price,
        "docid": docid,
        "discount": discount,
        "description": description,
        "image": image,
        "booking": booking,
        "searchName": searchName,
      });
      showToast("Menu Added Successfully");
    } catch (e) {
      throw Exception(e);
    }
  }


  Future manageSlot({
    required String slotId,
    dynamic vendorId,
    dynamic dishName,
    dynamic category,
    dynamic price,
    dynamic docid,
    dynamic discount,
    dynamic description,
    dynamic image,
    dynamic booking,
    dynamic time,
    dynamic searchName,
  }) async {
    try {
      await FirebaseFirestore.instance.collection('vendor_slot').doc(FirebaseAuth.instance.currentUser!.phoneNumber).collection("slot").doc(slotId).set({
        "menuId":slotId,
        "vendorId": vendorId,
        "dishName": dishName,
        "category": category,
        "price": price,
        "docid": docid,
        "discount": discount,
        "description": description,
        "image": image,
        "booking": booking,
        "searchName": searchName,
      });
      showToast("Menu Added Successfully");
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
