import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:resvago_vendor/screen/slot_screens/slot.dart';

import '../../Firebase_service/firebase_service.dart';
import '../../controllers/edit_controller.dart';
import '../../controllers/slot_controller.dart';
import '../../model/createslot_model.dart';
import '../../widget/addsize.dart';
import '../../widget/common_text_field.dart';
import '../../widget/custom_textfield.dart';

class EditSlotsScreen extends StatefulWidget {
  const EditSlotsScreen({super.key, required this.createSlotData});
  final CreateSlotData createSlotData;
  @override
  State<EditSlotsScreen> createState() => _EditSlotsScreenState();
}

class _EditSlotsScreenState extends State<EditSlotsScreen> {
  CreateSlotData get slotsInfo => widget.createSlotData;
  final formKey = GlobalKey<FormState>();
  final slotController = Get.put(SlotController());

  FirebaseService firebaseService = FirebaseService();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xFFF6F6F6),
        appBar: backAppBar(title: "Edit Slot", context: context, backgroundColor: Colors.white),
        body: Theme(
          data: ThemeData(useMaterial3: true),
          child: SingleChildScrollView(
              child: Form(
                  key: formKey,
                  child: Column(children: [
                    const SizedBox(
                      height: 8,
                    ),
                    BookableUI(title: "Lunch", slotDataList: widget.createSlotData, showDates: false, editing: true),
                    BookableUI(
                      title: "Dinner",
                      slotDataList: widget.createSlotData,
                      showDates: false,
                      editing: true,
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: AddSize.padding16, vertical: AddSize.padding10).copyWith(bottom: 30),
                      child: CommonButtonBlue(
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            slotController.getLunchTimeSlot();
                            slotController.getDinnerTimeSlot();
                            print(slotController.timeslots);
                            print(slotController.dinnerTimeslots);
                            firebaseService.manageSlot(
                                setOffer: widget.createSlotData.setOffer??"",
                                seats: "50" ??"",
                                startDate: widget.createSlotData.slotId!,
                                endDate: null,
                                eveningSlots: slotController.editDinner ? slotController.dinnerTimeslots : widget.createSlotData.eveningSlots!.entries.map((e) => e.key).toList(),
                                morningSlots: slotController.editLunch ? slotController.timeslots : widget.createSlotData.morningSlots!.entries.map((e) => e.key).toList(),
                            );
                          }
                        },
                        title: 'Update Slot'.toUpperCase(),
                      ),
                    ),
                  ]))),
        ));
  }
}
