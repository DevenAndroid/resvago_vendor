import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:resvago_vendor/controllers/slot_controller.dart';
import '../../model/createslot_model.dart';
import '../../widget/addsize.dart';
import '../../widget/apptheme.dart';
import '../../widget/common_text_field.dart';
import '../create_slot.dart';

class BookableUI extends StatefulWidget {
  String title;
  List<DateTime>? slotsDate;
  CreateSlotData? slotDataList;
  bool? editing = false;
  final bool? showDates;
  BookableUI({super.key, required this.title, this.slotsDate, this.slotDataList, this.editing, this.showDates});

  @override
  State<BookableUI> createState() => _BookableUIState();
}

class _BookableUIState extends State<BookableUI> {
  final slotController = Get.put(SlotController());
  bool lunch = false;
  bool dinner = false;
  final DateFormat selectedDateFormat = DateFormat("dd-MMM-yyyy");
  pickDate({
    required Function(DateTime gg) onPick,
    DateTime? initialDate,
    DateTime? firstDate,
    DateTime? lastDate,
  }) async {
    DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: initialDate ?? DateTime.now(),
        firstDate: firstDate ?? DateTime.now(),
        lastDate: lastDate ?? DateTime(2101),
        initialEntryMode: DatePickerEntryMode.calendarOnly);
    if (pickedDate == null) return;
    onPick(pickedDate);
  }

  @override
  void initState() {
    super.initState();
    slotController.selectedEndDateTIme = null;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        widget.title == "Lunch" ? productAvailability() : productAvailability1(),
      ],
    );
  }

  final DateFormat timeFormat = DateFormat("hh:mm a");
  productAvailability() {
    List<String> morningSlots =
        widget.slotDataList != null ? widget.slotDataList!.morningSlots!.entries.map((e) => e.key).toList() : [];
    morningSlots.sort((a, b) {
      final timeA = TimeOfDay.fromDateTime(timeFormat.parse(a));
      final timeB = TimeOfDay.fromDateTime(timeFormat.parse(b));
      return timeA.hour * 60 + timeA.minute - (timeB.hour * 60 + timeB.minute);
    });
    // widget.slotDataList!.morningSlots!.entries.toList().sort((a, b) {
    //   final timeA = TimeOfDay.fromDateTime(timeFormat.parse(a.key));
    //   final timeB = TimeOfDay.fromDateTime(timeFormat.parse(b.key));
    //   return (timeA.hour * 60 + timeA.minute) - (timeB.hour * 60 + timeB.minute);
    // });
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.showDates == null)
          Card(
            color: Colors.white,
            surfaceTintColor: Colors.white,
            elevation: 2,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: AddSize.padding16, vertical: AddSize.padding20).copyWith(bottom: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                          child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Obx(() {
                            return Radio<String>(
                                value: "date",
                                groupValue: slotController.dateType.value,
                                visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
                                onChanged: (v) {
                                  if (v == null) return;
                                  slotController.dateType.value = v;
                                  // updateValues();
                                });
                          }),
                          Flexible(
                            child: GestureDetector(
                              onTap: () {
                                slotController.dateType.value = "date";
                                // updateValues();
                              },
                              behavior: HitTestBehavior.translucent,
                              child: Text(
                                "Single Date".tr,
                                style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w400, color: const Color(0xff2F2F2F), fontSize: 14),
                              ),
                            ),
                          ),
                        ],
                      )),
                      const SizedBox(
                        width: 16,
                      ),
                      Flexible(
                          child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Obx(() {
                            return Radio<String>(
                                value: "range",
                                groupValue: slotController.dateType.value,
                                visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
                                onChanged: (v) {
                                  if (v == null) return;
                                  slotController.dateType.value = v;
                                  // updateValues();
                                });
                          }),
                          Flexible(
                            child: GestureDetector(
                              onTap: () {
                                slotController.dateType.value = "range";
                                // updateValues();
                              },
                              behavior: HitTestBehavior.translucent,
                              child: Text(
                                "Date Range".tr,
                                style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w400, color: const Color(0xff2F2F2F), fontSize: 14),
                              ),
                            ),
                          ),
                        ],
                      )),
                    ],
                  ),
                  Obx(() {
                    return slotController.dateType.value == "range"
                        ? Column(
                            children: [
                              RegisterTextFieldWidget(
                                  readOnly: true,
                                  hint: "Start Date".tr,
                                  onTap: () {
                                    pickDate(
                                        onPick: (DateTime gg) {
                                          slotController.startDate.text = selectedDateFormat.format(gg);
                                          slotController.selectedStartDateTime = gg;
                                        },
                                        initialDate: slotController.selectedStartDateTime,
                                        lastDate: DateTime(2100));
                                  },
                                  controller: slotController.startDate,
                                  validator: (value) {
                                    if (value!.trim().isEmpty) {
                                      return "Start date is required";
                                    }
                                    return null;
                                  }),
                              const SizedBox(height: 10),
                              RegisterTextFieldWidget(
                                  readOnly: true,
                                  hint: "End Date".tr,
                                  onTap: () {
                                    pickDate(
                                        onPick: (DateTime gg) {
                                          slotController.endDate.text = selectedDateFormat.format(gg);
                                          slotController.selectedEndDateTIme = gg;
                                        },
                                        initialDate: slotController.selectedEndDateTIme ?? slotController.selectedStartDateTime,
                                        firstDate: slotController.selectedStartDateTime);
                                  },
                                  controller: slotController.endDate,
                                  // key: slotController.endDate.getKey,
                                  // key: endTime.getKey,
                                  validator: (value) {
                                    if (value!.trim().isEmpty) {
                                      return "End date is required";
                                    }
                                    return null;
                                  }),
                            ],
                          )
                        : Column(
                            children: [
                              RegisterTextFieldWidget(
                                  readOnly: true,
                                  hint: "Start Date".tr,
                                  onTap: () {
                                    pickDate(
                                      onPick: (DateTime gg) {
                                        slotController.startDate.text = selectedDateFormat.format(gg);
                                        slotController.selectedStartDateTime = gg;
                                      },
                                      initialDate: slotController.selectedStartDateTime,
                                    );
                                  },
                                  controller: slotController.startDate,
                                  // key: slotController.startDate.getKey,
                                  // key: startTime.getKey,
                                  validator: (value) {
                                    if (value!.trim().isEmpty) {
                                      return "Single date is required";
                                    }
                                    return null;
                                  }),
                            ],
                          );
                  }),
                ],
              ),
            ),
          ),
        Card(
          color: Colors.white,
          surfaceTintColor: Colors.white,
          elevation: 2,
          child: Row(
            children: [
              Row(
                children: [
                  Checkbox(
                      activeColor: AppTheme.primaryColor,
                      value: lunch,
                      onChanged: (value) {
                        setState(() {
                          lunch = value!;
                        });
                      }),
                  Text(
                    "Lunch Time Slot",
                    style: GoogleFonts.poppins(fontWeight: FontWeight.w500, color: const Color(0xff2F2F2F), fontSize: 16),
                  )
                ],
              ),
            ],
          ),
        ),
        if (lunch == true)
          Card(
            color: Colors.white,
            surfaceTintColor: Colors.white,
            elevation: 2,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: AddSize.padding16, vertical: AddSize.padding20).copyWith(bottom: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          "Lunch Time Slot".tr,
                          style: GoogleFonts.poppins(fontWeight: FontWeight.w500, color: const Color(0xff2F2F2F), fontSize: 16),
                        ),
                      ),
                      if (widget.showDates == false)
                        TextButton(
                            onPressed: () {
                              slotController.editLunch = !slotController.editLunch;
                              setState(() {});
                            },
                            child: Text(slotController.editLunch ? "Previous Slots".tr : "Create New".tr)),
                    ],
                  ),
                  if (widget.slotDataList == null || slotController.editLunch == true)
                    const CreateSlotsScreen()
                  else
                    ...morningSlots.map((e) => Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              e.replaceAll(",", " - "),
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            InkWell(
                                onTap: () {
                                  widget.slotDataList!.morningSlots!.remove(e);
                                  setState(() {});
                                },
                                child: const Icon(
                                  Icons.clear_rounded,
                                  color: Colors.grey,
                                ))
                          ],
                        ))
                ],
              ),
            ),
          ),
      ],
    );
  }

  productAvailability1() {
    List<String> eveningSlots =
        widget.slotDataList != null ? widget.slotDataList!.eveningSlots!.entries.map((e) => e.key).toList() : [];
    eveningSlots.sort((a, b) {
      final timeA = TimeOfDay.fromDateTime(timeFormat.parse(a));
      final timeB = TimeOfDay.fromDateTime(timeFormat.parse(b));
      return timeA.hour * 60 + timeA.minute - (timeB.hour * 60 + timeB.minute);
    });
    return Column(
      children: [
        Card(
          color: Colors.white,
          surfaceTintColor: Colors.white,
          elevation: 2,
          child: Row(
            children: [
              Row(
                children: [
                  Checkbox(
                      activeColor: AppTheme.primaryColor,
                      value: dinner,
                      onChanged: (value) {
                        setState(() {
                          dinner = value!;
                          log(dinner.toString());
                        });
                      }),
                  Text(
                    "Dinner Time Slot",
                    style: GoogleFonts.poppins(fontWeight: FontWeight.w500, color: const Color(0xff2F2F2F), fontSize: 16),
                  )
                ],
              ),
            ],
          ),
        ),
        if (dinner == true)
          Card(
            color: Colors.white,
            surfaceTintColor: Colors.white,
            elevation: 2,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: AddSize.padding16, vertical: AddSize.padding20).copyWith(bottom: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          "Dinner Time Slot".tr,
                          style: GoogleFonts.poppins(fontWeight: FontWeight.w500, color: const Color(0xff2F2F2F), fontSize: 16),
                        ),
                      ),
                      if (widget.showDates == false)
                        TextButton(
                            onPressed: () {
                              slotController.editDinner = !slotController.editDinner;
                              setState(() {});
                            },
                            child: Text(slotController.editDinner ? "Previous Slots".tr : "Create New".tr)),
                    ],
                  ),
                  if (widget.slotDataList == null || slotController.editDinner == true)
                    const DinnerCreateSlotsScreen()
                  else
                    ...eveningSlots.map((e) => Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              e.replaceAll(",", " - "),
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            InkWell(
                                onTap: () {
                                  widget.slotDataList!.eveningSlots!.remove(e);
                                  setState(() {});
                                },
                                child: const Icon(
                                  Icons.clear_rounded,
                                  color: Colors.grey,
                                ))
                          ],
                        ))
                ],
              ),
            ),
          ),
      ],
    );
  }
}
