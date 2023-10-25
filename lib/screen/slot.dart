import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:resvago_vendor/controllers/slot_controller.dart';
import '../widget/addsize.dart';
import '../widget/common_text_field.dart';
import 'create_slot.dart';

class BookableUI extends StatefulWidget {
  String title;
  BookableUI({super.key, required this.title});

  @override
  State<BookableUI> createState() => _BookableUIState();
}

class _BookableUIState extends State<BookableUI> {
  final slotController = Get.put(SlotController());
  final DateFormat selectedDateFormat = DateFormat("dd-MMM-yyyy");
  pickDate({required Function(DateTime gg) onPick, DateTime? initialDate, DateTime? firstDate, DateTime? lastDate}) async {
    DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: initialDate ?? DateTime.now(),
        firstDate: firstDate ?? DateTime.now(),
        lastDate: lastDate ?? DateTime(2101),
        initialEntryMode: DatePickerEntryMode.calendarOnly);
    if (pickedDate == null) return;
    onPick(pickedDate);
    // updateValues();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        widget.title == "Lunch" ? productAvailability() : productAvailability1(),
        // const CreateSlotsScreen(),
      ],
    );
  }

   productAvailability() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
                                  "Single Date",
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
                                  "Date Range",
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
                          hint: "Start Date",
                          onTap: () {
                            pickDate(
                                onPick: (DateTime gg) {
                                  slotController.startDate.text = selectedDateFormat.format(gg);
                                  slotController.selectedStartDateTime = gg;
                                },
                                initialDate: slotController.selectedStartDateTime,
                                lastDate: slotController.selectedEndDateTIme);
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
                          hint: "End Date",
                          onTap: () {
                            pickDate(
                                onPick: (DateTime gg) {
                                  slotController.endDate.text = selectedDateFormat.format(gg);
                                  slotController.selectedEndDateTIme = gg;
                                },
                                initialDate:
                                slotController.selectedEndDateTIme ?? slotController.selectedStartDateTime,
                                firstDate: slotController.selectedStartDateTime);
                          },
                          controller: slotController.endDate,
                          key: slotController.endDate.getKey,
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
                          hint: "Start Date",
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
                          key: slotController.startDate.getKey,
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
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: AddSize.padding16, vertical: AddSize.padding20).copyWith(bottom: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Lunch Time Slot",
                  style: GoogleFonts.poppins(fontWeight: FontWeight.w500, color: const Color(0xff2F2F2F), fontSize: 16),
                ),
                const CreateSlotsScreen()
              ],
            ),
          ),
        )
      ],
    );
  }

  Card productAvailability1() {
    return Card(
        color: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 2,
        child: Padding(
            padding: EdgeInsets.symmetric(horizontal: AddSize.padding16, vertical: AddSize.padding20).copyWith(bottom: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Dinner Time Slot",
                  style: GoogleFonts.poppins(fontWeight: FontWeight.w500, color: const Color(0xff2F2F2F), fontSize: 16),
                ),
                // const SizedBox(
                //   height: 10,
                // ),
                // Row(
                //   children: [
                //     Flexible(
                //         child: Row(
                //       mainAxisSize: MainAxisSize.min,
                //       children: [
                //         Obx(() {
                //           return Radio<String>(
                //               value: "date",
                //               groupValue: slotController.dateType.value,
                //               visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
                //               onChanged: (v) {
                //                 if (v == null) return;
                //                 slotController.dateType.value = v;
                //                 // updateValues();
                //               });
                //         }),
                //         Flexible(
                //           child: GestureDetector(
                //             onTap: () {
                //               slotController.dateType.value = "date";
                //               // updateValues();
                //             },
                //             behavior: HitTestBehavior.translucent,
                //             child: Text(
                //               "Single Date",
                //               style: GoogleFonts.poppins(
                //                   fontWeight: FontWeight.w400, color: const Color(0xff2F2F2F), fontSize: 14),
                //             ),
                //           ),
                //         ),
                //       ],
                //     )),
                //     const SizedBox(
                //       width: 16,
                //     ),
                //     Flexible(
                //         child: Row(
                //       mainAxisSize: MainAxisSize.min,
                //       children: [
                //         Obx(() {
                //           return Radio<String>(
                //               value: "range",
                //               groupValue: slotController.dateType.value,
                //               visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
                //               onChanged: (v) {
                //                 if (v == null) return;
                //                 slotController.dateType.value = v;
                //                 // updateValues();
                //               });
                //         }),
                //         Flexible(
                //           child: GestureDetector(
                //             onTap: () {
                //               slotController.dateType.value = "range";
                //               // updateValues();
                //             },
                //             behavior: HitTestBehavior.translucent,
                //             child: Text(
                //               "Date Range",
                //               style: GoogleFonts.poppins(
                //                   fontWeight: FontWeight.w400, color: const Color(0xff2F2F2F), fontSize: 14),
                //             ),
                //           ),
                //         ),
                //       ],
                //     )),
                //   ],
                // ),
                // Obx(() {
                //   return slotController.dateType.value == "range"
                //       ? Column(
                //           children: [
                //             RegisterTextFieldWidget(
                //                 readOnly: true,
                //                 hint: "Start Date",
                //                 onTap: () {
                //                   pickDate(
                //                       onPick: (DateTime gg) {
                //                         slotController.dinnerStartDate.text = selectedDateFormat.format(gg);
                //                         slotController.dinnerSelectedStartDateTime = gg;
                //                       },
                //                       initialDate: slotController.dinnerSelectedStartDateTime,
                //                       lastDate: slotController.dinnerSelectedEndDateTIme);
                //                 },
                //                 controller: slotController.dinnerStartDate,
                //                 validator: (value) {
                //                   if (value!.trim().isEmpty) {
                //                     return "Start date is required";
                //                   }
                //                   return null;
                //                 }),
                //             const SizedBox(height: 10),
                //             RegisterTextFieldWidget(
                //                 readOnly: true,
                //                 hint: "End Date",
                //                 onTap: () {
                //                   pickDate(
                //                       onPick: (DateTime gg) {
                //                         slotController.dinnerEndDate.text = selectedDateFormat.format(gg);
                //                         slotController.dinnerSelectedEndDateTIme = gg;
                //                       },
                //                       initialDate: slotController.dinnerSelectedEndDateTIme ??
                //                           slotController.dinnerSelectedStartDateTime,
                //                       firstDate: slotController.dinnerSelectedStartDateTime);
                //                 },
                //                 controller: slotController.dinnerEndDate,
                //                 key: slotController.dinnerEndDate.getKey,
                //                 // key: endTime.getKey,
                //                 validator: (value) {
                //                   if (value!.trim().isEmpty) {
                //                     return "End date is required";
                //                   }
                //                   return null;
                //                 }),
                //           ],
                //         )
                //       : Column(
                //           children: [
                //             RegisterTextFieldWidget(
                //                 readOnly: true,
                //                 hint: "Start Date",
                //                 onTap: () {
                //                   pickDate(
                //                     onPick: (DateTime gg) {
                //                       slotController.dinnerStartDate.text = selectedDateFormat.format(gg);
                //                       slotController.dinnerSelectedStartDateTime = gg;
                //                     },
                //                     initialDate: slotController.dinnerSelectedStartDateTime,
                //                   );
                //                 },
                //                 controller: slotController.dinnerStartDate,
                //                 key: slotController.dinnerStartDate.getKey,
                //                 // key: startTime.getKey,
                //                 validator: (value) {
                //                   if (value!.trim().isEmpty) {
                //                     return "Single date is required";
                //                   }
                //                   return null;
                //                 }),
                //           ],
                //         );
                // }),
                const DinnerCreateSlotsScreen()
              ],
            )));
  }
}
