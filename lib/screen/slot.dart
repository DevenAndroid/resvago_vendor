import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../widget/addsize.dart';
import 'create_slot.dart';

class BookableUI extends StatefulWidget {
  const BookableUI({super.key});

  @override
  State<BookableUI> createState() => _BookableUIState();
}

class _BookableUIState extends State<BookableUI> {
  final DateFormat selectedDateFormat = DateFormat("dd-MMM-yyyy");
  RxString bookingType = "Virtual".obs;
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
    return const Column(
      children: [
        CreateSlotsScreen(),
      ],
    );
  }

  Card bookingTypeCard() {
    return Card(
        color: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 3,
        margin: const EdgeInsets.only(bottom: 14),
        child: Padding(
            padding: EdgeInsets.symmetric(horizontal: AddSize.padding16, vertical: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Booking Type",
                  style: GoogleFonts.poppins(fontWeight: FontWeight.w500, color: const Color(0xff2F2F2F), fontSize: 15),
                ),
                Row(
                  children: [
                    Flexible(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Obx(() {
                              return Radio<String>(
                                  value: "Virtual",
                                  groupValue: bookingType.value,
                                  visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
                                  onChanged: (v) {
                                    if (v == null) return;
                                    bookingType.value = v;
                                    // updateValues();
                                  });
                            }),
                            Flexible(
                              child: GestureDetector(
                                onTap: () {
                                  bookingType.value = "Virtual";
                                  // updateValues();
                                },
                                behavior: HitTestBehavior.translucent,
                                child: Text(
                                  "Virtual",
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
                                  value: "Personal",
                                  groupValue: bookingType.value,
                                  visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
                                  onChanged: (v) {
                                    if (v == null) return;
                                    bookingType.value = v;
                                    // updateValues();
                                  });
                            }),
                            Flexible(
                              child: GestureDetector(
                                onTap: () {
                                  bookingType.value = "Personal";
                                  // updateValues();
                                },
                                behavior: HitTestBehavior.translucent,
                                child: Text(
                                  "Personal",
                                  style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w400, color: const Color(0xff2F2F2F), fontSize: 14),
                                ),
                              ),
                            ),
                          ],
                        )),
                  ],
                ),
              ],
            )));
  }
}
