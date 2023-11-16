import 'dart:convert';
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:intl/intl.dart';
import 'package:resvago_vendor/controllers/add_product_controller.dart';
import '../helper.dart';
import '../model/signup_model.dart';
import '../screen/slot_screens/slot_list.dart';

class FirebaseService{
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseDatabase firebaseDatabase = FirebaseDatabase.instance;

  Future manageRegisterUsers({
    dynamic restaurantName,
    dynamic category,
    dynamic email,
    dynamic docid,
    dynamic mobileNumber,
    dynamic address,
    dynamic latitude,
    dynamic longitude,
    dynamic password,
    //dynamic confirmPassword,
    dynamic restaurant_position,
    dynamic image,
    dynamic userID,
    dynamic aboutUs,
    dynamic preparationTime,
    dynamic averageMealForMember,
    dynamic setDelivery,
    dynamic cancellation,
    dynamic menuSelection,
  }) async {
    try {
      CollectionReference collection = FirebaseFirestore.instance.collection('vendor_users');
      var documentReference = collection.doc(FirebaseAuth.instance.currentUser!.uid);
      documentReference.set({
        "restaurantName": restaurantName,
        "category": category,
        "email": email,
        "docid": docid,
        "mobileNumber": mobileNumber,
        "address": address,
        "latitude": latitude,
        "longitude": longitude,
        "password": password,
        //"confirmPassword": confirmPassword,
        "restaurant_position": restaurant_position,
        "image": image,
        "aboutUs": aboutUs,
        "preparationTime": preparationTime,
        "averageMealForMember": averageMealForMember,
        "setDelivery": setDelivery,
        "cancellation": cancellation,
        "menuSelection": menuSelection,
        "time": DateTime.now(),
        "userID": mobileNumber,
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
    dynamic maxDiscount,
    dynamic endDate,
    bool? deactivate,
    dynamic userID,
  }) async {
    try {
      FirebaseFirestore.instance.collection('Coupon_data').doc().set({
        "promoCodeName": promoCodeName,
        "code": code,
        "discount": discount,
        "maxDiscount": maxDiscount,
        "startDate": startDate,
        "endDate": endDate,
        "deactivate": false,
        "userID": FirebaseAuth.instance.currentUser!.phoneNumber,
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
    dynamic bookingForDining,
    dynamic bookingForDelivery,
    dynamic time,
    dynamic searchName,
  }) async {
    try {
      await FirebaseFirestore.instance.collection('vendor_menu').doc(menuId).set({
        "menuId": menuId,
        "vendorId": vendorId,
        "dishName": dishName,
        "category": category,
        "price": price,
        "docid": docid,
        "discount": discount,
        "description": description,
        "image": image,
        "bookingForDining": bookingForDining,
        "bookingForDelivery": bookingForDelivery,
        "searchName": searchName,
      });
      showToast("Menu Added Successfully");
    } catch (e) {
      throw Exception(e);
    }
  }

  Future manageSlot({
    required DateTime startDate,
    required DateTime? endDate,
    required String seats,
    required String setOffer,
    required List<String> morningSlots,
    required List<String> eveningSlots,
  }) async {
    try {
      Map<String, int> morningMapSlots = {};
      for (var element in morningSlots) {
        morningMapSlots[element] = int.tryParse(seats) ?? 0;
      }

      Map<String, int> eveningMapSlots = {};
      for (var element in eveningSlots) {
        eveningMapSlots[element] = int.tryParse(seats) ?? 0;
      }
      print({
        "slotId": startDate.toString(),
        "vendorId": FirebaseAuth.instance.currentUser!.phoneNumber,
        "slot_date": startDate.millisecondsSinceEpoch,
        "morning_slots": morningMapSlots,
        "evening_slots": eveningMapSlots,
        "noOfGuest": seats,
        "setOffer": setOffer,
        "created_time": DateTime.now().millisecondsSinceEpoch,
      });
      if(endDate == null){
        await FirebaseFirestore.instance
            .collection('vendor_slot')
            .doc(FirebaseAuth.instance.currentUser!.phoneNumber)
            .collection("slot")
            .doc(startDate.toString())
            .set({
          "slotId": startDate.toString(),
          "vendorId": FirebaseAuth.instance.currentUser!.phoneNumber,
          "slot_date": startDate.millisecondsSinceEpoch,
          "morning_slots": morningMapSlots,
          "evening_slots": eveningMapSlots,
          "noOfGuest": seats,
          "setOffer": setOffer,
          "created_time": DateTime.now().millisecondsSinceEpoch,
        });
        showToast("Slot Updated Successfully");
        return;
      }

      List<DateTime> slotsDate = [];

      while (startDate.isBefore(endDate.add(const Duration(days: 1)))) {
        slotsDate.add(startDate);
        startDate = startDate.add(const Duration(days: 1));
      }

      final batch = firestore.batch();
      for (var element in slotsDate) {
        batch.set(firestore.collection('vendor_slot')
            .doc(FirebaseAuth.instance.currentUser!.phoneNumber)
            .collection("slot")
            .doc(element.toString()), {
          "slotId": element.toString(),
          "vendorId": FirebaseAuth.instance.currentUser!.phoneNumber,
          "slot_date": element.millisecondsSinceEpoch,
          "morning_slots": morningMapSlots,
          "evening_slots": eveningMapSlots,
          "noOfGuest": seats,
          "setOffer": setOffer,
          "created_time": DateTime.now().millisecondsSinceEpoch,
        });
      }
      await batch.commit();
      showToast("Slot Added Successfully");
    } catch (e) {
      throw Exception(e);
    }
  }

// final controller = Get.put(AddProductController());

  Future manageStoreTime({
    dynamic storeTimeId,
    dynamic vendorId,
    dynamic weekDay,
    dynamic status,
    dynamic startTime,
    dynamic startDateForLunch,
    dynamic endTime,
    dynamic time,
  }) async {
    try {
      await FirebaseFirestore.instance.collection('vendor_storeTime').doc(FirebaseAuth.instance.currentUser!.phoneNumber).set({
        'status': status,
        'startTime': startTime,
        'endTime': endTime,
      });
      showToast("Store Set Time Added Successfully");
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

  updateFirebaseToken() async {
    try {
      String? fcm = await FirebaseMessaging.instance.getToken();
      final ref = firebaseDatabase.ref(
          "vendor_users/${FirebaseAuth.instance.currentUser!.phoneNumber.toString()}");
      await ref.update({
        fcm.toString(): fcm.toString()
      });
    } catch(e){
      throw Exception(e);
    }
  }

  sendNotifications(){
      log("message.....       ${"value.children.map((e) => e.value)"}");
      List<String> fcmTokenList = [];
    final ref = firebaseDatabase.ref("users/");
    ref.get().then((DataSnapshot value) {
      for (var element in value.children) {
          Map map = element.value as Map;
          for (var e in map.entries) {
            fcmTokenList.add(e.value);
          }

      }
      log("message.....       ${fcmTokenList}");
    }).catchError((e){

    });
  }

}
