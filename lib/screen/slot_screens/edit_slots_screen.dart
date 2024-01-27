import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:resvago_vendor/screen/slot_screens/slot.dart';
import 'package:resvago_vendor/utils/helper.dart';

import '../../Firebase_service/firebase_service.dart';
import '../../controllers/edit_controller.dart';
import '../../controllers/slot_controller.dart';
import '../../helper.dart';
import '../../model/createslot_model.dart';
import '../../widget/addsize.dart';
import '../../widget/common_text_field.dart';
import '../../widget/custom_textfield.dart';

class EditSlotsScreen extends StatefulWidget {
  EditSlotsScreen({super.key, required this.createSlotData, required this.refreshValues});
  CreateSlotData? createSlotData;
  final Function() refreshValues;
  @override
  State<EditSlotsScreen> createState() => _EditSlotsScreenState();
}

class _EditSlotsScreenState extends State<EditSlotsScreen> {
  CreateSlotData get slotsInfo => widget.createSlotData!;
  final formKey = GlobalKey<FormState>();
  final slotController = Get.put(SlotController());

  FirebaseService firebaseService = FirebaseService();
  bool apiLoaded = false;

  getData() {
    // widget.createSlotData = null;
    FirebaseFirestore.instance
        .collection('vendor_slot')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("slot")
        .doc(widget.createSlotData!.slotId.toString())
        .get()
        .then((value) {
      widget.createSlotData = CreateSlotData.fromMap(value.data()!);
      apiLoaded = true;
      setState(() {});
    });
  }

  @override
  void initState() {
    super.initState();
    getData();
    if (widget.createSlotData == null) return;
    slotController.startDate.text = (widget.createSlotData!.slotDate ?? "").toString();
    // slotController.serviceDuration.text = slotDataList!.lunchDuration;
    // slotController.dinnerServiceDuration.text = slotDataList!.dinnerDuration;
    slotController.noOfGuest.text = (widget.createSlotData!.noOfGuest ?? "").toString();
    slotController.setOffer.text = (widget.createSlotData!.setOffer ?? "").toString();
    slotController.serviceDuration.text = (widget.createSlotData!.lunchInterval ?? "").toString();
    slotController.dinnerServiceDuration.text = (widget.createSlotData!.dinnerInterval ?? "").toString();
    slotController.startTime.text = "";
    slotController.endTime.text = "";
    slotController.dinnerStartTime.text = "";
    slotController.dinnerEndTime.text = "";
    // slotController.dateType.value = slotDataList!.dateType ?? "date";
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xFFF6F6F6),
        appBar: backAppBar(title: "Edit Slot".tr, context: context, backgroundColor: Colors.white),
        body: apiLoaded
            ? Theme(
                data: ThemeData(useMaterial3: true),
                child: SingleChildScrollView(
                    child: Form(
                        key: formKey,
                        child: Column(children: [
                          const SizedBox(
                            height: 8,
                          ),
                          BookableUI(title: "Lunch".tr, slotDataList: widget.createSlotData, showDates: false, editing: true),
                          BookableUI(
                            title: "Dinner".tr,
                            slotDataList: widget.createSlotData,
                            showDates: false,
                            editing: true,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Card(
                            color: Colors.white,
                            surfaceTintColor: Colors.white,
                            elevation: 2,
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: AddSize.padding10, vertical: AddSize.padding15).copyWith(bottom: 10),
                              child: RegisterTextFieldWidget(
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
                            ),
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: AddSize.padding16, vertical: AddSize.padding10)
                                .copyWith(bottom: 30),
                            child: CommonButtonBlue(
                              onPressed: () async {
                                if (formKey.currentState!.validate()) {
                                  slotController.getLunchTimeSlot();
                                  slotController.getDinnerTimeSlot();
                                  print(slotController.timeslots);
                                  print(slotController.dinnerTimeslots);
                                  await firebaseService.manageSlot(
                                    setOffer: widget.createSlotData!.setOffer ?? "",
                                    seats: slotController.noOfGuest.text,
                                    startDate: widget.createSlotData!.slotId!,
                                    lunchInterval: slotController.serviceDuration.text,
                                    dinnerInterval: slotController.dinnerServiceDuration.text,
                                    startLunchTime: slotController.startTime.text,
                                    endLunchTime: slotController.endTime.text,
                                    startDinnerTime: slotController.dinnerStartTime.text,
                                    endDinnerTime: slotController.dinnerEndTime.text,
                                    endDate: null,
                                    eveningSlots: slotController.editDinner ? slotController.dinnerTimeslots : widget.createSlotData!.eveningSlots!.entries.map((e) => e.key).toList(),
                                    morningSlots: slotController.editLunch ? slotController.timeslots : widget.createSlotData!.morningSlots!.entries.map((e) => e.key).toList(),
                                  );
                                  showToast("Slot Updated Successfully");
                                  widget.refreshValues();
                                  Get.back();
                                }
                              },
                              title: 'Update Slot'.tr.toUpperCase(),
                            ),
                          ),
                        ]).appPaddingForScreen)),
              )
            : const Center(
                child: CircularProgressIndicator(),
              ));
  }
}
