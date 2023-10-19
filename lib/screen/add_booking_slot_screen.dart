import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:resvago_vendor/screen/slot.dart';
import '../Firebase_service/firebase_service.dart';
import '../controllers/slot_controller.dart';
import '../helper.dart';
import '../widget/addsize.dart';
import '../widget/apptheme.dart';
import '../widget/common_text_field.dart';
import '../widget/custom_textfield.dart';

class AddBookingSlot extends StatefulWidget {
  const AddBookingSlot({super.key});

  @override
  State<AddBookingSlot> createState() => _AddBookingSlotState();
}

class _AddBookingSlotState extends State<AddBookingSlot> {
  final slotController = Get.put(SlotController());
  final _formKeyBooking = GlobalKey<FormState>();
  TextEditingController selectDateController = TextEditingController();
  TextEditingController lunchStartTimeController = TextEditingController();
  TextEditingController lunchEndTimeController = TextEditingController();
  TextEditingController intervalTimeController = TextEditingController();
  TextEditingController dinnerStartTimeController = TextEditingController();
  TextEditingController dinnerEndTimeController = TextEditingController();
  TextEditingController intervalTimePasswordController1 = TextEditingController();
  TextEditingController numberOfGuestController = TextEditingController();
  TextEditingController setOffersController = TextEditingController();
  TimeOfDay? selectedTime;
  String? _hour;
  String? _minute;
  String? _time;
  Future<void> selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime!,
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            timePickerTheme: TimePickerTheme.of(context).copyWith(
              hourMinuteTextColor: Colors.black,
              hourMinuteColor: AppTheme.primaryColor,
              dayPeriodTextColor: Colors.black,
              dialHandColor: Colors.black,
              dialBackgroundColor: AppTheme.primaryColor,
              entryModeIconColor: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        selectedTime = picked;
        _hour = selectedTime!.hour.toString();
        _minute = selectedTime!.minute.toString();
        _time = '$_hour : $_minute';
        lunchStartTimeController.text = _time!;
        lunchStartTimeController.text = DateFormat('hh:mm a').format(DateTime(
          2019,
          8,
          1,
          selectedTime!.hour,
          selectedTime!.minute,
        ));
      });
    }
  }

  TimeOfDay? selectedLunchEndTime;
  String? _hourLunchEnd;
  String? _minuteLunchEnd;
  String? _timeLunchEnd;
  Future<void> selectTimeLunchEnd(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedLunchEndTime!,
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            timePickerTheme: TimePickerTheme.of(context).copyWith(
              hourMinuteTextColor: Colors.black,
              hourMinuteColor: AppTheme.primaryColor,
              dayPeriodTextColor: Colors.black,
              dialHandColor: Colors.black,
              dialBackgroundColor: AppTheme.primaryColor,
              entryModeIconColor: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        selectedLunchEndTime = picked;
        _hourLunchEnd = selectedTime!.hour.toString();
        _minuteLunchEnd = selectedTime!.minute.toString();
        _timeLunchEnd = '$_hourLunchEnd : $_minuteLunchEnd';
        lunchEndTimeController.text = _timeLunchEnd!;
        lunchEndTimeController.text = DateFormat('hh:mm a').format(DateTime(
          2019,
          8,
          1,
          selectedLunchEndTime!.hour,
          selectedLunchEndTime!.minute,
        ));
      });
    }
  }

  TimeOfDay? selectedTimeInterval;
  String? _hourInterval;
  String? _minuteInterval;
  String? _timeInterval;
  Future<void> selectTimeInterval(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTimeInterval!,
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            timePickerTheme: TimePickerTheme.of(context).copyWith(
              hourMinuteTextColor: Colors.black,
              hourMinuteColor: AppTheme.primaryColor,
              dayPeriodTextColor: Colors.black,
              dialHandColor: Colors.black,
              dialBackgroundColor: AppTheme.primaryColor,
              entryModeIconColor: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        selectedTimeInterval = picked;
        _hourInterval = selectedTime!.hour.toString();
        _minuteInterval = selectedTime!.minute.toString();
        _timeInterval = '$_hourInterval : $_minuteInterval';
        intervalTimeController.text = _timeInterval!;
        intervalTimeController.text = DateFormat('hh:mm a').format(DateTime(
          2019,
          8,
          1,
          selectedTimeInterval!.hour,
          selectedTimeInterval!.minute,
        ));
      });
    }
  }

  TimeOfDay? selectedTimeDinnerStart;
  String? _hourDinnerStart;
  String? _minuteDinnerStart;
  String? _timeDinnerStart;
  Future<void> selectTimeDinnerStart(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTimeDinnerStart!,
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            timePickerTheme: TimePickerTheme.of(context).copyWith(
              hourMinuteTextColor: Colors.black,
              hourMinuteColor: AppTheme.primaryColor,
              dayPeriodTextColor: Colors.black,
              dialHandColor: Colors.black,
              dialBackgroundColor: AppTheme.primaryColor,
              entryModeIconColor: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        selectedTimeDinnerStart = picked;
        _hourDinnerStart = selectedTime!.hour.toString();
        _minuteDinnerStart = selectedTime!.minute.toString();
        _timeDinnerStart = '$_hourDinnerStart : $_minuteDinnerStart';
        dinnerStartTimeController.text = _timeDinnerStart!;
        dinnerStartTimeController.text = DateFormat('hh:mm a').format(DateTime(
          2019,
          8,
          1,
          selectedTimeDinnerStart!.hour,
          selectedTimeDinnerStart!.minute,
        ));
      });
    }
  }

  TimeOfDay? selectedTimeDinnerEnd;
  String? _hourDinnerEnd;
  String? _minutDinnerEnd;
  String? _timeDinnerEnd;
  Future<void> selectTimeDinnerEnd(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTimeDinnerEnd!,
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            timePickerTheme: TimePickerTheme.of(context).copyWith(
              hourMinuteTextColor: Colors.black,
              hourMinuteColor: AppTheme.primaryColor,
              dayPeriodTextColor: Colors.black,
              dialHandColor: Colors.black,
              dialBackgroundColor: AppTheme.primaryColor,
              entryModeIconColor: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        selectedTimeDinnerEnd = picked;
        _hourDinnerEnd = selectedTime!.hour.toString();
        _minutDinnerEnd = selectedTime!.minute.toString();
        _timeDinnerEnd = '$_hourDinnerEnd : $_minutDinnerEnd';
        dinnerEndTimeController.text = _timeDinnerEnd!;
        dinnerEndTimeController.text = DateFormat('hh:mm a').format(DateTime(
          2019,
          8,
          1,
          selectedTimeDinnerEnd!.hour,
          selectedTimeDinnerEnd!.minute,
        ));
      });
    }
  }

  TimeOfDay? selectedTimeDinnerInterval;
  String? _hourDinnerInterval;
  String? _minuteDinnerInterval;
  String? _timeDinnerInterval;
  Future<void> selectTimeDinnerInterval(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTimeDinnerInterval!,
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            timePickerTheme: TimePickerTheme.of(context).copyWith(
              hourMinuteTextColor: Colors.black,
              hourMinuteColor: AppTheme.primaryColor,
              dayPeriodTextColor: Colors.black,
              dialHandColor: Colors.black,
              dialBackgroundColor: AppTheme.primaryColor,
              entryModeIconColor: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        selectedTimeDinnerInterval = picked;
        _hourDinnerInterval = selectedTimeDinnerInterval!.hour.toString();
        _minuteDinnerInterval = selectedTimeDinnerInterval!.minute.toString();
        _timeDinnerInterval = '$_hourDinnerInterval : $_minuteDinnerInterval';
        intervalTimePasswordController1.text = _timeDinnerInterval!;
        intervalTimePasswordController1.text = DateFormat('hh:mm a').format(DateTime(
          2019,
          8,
          1,
          selectedTimeDinnerInterval!.hour,
          selectedTimeDinnerInterval!.minute,
        ));
      });
    }
  }

  @override
  void initState() {
    super.initState();
    selectedTimeDinnerInterval = TimeOfDay.now();
    selectedTimeDinnerEnd = TimeOfDay.now();
    selectedTimeInterval = TimeOfDay.now();
    selectedLunchEndTime = TimeOfDay.now();
    selectedTime = TimeOfDay.now();
    selectedTimeDinnerStart = TimeOfDay.now();
  }

  FirebaseService firebaseService = FirebaseService();
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  bool isDescendingOrder = true;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  Future<void> addSlotToFirestore() async {
    OverlayEntry loader = Helper.overlayLoader(context);
    Overlay.of(context).insert(loader);
    try {
      await firebaseService.manageSlot(
        slotId:DateTime.now().millisecondsSinceEpoch.toString(),
        time: DateTime.now().millisecondsSinceEpoch,
        slot: slotController.timeslots,
        dinnerSlot: slotController.dinnerTimeslots,
        startDateForLunch: slotController.startDate.text,
        endDateForLunch: slotController.endDate.text,
        startTimeForLunch: slotController.startTime.text,
        endTimeForLunch: slotController.endTime.text,
        startDateForDinner: slotController.dinnerStartDate.text,
        endDateForDinner: slotController.dinnerEndDate.text,
        startTimeForDinner: slotController.dinnerStartTime.text,
        endTimeForDinner: slotController.dinnerEndTime.text,
        dinnerDuration: slotController.dinnerServiceDuration.text,
        lunchDuration: slotController.serviceDuration.text,
        vendorId: FirebaseAuth.instance.currentUser!.phoneNumber,
        noOfGuest: slotController.noOfGuest.text,
        setOffer: slotController.setOffer.text
      ).then((value) {
        Get.back();
        Helper.hideLoader(loader);
      });
    }
    catch (e) {
      Helper.hideLoader(loader);
      showToast(e.toString());
      log(e.toString());
      throw Exception(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: const Color(0xFFF6F6F6),
        appBar: backAppBar(title: "Create Slot", context: context, backgroundColor: Colors.white),
        body: Theme(
          data: ThemeData(useMaterial3: true),
          child: SingleChildScrollView(
              child: Form(
                  key: _formKeyBooking,
                  child: Column(children: [
                    const SizedBox(
                      height: 8,
                    ),
                    BookableUI(title:"Lunch"),
                    BookableUI(title:"Dinner"),
                    const SizedBox(
                      height: 30,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: AddSize.padding16, vertical: AddSize.padding10).copyWith(bottom: 30),
                      child: CommonButtonBlue(
                        onPressed: () {
                          if (_formKeyBooking.currentState!.validate()) {
                            slotController.getLunchTimeSlot();
                            slotController.getDinnerTimeSlot();
                            if(slotController.timeslots.isNotEmpty && slotController.dinnerTimeslots.isNotEmpty){
                              addSlotToFirestore();
                            }
                          }
                        },
                        title: 'Create Slot'.toUpperCase(),
                      ),
                    ),
                  ]))),
        ));
  }
}
