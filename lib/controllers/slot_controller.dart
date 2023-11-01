import 'dart:convert';
import 'dart:developer';
import 'dart:ffi';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../helper.dart';
import '../model/createslot_model.dart';
import '../model/slot_model.dart';

class SlotController extends GetxController {
  List<CreateSlotData>? slotDataList = [];
  List<String> productDuration = [];
  RxInt refreshInt = 0.obs;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController startTime = TextEditingController();
  final TextEditingController endTime = TextEditingController();
  final TextEditingController serviceDuration = TextEditingController();
  final TextEditingController startDate = TextEditingController();
  final TextEditingController endDate = TextEditingController();
  DateTime? selectedStartDateTime;
  DateTime? selectedEndDateTIme;
  Map<Map<DateTime, DateTime>, bool> slots = {};
  RxString dateType = "date".obs;
  final DateFormat timeFormatWithoutAMPM = DateFormat("hh:mm");
  List<ServiceTimeSloat> serviceTimeSloat = [];
  bool resetSlots = false;
  // resetValues(){
  //   startTime.text = "";
  //   endTime.text = "";
  //   serviceDuration.text = "";
  //   startDate.text = "";
  //   endDate.text = "";
  // }

  List<String> timeslots = [];
  getLunchTimeSlot(){
    if (serviceTimeSloat.isNotEmpty && resetSlots == false) {
      timeslots = serviceTimeSloat
          .map((e) => "${convertToTime(e.timeSloat.toString())},${convertToTime(e.timeSloatEnd.toString())}")
          .toList();
    } else if (slots.isNotEmpty) {
      timeslots = slots.entries
          .where((element) => element.value == true)
          .map((e) =>
      "${timeFormatWithoutAMPM.format(e.key.keys.first)},${timeFormatWithoutAMPM.format(e.key.values.first)}")
          .toList();
    }
  }

  final GlobalKey<FormState> formKey1 = GlobalKey<FormState>();
  final TextEditingController dinnerStartTime = TextEditingController();
  final TextEditingController dinnerEndTime = TextEditingController();
  final TextEditingController dinnerServiceDuration = TextEditingController();
  final TextEditingController dinnerStartDate = TextEditingController();
  final TextEditingController dinnerEndDate = TextEditingController();
  final TextEditingController noOfGuest = TextEditingController();
  final TextEditingController setOffer = TextEditingController();
  DateTime? dinnerSelectedStartDateTime;
  DateTime? dinnerSelectedEndDateTIme;
  Map<Map<DateTime, DateTime>, bool> dinnerSlots = {};
  // RxString dinnerDateType = "date".obs;
  final DateFormat dinnerTimeFormatWithoutAMPM = DateFormat("hh:mm");
  List<ServiceTimeSloat> dinnerServiceTimeSloat = [];
  bool dinnerResetSlots = false;
  // dinnerResetValues(){
  //   dinnerStartTime.text = "";
  //   dinnerEndTime.text = "";
  //   dinnerServiceDuration.text = "";
  //   dinnerStartDate.text = "";
  //   dinnerEndDate.text = "";
  // }
  String convertToTime(String gg) {
    return "${gg.split(":")[0]}:${gg.split(":")[1]}";
  }

  void get updateUI => refreshInt.value = DateTime.now().millisecondsSinceEpoch;

  List<String> dinnerTimeslots = [];
  getDinnerTimeSlot(){
    if (dinnerServiceTimeSloat.isNotEmpty && dinnerResetSlots == false) {
      dinnerTimeslots = dinnerServiceTimeSloat
          .map((e) => "${convertToTime(e.timeSloat.toString())},${convertToTime(e.timeSloatEnd.toString())}")
          .toList();
    } else if (dinnerSlots.isNotEmpty) {
      dinnerTimeslots = dinnerSlots.entries
          .where((element) => element.value == true)
          .map((e) =>
      "${timeFormatWithoutAMPM.format(e.key.keys.first)},${timeFormatWithoutAMPM.format(e.key.values.first)}")
          .toList();
    }
  }


  @override
  void onInit() {
    super.onInit();
    productDuration.clear();
    productDuration.add("none");
    for(var i = 0; i < 100; i++){
      productDuration.add((i+1).toString());
    }
  }
}
