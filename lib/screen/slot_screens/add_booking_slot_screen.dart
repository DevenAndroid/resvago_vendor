import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:resvago_vendor/model/createslot_model.dart';
import 'package:resvago_vendor/screen/slot_screens/slot.dart';
import 'package:resvago_vendor/utils/helper.dart';
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
  bool lunch = false;
  bool dinner = false;
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
        morningSlots: slotController.timeslots,
        lunchInterval: slotController.serviceDuration.text,
        dinnerInterval: slotController.dinnerServiceDuration.text,
        startLunchTime: slotController.startTime.text,
        endLunchTime: slotController.endTime.text,
        startDinnerTime: slotController.dinnerStartTime.text,
        endDinnerTime: slotController.dinnerEndTime.text,
      )
          .then((value) {
        showToast("Slot Created Successfully");
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
    slotController.timeslots = [];
    slotController.dinnerTimeslots = [];
    slotController.selectedEndDateTIme = null;
    if (widget.slotDataList == null) return;
    setState(() {});
  }

  clearSlots() {
    if (slotController.dinnerSlots.isNotEmpty) {
      slotController.dinnerSlots.clear();
      setState(() {});
    }
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
                    BookableUI(title: "Lunch".tr, slotsDate: widget.slotsDate, slotDataList: widget.slotDataList),
                    BookableUI(title: "Dinner".tr, slotsDate: widget.slotsDate, slotDataList: widget.slotDataList),
                    Card(
                      color: Colors.white,
                      surfaceTintColor: Colors.white,
                      elevation: 2,
                      child: Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: AddSize.padding16, vertical: AddSize.padding20).copyWith(bottom: 10),
                        child: Column(
                          children: [
                            RegisterTextFieldWidget(
                                controller: slotController.noOfGuest,
                                hint: "Enter no. of guest".tr,
                                onChanged: (f) {
                                  // clearSlots();
                                },
                                keyboardType: TextInputType.number,
                                validator: (value) {
                                  if (value!.trim().isEmpty) {
                                    return "Guest no. is required".tr;
                                  }
                                  return null;
                                }),
                            const SizedBox(height: 10),
                            RegisterTextFieldWidget(
                              controller: slotController.setOffer,
                              hint: "Set Offer".tr,
                              onChanged: (f) {
                                // clearSlots();
                              },
                              keyboardType: TextInputType.number,
                              // validator: (value) {
                              //   if (value!.trim().isEmpty) {
                              //     return "Offer is required";
                              //   }
                              //   return null;
                              // }
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                          ],
                        ),
                      ),
                    ),
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
                            log(slotController.timeslots.toList().toString());
                            log(slotController.dinnerTimeslots.toList().toString());
                            if (slotController.timeslots.isNotEmpty || slotController.dinnerTimeslots.isNotEmpty) {
                              addSlotToFirestore();
                            } else {
                              showToast("Please create slot");
                            }
                          }
                        },
                        title: 'Create Slot'.toUpperCase(),
                      ),
                    ),
                  ]).appPaddingForScreen)),
        ));
  }
}
