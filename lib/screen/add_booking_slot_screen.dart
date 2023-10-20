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
  final String slotId;
  const AddBookingSlot({super.key, required this.slotId});

  @override
  State<AddBookingSlot> createState() => _AddBookingSlotState();
}

class _AddBookingSlotState extends State<AddBookingSlot> {
  final slotController = Get.put(SlotController());
  final _formKeyBooking = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  FirebaseService firebaseService = FirebaseService();
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  bool isDescendingOrder = true;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String get slotId => widget.slotId;
  Future<void> addSlotToFirestore() async {
    OverlayEntry loader = Helper.overlayLoader(context);
    Overlay.of(context).insert(loader);
    try {
      await firebaseService.manageSlot(
        slotId:widget.slotId,
        time: DateTime.now().millisecondsSinceEpoch,
        // slot: slotController.dinnerSlots,
        // dinnerSlot: slotController.dinnerSlots,
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
                            // slotController.getLunchTimeSlot();
                            // slotController.getDinnerTimeSlot();
                            // if(slotController.slots.isNotEmpty && slotController.dinnerSlots.isNotEmpty){
                            //   addSlotToFirestore();
                            // }
                            addSlotToFirestore();
                          }
                        },
                        title: 'Create Slot'.toUpperCase(),
                      ),
                    ),
                  ]))),
        ));
  }
}
