import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:resvago_vendor/model/createslot_model.dart';
import 'package:resvago_vendor/screen/slot_screens/slot.dart';
import '../../Firebase_service/firebase_service.dart';
import '../../controllers/slot_controller.dart';
import '../../helper.dart';
import '../../widget/addsize.dart';
import '../../widget/apptheme.dart';
import '../../widget/common_text_field.dart';
import '../../widget/custom_textfield.dart';

class AddBookingSlot extends StatefulWidget {
  final String slotId;
  CreateSlotData? slotDataList;
  final List<DateTime> slotsDate;
  final Function() refreshValues;
  AddBookingSlot({super.key, required this.slotId, this.slotDataList, required this.slotsDate, required this.refreshValues});

  @override
  State<AddBookingSlot> createState() => _AddBookingSlotState();
}

class _AddBookingSlotState extends State<AddBookingSlot> {
  final slotController = Get.put(SlotController());
  final _formKeyBooking = GlobalKey<FormState>();

  FirebaseService firebaseService = FirebaseService();
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  String get slotId => widget.slotId;
  CreateSlotData? get slotDataList => widget.slotDataList;
  bool isDescendingOrder = true;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  Future<void> addSlotToFirestore() async {
    OverlayEntry loader = Helper.overlayLoader(context);
    Overlay.of(context).insert(loader);

    try {
      await firebaseService
          .manageSlot(
        setOffer: slotController.setOffer.text,
              seats: slotController.noOfGuest.text,
              startDate: slotController.selectedStartDateTime!,
              endDate: slotController.selectedEndDateTIme,
              eveningSlots: slotController.dinnerTimeslots,
              morningSlots: slotController.timeslots
      )
          .then((value) {
        Get.back();
        widget.refreshValues();
        Helper.hideLoader(loader);
      });
    } catch (e) {
      Helper.hideLoader(loader);
      showToast(e.toString());
      log(e.toString());
      throw Exception(e.toString());
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.slotDataList == null) return;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xFFF6F6F6),
        appBar: backAppBar(title: "Create Slot".tr, context: context, backgroundColor: Colors.white),
        body: Theme(
          data: ThemeData(useMaterial3: true),
          child: SingleChildScrollView(
              child: Form(
                  key: _formKeyBooking,
                  child: Column(children: [
                    const SizedBox(
                      height: 8,
                    ),
                    BookableUI(title: "Lunch".tr,slotsDate: widget.slotsDate,slotDataList: widget.slotDataList),
                    BookableUI(title: "Dinner".tr,slotsDate: widget.slotsDate,slotDataList: widget.slotDataList),
                    const SizedBox(
                      height: 30,
                    ),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: AddSize.padding16, vertical: AddSize.padding10).copyWith(bottom: 30),
                      child: CommonButtonBlue(
                        onPressed: () {
                          if (_formKeyBooking.currentState!.validate()) {
                            slotController.getLunchTimeSlot();
                            slotController.getDinnerTimeSlot();
                            if (slotController.timeslots.isNotEmpty && slotController.dinnerTimeslots.isNotEmpty) {
                              addSlotToFirestore();
                            }
                          }
                        },
                        title: 'Create Slot'.toUpperCase().tr,
                      ),
                    ),
                  ]))),
        )
    );
  }
}
