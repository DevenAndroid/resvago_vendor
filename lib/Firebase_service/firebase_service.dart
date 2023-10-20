import 'dart:convert';
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
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
    dynamic aboutUs,
  }) async {
    try {
      CollectionReference collection = FirebaseFirestore.instance.collection('vendor_users');
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
        "aboutUs": aboutUs,
        "userID": "+91${mobileNumber}",
      });
    } catch (e) {
      throw Exception(e);
    }
  }

  Future manageCouponCode({
    dynamic promoCodeName,
    dynamic code,
    dynamic discount,
    dynamic startDate,
    dynamic endDate,
    bool? deactivate,
    dynamic userID,
  }) async {
    try {
      CollectionReference collection = FirebaseFirestore.instance.collection('Coupon_data');
      var DocumentReference = collection.doc(FirebaseAuth.instance.currentUser!.phoneNumber).collection('Coupon').doc();


      DocumentReference.set({
        "promoCodeName": promoCodeName,
        "code": code,
        "discount": discount,
        "startDate": startDate,
        "endDate": endDate,
        "deactivate" : false,
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
      await FirebaseFirestore.instance
          .collection('vendor_menu')
          .doc(FirebaseAuth.instance.currentUser!.phoneNumber)
          .collection("menus")
          .doc(menuId)
          .set({
        "menuId": menuId,
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

  // Future manageSlot({
  //   required String slotId,
  //   dynamic vendorId,
  //   dynamic lunchDuration,
  //   dynamic dinnerDuration,
  //   dynamic startDateForLunch,
  //   dynamic endDateForLunch,
  //   dynamic startTimeForLunch,
  //   dynamic endTimeForLunch,
  //   dynamic startDateForDinner,
  //   dynamic endDateForDinner,
  //   dynamic startTimeForDinner,
  //   dynamic endTimeForDinner,
  //   dynamic noOfGuest,
  //   dynamic setOffer,
  //   required List<String> slot,
  //   required List<String> dinnerSlot,
  //   dynamic time,
  // }) async {
  //   try {
  //     await FirebaseFirestore.instance
  //         .collection('vendor_slot')
  //         .doc("${FirebaseAuth.instance.currentUser!.phoneNumber}slots")
  //         .set({
  //       "slotId": slotId,
  //       "vendorId": vendorId,
  //       "startDateForLunch": startDateForLunch,
  //       "endDateForLunch": endDateForLunch,
  //       "startTimeForLunch": startTimeForLunch,
  //       "endTimeForLunch": endTimeForLunch,
  //       "startDateForDinner": startDateForDinner,
  //       "endDateForDinner": endDateForDinner,
  //       "startTimeForDinner": startTimeForDinner,
  //       "endTimeForDinner": endTimeForDinner,
  //       "lunchDuration": lunchDuration,
  //       "dinnerDuration": dinnerDuration,
  //       "noOfGuest": noOfGuest,
  //       "setOffer": setOffer,
  //       "slot": slot,
  //       "dinnerSlot": dinnerSlot,
  //       "time": time,
  //     });
  //     showToast("Slot Added Successfully");
  //   } catch (e) {
  //     throw Exception(e);
  //   }
  // }

  Future manageSlot({
    required String slotId,
    dynamic vendorId,
    dynamic lunchDuration,
    dynamic dinnerDuration,
    dynamic startDateForLunch,
    dynamic endDateForLunch,
    dynamic startTimeForLunch,
    dynamic endTimeForLunch,
    dynamic startDateForDinner,
    dynamic endDateForDinner,
    dynamic startTimeForDinner,
    dynamic endTimeForDinner,
    dynamic noOfGuest,
    dynamic setOffer,
    required RxString dateType,
    // dynamic slot,
    // dynamic dinnerSlot,
    dynamic time,
  }) async {
    try {
      await FirebaseFirestore.instance
          .collection('vendor_slot')
          .doc(FirebaseAuth.instance.currentUser!.phoneNumber)
          .collection("slot")
          .doc(slotId)
          .set({
        "slotId":slotId,
        "vendorId": vendorId,
        "startDateForLunch": startDateForLunch,
        "endDateForLunch": endDateForLunch,
        "startTimeForLunch": startTimeForLunch,
        "endTimeForLunch": endTimeForLunch,
        "startDateForDinner": startDateForDinner,
        "endDateForDinner": endDateForDinner,
        "startTimeForDinner": startTimeForDinner,
        "endTimeForDinner": endTimeForDinner,
        "lunchDuration": lunchDuration,
        "dinnerDuration": dinnerDuration,
        "noOfGuest": noOfGuest,
        "setOffer": setOffer,
        "dateType": dateType.value,
        // "slot": slot,
        // "dinnerSlot": dinnerSlot,
        "time": time,
      });
      showToast("Slot Added Successfully");
    } catch (e) {
      throw Exception(e);
    }
  }


  Future<RegisterData?> getUserInfo({required String uid}) async {
    RegisterData? vendorModel;
    DocumentSnapshot docSnap = await firestore.collection("vendor_users").doc(uid.trim()).get();
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
