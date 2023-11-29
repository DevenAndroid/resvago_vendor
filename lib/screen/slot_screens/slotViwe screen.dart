import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:resvago_vendor/utils/helper.dart';
import 'package:resvago_vendor/widget/custom_textfield.dart';

import '../../model/createslot_model.dart';

class SlotViewScreen extends StatefulWidget {
  // final String slotId;
  final CreateSlotData? slotDataList;
  SlotViewScreen({super.key, this.slotDataList});

  @override
  State<SlotViewScreen> createState() => _SlotViewScreenState();
}

class _SlotViewScreenState extends State<SlotViewScreen> {
  // String get slotId => widget.slotId;
  CreateSlotData? get slotDataList => widget.slotDataList;

  @override
  Widget build(BuildContext context) {
    if (kDebugMode) {
      print(slotDataList!.eveningSlots!);
    }
    return Scaffold(
        appBar: backAppBar(title: "Slot View".tr, context: context),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Start Date".tr,
                              style:
                                  GoogleFonts.poppins(color: const Color(0xFF1A2E33), fontWeight: FontWeight.w300, fontSize: 16),
                            ),
                            Text(
                              DateFormat("dd-MMM-yyy").format(DateTime.fromMillisecondsSinceEpoch(slotDataList!.slotDate!)),
                              style:
                                  GoogleFonts.poppins(color: const Color(0xFF1A2E33), fontWeight: FontWeight.w500, fontSize: 16),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        FittedBox(
                          child: Row(
                            children: List.generate(
                                kIsWeb ? 100: 25,
                                (index) => Padding(
                                      padding: const EdgeInsets.only(left: 2, right: 2),
                                      child: Container(
                                        color: Colors.grey[200],
                                        height: 2,
                                        width: 10,
                                      ),
                                    )),
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Lunch Time Slots".tr,
                              style:
                                  GoogleFonts.poppins(color: const Color(0xFF1A2E33), fontWeight: FontWeight.w500, fontSize: 16),
                            ),
                            Text(
                              "Seats".tr,
                              style:
                                  GoogleFonts.poppins(color: const Color(0xFF1A2E33), fontWeight: FontWeight.w500, fontSize: 16),
                            ),
                            // Text(
                            //   slotDataList!.morningSlots!.entries.toList()[0].key.split(",").first,
                            //   style: GoogleFonts.poppins(
                            //       color: const Color(0xFF1A2E33), fontWeight: FontWeight.w500, fontSize: 16),
                            // ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        ...slotDataList!.morningSlots!.entries.map((e) => Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    e.key,
                                    style: GoogleFonts.poppins(
                                        color: const Color(0xFF1A2E33), fontWeight: FontWeight.w400, fontSize: 16),
                                  ),
                                  Text(
                                    e.value.toString(),
                                    style: GoogleFonts.poppins(
                                        color: const Color(0xFF1A2E33), fontWeight: FontWeight.w500, fontSize: 16),
                                  ),
                                ],
                              ),
                            )),
                        const SizedBox(
                          height: 15,
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        FittedBox(
                          child: Row(
                            children: List.generate(
                                kIsWeb ? 100: 25,
                                    (index) => Padding(
                                  padding: const EdgeInsets.only(left: 2, right: 2),
                                  child: Container(
                                    color: Colors.grey[200],
                                    height: 2,
                                    width: 10,
                                  ),
                                )),
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Dinner Start Time".tr,
                              style:
                                  GoogleFonts.poppins(color: const Color(0xFF1A2E33), fontWeight: FontWeight.w500, fontSize: 16),
                            ),
                            Text(
                              "Seats".tr,
                              style:
                                  GoogleFonts.poppins(color: const Color(0xFF1A2E33), fontWeight: FontWeight.w500, fontSize: 16),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        ...slotDataList!.eveningSlots!.entries.map((e) => Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    e.key.split(",").first,
                                    style: GoogleFonts.poppins(
                                        color: const Color(0xFF1A2E33), fontWeight: FontWeight.w400, fontSize: 16),
                                  ),
                                  Text(
                                    e.value.toString(),
                                    style: GoogleFonts.poppins(
                                        color: const Color(0xFF1A2E33), fontWeight: FontWeight.w500, fontSize: 16),
                                  ),
                                ],
                              ),
                            )),
                        const SizedBox(
                          height: 15,
                        ),
                        FittedBox(
                          child: Row(
                            children: List.generate(
                                kIsWeb ? 100: 25,
                                    (index) => Padding(
                                  padding: const EdgeInsets.only(left: 2, right: 2),
                                  child: Container(
                                    color: Colors.grey[200],
                                    height: 2,
                                    width: 10,
                                  ),
                                )),
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Number of Guest".tr,
                              style:
                                  GoogleFonts.poppins(color: const Color(0xFF1A2E33), fontWeight: FontWeight.w300, fontSize: 16),
                            ),
                            Text(
                              slotDataList!.noOfGuest ?? "".toString(),
                              style:
                                  GoogleFonts.poppins(color: const Color(0xFF1A2E33), fontWeight: FontWeight.w500, fontSize: 16),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Interval TIme".tr,
                              style:
                                  GoogleFonts.poppins(color: const Color(0xFF1A2E33), fontWeight: FontWeight.w300, fontSize: 16),
                            ),
                            Text(
                              "30 Mins".tr,
                              style:
                                  GoogleFonts.poppins(color: const Color(0xFF1A2E33), fontWeight: FontWeight.w500, fontSize: 16),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //   children: [
                        //     Text(
                        //       "Total Booking",
                        //       style: GoogleFonts.poppins(
                        //           color: const Color(0xFF1A2E33), fontWeight: FontWeight.w300, fontSize: 16),
                        //     ),
                        //     Text(
                        //       "10",
                        //       style: GoogleFonts.poppins(
                        //           color: const Color(0xFF1A2E33), fontWeight: FontWeight.w500, fontSize: 16),
                        //     ),
                        //   ],
                        // ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Offers".tr,
                              style:
                                  GoogleFonts.poppins(color: const Color(0xFF1A2E33), fontWeight: FontWeight.w300, fontSize: 16),
                            ),
                            Text(
                              "${slotDataList!.setOffer ?? "".toString()}%",
                              style:
                                  GoogleFonts.poppins(color: const Color(0xFF1A2E33), fontWeight: FontWeight.w500, fontSize: 16),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )),
            ],
          ).appPaddingForScreen,
        ));
  }
}
