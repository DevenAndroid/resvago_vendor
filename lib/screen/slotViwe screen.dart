import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:resvago_vendor/widget/custom_textfield.dart';
import '../model/createslot_model.dart';

class SlotViewScreen extends StatefulWidget {
  final String slotId;
  CreateSlotData? slotDataList;
  SlotViewScreen({super.key, required this.slotId, this.slotDataList});

  @override
  State<SlotViewScreen> createState() => _SlotViewScreenState();
}

class _SlotViewScreenState extends State<SlotViewScreen> {
  String get slotId => widget.slotId;
  CreateSlotData? get slotDataList => widget.slotDataList;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: backAppBar(title: "Slot View", context: context),
        body: Column(
          children: [
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 15),
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Start Date",
                            style: GoogleFonts.poppins(
                                color: const Color(0xFF1A2E33), fontWeight: FontWeight.w300, fontSize: 16),
                          ),
                          Text(
                            slotDataList!.startDateForLunch  ?? "".toString(),
                            style: GoogleFonts.poppins(
                                color: const Color(0xFF1A2E33), fontWeight: FontWeight.w500, fontSize: 16),
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
                            "End Date",
                            style: GoogleFonts.poppins(
                                color: const Color(0xFF1A2E33), fontWeight: FontWeight.w300, fontSize: 16),
                          ),
                          Text(
                            slotDataList!.endDateForLunch ?? "".toString(),
                            style: GoogleFonts.poppins(
                                color: const Color(0xFF1A2E33), fontWeight: FontWeight.w500, fontSize: 16),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      FittedBox(
                        child: Row(
                          children: List.generate(
                              25,
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
                            "Lunch Start Time ",
                            style: GoogleFonts.poppins(
                                color: const Color(0xFF1A2E33), fontWeight: FontWeight.w300, fontSize: 16),
                          ),
                          Text(
                            slotDataList!.startTimeForLunch ?? "".toString(),
                            style: GoogleFonts.poppins(
                                color: const Color(0xFF1A2E33), fontWeight: FontWeight.w500, fontSize: 16),
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
                            "Lunch End Time ",
                            style: GoogleFonts.poppins(
                                color: const Color(0xFF1A2E33), fontWeight: FontWeight.w300, fontSize: 16),
                          ),
                          Text(
                              slotDataList!.endTimeForLunch ?? "".toString(),
                            style: GoogleFonts.poppins(
                                color: const Color(0xFF1A2E33), fontWeight: FontWeight.w500, fontSize: 16),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      FittedBox(
                        child: Row(
                          children: List.generate(
                              25,
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
                            "Number of Guest",
                            style: GoogleFonts.poppins(
                                color: const Color(0xFF1A2E33), fontWeight: FontWeight.w300, fontSize: 16),
                          ),
                          Text(
                            slotDataList!.noOfGuest ?? "".toString(),
                            style: GoogleFonts.poppins(
                                color: const Color(0xFF1A2E33), fontWeight: FontWeight.w500, fontSize: 16),
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
                            "Interval TIme",
                            style: GoogleFonts.poppins(
                                color: const Color(0xFF1A2E33), fontWeight: FontWeight.w300, fontSize: 16),
                          ),
                          Text(
                            "${slotDataList!.lunchDuration ?? " ".toString()} Mins",
                            style: GoogleFonts.poppins(
                                color: const Color(0xFF1A2E33), fontWeight: FontWeight.w500, fontSize: 16),
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
                            "Offers",
                            style: GoogleFonts.poppins(
                                color: const Color(0xFF1A2E33), fontWeight: FontWeight.w300, fontSize: 16),
                          ),
                          Text(
                            "${slotDataList!.setOffer ?? "".toString()}%",
                            style: GoogleFonts.poppins(
                                color: const Color(0xFF1A2E33), fontWeight: FontWeight.w500, fontSize: 16),
                          ),
                        ],
                      ),
                    ],
                  ),
                )),
          ],
        ));
  }
}
