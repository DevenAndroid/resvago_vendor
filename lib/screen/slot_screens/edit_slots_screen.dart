import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:resvago_vendor/screen/slot_screens/slot.dart';

import '../../controllers/slot_controller.dart';
import '../../model/createslot_model.dart';
import '../../widget/addsize.dart';
import '../../widget/common_text_field.dart';
import '../../widget/custom_textfield.dart';

class EditSlotsScreen extends StatefulWidget {
  const EditSlotsScreen({super.key, required this.createSlotData, required this.slotsDate});
  final CreateSlotData createSlotData;
  final List<DateTime> slotsDate;
  @override
  State<EditSlotsScreen> createState() => _EditSlotsScreenState();
}

class _EditSlotsScreenState extends State<EditSlotsScreen> {

  CreateSlotData get slotsInfo => widget.createSlotData;
  final formKey = GlobalKey<FormState>();
  final slotController = Get.put(SlotController());
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
                    BookableUI(title: "Lunch",slotsDate: widget.slotsDate,slotDataList: widget.createSlotData),
                    BookableUI(title: "Dinner",slotsDate: widget.slotsDate,slotDataList:  widget.createSlotData),
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
                            if (slotController.timeslots.isNotEmpty && slotController.dinnerTimeslots.isNotEmpty) {
                              // addSlotToFirestore();
                            }
                          }
                        },
                        title: 'Update Slot'.toUpperCase(),
                      ),
                    ),
                  ]))),
        )
    );
  }
}
