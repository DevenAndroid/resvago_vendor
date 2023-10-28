import 'dart:convert';
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:resvago_vendor/model/set_store_time_model.dart';

class VendorStoreTimingController extends GetxController {
  StoreTimeData modelStoreAvailability = StoreTimeData();
  RxInt refreshInt = 0.obs;

  // getTime() {
  //   repositories.getApi(url: ApiUrls.storeTimingUrl).then((value) {
  //     modelStoreAvailability = ModelStoreAvailability.fromJson(jsonDecode(value));
  //     if (modelStoreAvailability.data == null || modelStoreAvailability.data!.isEmpty) {
  //       modelStoreAvailability.data!.addAll([
  //         StoreTimeData(endTime: "19:00", startTime: "09:00", weekDay: "Mon", status: false),
  //         StoreTimeData(endTime: "19:00", startTime: "09:00", weekDay: "Tue", status: false),
  //         StoreTimeData(endTime: "19:00", startTime: "09:00", weekDay: "Wed", status: false),
  //         StoreTimeData(endTime: "19:00", startTime: "09:00", weekDay: "Thu", status: false),
  //         StoreTimeData(endTime: "19:00", startTime: "09:00", weekDay: "Fri", status: false),
  //         StoreTimeData(endTime: "19:00", startTime: "09:00", weekDay: "Sat", status: false),
  //         StoreTimeData(endTime: "19:00", startTime: "09:00", weekDay: "Sun", status: false),
  //       ]);
  //     }
  //     refreshInt.value = DateTime.now().millisecondsSinceEpoch;
  //   });
  // }

  List<StoreTimeData>? storeTimeList;
  getStoreTime() {
    FirebaseFirestore.instance
        .collection("vendor_storeTime")
        .doc(FirebaseAuth.instance.currentUser!.phoneNumber)
        .collection("store_time")
        .get()
        .then((value) {
      for (var element in value.docs) {
        var gg = element.data();
        log("Slot$gg");
        storeTimeList ??= [];
        storeTimeList!.addAll([
          StoreTimeData(endTime: "19:00", startTime: "09:00", weekDay: "Mon", status: false),
          StoreTimeData(endTime: "19:00", startTime: "09:00", weekDay: "Tue", status: false),
          StoreTimeData(endTime: "19:00", startTime: "09:00", weekDay: "Wed", status: false),
          StoreTimeData(endTime: "19:00", startTime: "09:00", weekDay: "Thu", status: false),
          StoreTimeData(endTime: "19:00", startTime: "09:00", weekDay: "Fri", status: false),
          StoreTimeData(endTime: "19:00", startTime: "09:00", weekDay: "Sat", status: false),
          StoreTimeData(endTime: "19:00", startTime: "09:00", weekDay: "Sun", status: false),
        ]);
      }
    });
  }

  @override
  void onInit() {
    super.onInit();
  }
}
