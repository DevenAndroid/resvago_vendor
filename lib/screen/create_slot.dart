import 'dart:async';
import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../helper.dart';
import '../model/slot_model.dart';
import '../widget/apptheme.dart';
import '../widget/common_text_field.dart';

class CreateSlotsScreen extends StatefulWidget {
  const CreateSlotsScreen({super.key});

  @override
  State<CreateSlotsScreen> createState() => _CreateSlotsScreenState();
}

class _CreateSlotsScreenState extends State<CreateSlotsScreen> {
  final TextEditingController startTime = TextEditingController();
  final TextEditingController endTime = TextEditingController();
  final TextEditingController serviceDuration = TextEditingController();
  final TextEditingController startDate = TextEditingController();
  final TextEditingController endDate = TextEditingController();
  final DateFormat timeFormat = DateFormat("hh:mm a");
  Map<Map<DateTime, DateTime>, bool> slots = {};
  List<ServiceTimeSloat> serviceTimeSloat = [];
  Duration startDuration = const Duration(hours: 9, minutes: 00);
  Duration endDuration = const Duration(hours: 19, minutes: 00);
  bool resetSlots = false;
  DateTime get startDateTime => startDuration.fromTodayStart;

  DateTime get endDateTime => startDuration.inMinutes > endDuration.inMinutes
      ? endDuration.fromTodayStart.add(const Duration(days: 1))
      : endDuration.fromTodayStart;

  clearSlots() {
    if (slots.isNotEmpty) {
      slots.clear();
      setState(() {});
    }
  }

  void _showDialog(Widget child) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => Container(
        height: 216,
        padding: const EdgeInsets.only(top: 6.0),
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        color: CupertinoColors.systemBackground.resolveFrom(context),
        child: SafeArea(
          top: false,
          child: child,
        ),
      ),
    );
  }

  Timer? debounce;

  makeDelay({required Function(bool gg) nowPerform}) {
    if (debounce != null) {
      debounce!.cancel();
    }
    debounce = Timer(const Duration(milliseconds: 600), () {
      nowPerform(true);
    });
  }

  @override
  void initState() {
    super.initState();
    startTime.clear();
    endTime.clear();
    serviceDuration.clear();
  }

  @override
  void dispose() {
    super.dispose();
    if (debounce != null) {
      debounce!.cancel();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (kDebugMode) {
      print("CreateSlotsScreen...........      building");
    }
    return Card(
        color: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 3,
        margin: const EdgeInsets.only(bottom: 14),
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15).copyWith(bottom: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        !resetSlots ? "Create Slots" : "Create Slot",
                        style:
                        GoogleFonts.poppins(fontWeight: FontWeight.w500, color: const Color(0xff2F2F2F), fontSize: 15),
                      ),
                    ),
                    if (serviceTimeSloat.isNotEmpty)
                      TextButton(
                          onPressed: () {
                            resetSlots = !resetSlots;
                            setState(() {});
                          },
                          child: Text(!resetSlots ? "Create Slots" : "Previous Slots"))
                  ],
                ),
                if (resetSlots == true ||
                    !(serviceTimeSloat.isNotEmpty)) ...[
                  IntrinsicHeight(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Flexible(
                          child: RegisterTextFieldWidget(
                              readOnly: true,
                              onTap: () {
                                String hour =
                                    "${startDuration.inHours < 10 ? "0${startDuration.inHours}" : startDuration.inHours}";
                                int minute = startDuration.inMinutes % 60;
                                String inMinute = "${minute < 10 ? "0$minute" : minute}";
                                startTime.text = "$hour : $inMinute";
                                clearSlots();
                                _showDialog(
                                  CupertinoTimerPicker(
                                    mode: CupertinoTimerPickerMode.hm,
                                    initialTimerDuration: startDuration,
                                    onTimerDurationChanged: (Duration newDuration) {
                                      makeDelay(nowPerform: (bool v) {
                                        startDuration = newDuration;
                                        if (kDebugMode) {
                                          print("performed....    $startDuration");
                                        }
                                        String hour =
                                            "${startDuration.inHours < 10 ? "0${startDuration.inHours}" : startDuration.inHours}";
                                        int minute = startDuration.inMinutes % 60;
                                        String inMinute = "${minute < 10 ? "0$minute" : minute}";
                                        startTime.text = "$hour : $inMinute";
                                        clearSlots();
                                        setState(() {});
                                      });
                                    },
                                  ),
                                );
                              },
                              controller: startTime,
                              validator: (value) {
                                if (value!.trim().isEmpty) {
                                  return "Start time is required";
                                }
                                return null;
                              }),
                        ),
                        const SizedBox(
                          width: 16,
                        ),
                        Flexible(
                          child: RegisterTextFieldWidget(
                              readOnly: true,
                              onTap: () {
                                String hour =
                                    "${endDuration.inHours < 10 ? "0${endDuration.inHours}" : endDuration.inHours}";
                                int minute = endDuration.inMinutes % 60;
                                String inMinute = "${minute < 10 ? "0$minute" : minute}";
                                endTime.text = "$hour : $inMinute";
                                clearSlots();
                                _showDialog(
                                  CupertinoTimerPicker(
                                    mode: CupertinoTimerPickerMode.hm,
                                    initialTimerDuration: endDuration,
                                    // This is called when the user changes the timer's
                                    // duration.
                                    onTimerDurationChanged: (Duration newDuration) {
                                      makeDelay(nowPerform: (bool v) {
                                        endDuration = newDuration;
                                        if (kDebugMode) {
                                          print("performed....    $endDuration");
                                        }
                                        String hour =
                                            "${endDuration.inHours < 10 ? "0${endDuration.inHours}" : endDuration.inHours}";
                                        int minute = endDuration.inMinutes % 60;
                                        String inMinute = "${minute < 10 ? "0$minute" : minute}";
                                        endTime.text = "$hour : $inMinute";
                                        clearSlots();
                                        setState(() {});
                                      });
                                    },
                                  ),
                                );
                              },
                              controller: endTime,
                              validator: (value) {
                                if (value!.trim().isEmpty) {
                                  return "End time is required";
                                }
                                return null;
                              }),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  RegisterTextFieldWidget(
                      controller: serviceDuration,
                      onChanged: (f) {
                        clearSlots();
                      },
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value!.trim().isEmpty) {
                          return "Service duration is required";
                        }
                        if (startDateTime
                            .difference(endDateTime)
                            .abs()
                            .compareTo(Duration(minutes: int.tryParse(value) ?? 0)) ==
                            -1) {
                          return "Service duration is greater then start & end time duration";
                        }
                        return null;
                      }),

                  Row(

                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            if (startTime.text.trim().isEmpty) {
                              showToast("Select start time");
                              return;
                            }
                            if (endTime.text.trim().isEmpty) {
                              showToast("Select end time");
                              return;
                            }
                            if (serviceDuration.text.trim().isEmpty) {
                              showToast("Select service duration");
                              return;
                            }

                            slots.clear();
                            if (kDebugMode) {
                              print(startDateTime.difference(endDateTime).abs());
                              print(startDateTime
                                  .difference(endDateTime)
                                  .abs()
                                  .compareTo(Duration(minutes: int.tryParse(serviceDuration.text) ?? 0)));
                              print(startDateTime
                                  .difference(endDateTime)
                                  .abs()
                                  .compareTo(Duration(minutes: int.tryParse(serviceDuration.text) ?? 0)) ==
                                  -1);
                            }

                            Duration minutes = Duration(minutes: int.tryParse(serviceDuration.text) ?? 0);

                            DateTime temp = startDateTime;
                            while (temp.millisecondsSinceEpoch < endDateTime.millisecondsSinceEpoch) {
                              slots[{temp: temp.add(minutes)}] = false;
                              temp = temp.add(minutes);
                            }
                            FocusManager.instance.primaryFocus!.unfocus();
                            setState(() {});
                            // updateValues();
                            log(slots.toString());
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.primaryColor,
                              surfaceTintColor: AppTheme.primaryColor,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5))),
                          child: Text(
                            slots.isEmpty ? "Create Slot" : "Slots Created - ${slots.length}",
                            style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 15),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Container(
                    constraints: const BoxConstraints(maxHeight: 200, minHeight: 100),
                    child: Scrollbar(
                      thumbVisibility: false, //always show scrollbar
                      thickness: 5, //width of scrollbar
                      interactive: true,
                      radius: const Radius.circular(20), //corner radius of scrollbar
                      scrollbarOrientation: ScrollbarOrientation.right, //which side to show scrollbar
                      child: ListView.builder(
                          itemCount: slots.length,
                          padding: const EdgeInsets.only(top: 10),
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return SingleSlotUI(
                              index: index,
                              endDateTime: endDateTime,
                            );
                          }),
                    ),
                  ),
                ] else
                  Container(
                    constraints: const BoxConstraints(maxHeight: 40 * .52, minHeight: 0),
                    child: Scrollbar(
                      thumbVisibility: false, //always show scrollbar
                      thickness: 5, //width of scrollbar
                      interactive: true,
                      radius: const Radius.circular(20), //corner radius of scrollbar
                      scrollbarOrientation: ScrollbarOrientation.right, //which side to show scrollbar
                      child: ListView.builder(
                          itemCount: serviceTimeSloat.length,
                          padding: const EdgeInsets.only(top: 10),
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            final item = serviceTimeSloat[index];
                            return Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    "Start Time: ${item.timeSloat}",
                                    style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w500),
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    "End Time: ${item.timeSloatEnd.toString()}",
                                    style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w500),
                                  ),
                                ),
                                IconButton(
                                    onPressed: () {
                                      serviceTimeSloat.removeAt(index);
                                      if (serviceTimeSloat.isEmpty) {
                                        resetSlots = true;
                                      }
                                      setState(() {});
                                    },
                                    padding: EdgeInsets.zero,
                                    visualDensity: VisualDensity.compact,
                                    icon: const Icon(Icons.clear))
                              ],
                            );
                          }),
                    ),
                  ),
              ],
            )));
  }
}
extension ConvertToDateon on Duration {
  DateTime get fromTodayStart {
    DateTime now = DateTime.now();
    DateTime gg = DateTime(now.year, now.month, now.day);
    return gg.add(this);
  }
}
class SingleSlotUI extends StatefulWidget {
  final int index;
  final DateTime endDateTime;
  const SingleSlotUI({super.key, required this.index, required this.endDateTime});

  @override
  State<SingleSlotUI> createState() => _SingleSlotUIState();
}

class _SingleSlotUIState extends State<SingleSlotUI> {

  final DateFormat timeFormat = DateFormat("hh:mm a");
  Map<Map<DateTime, DateTime>, bool> slots = {};
  @override
  Widget build(BuildContext context) {
    if (kDebugMode) {
      print("SingleSlotUI...........      building");
    }
    return CheckboxListTile(
        value: slots.values.toList()[widget.index],
        onChanged: (ff) {
          if (ff == null) return;
          slots[slots.keys.toList()[widget.index]] = ff;
          setState(() {});
        },
        visualDensity: const VisualDensity(vertical: -4, horizontal: -3),
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Flexible(
              child: Text("${timeFormat.format(slots.keys.toList()[widget.index].keys.first)} -- "
                  "${timeFormat.format(slots.keys.toList()[widget.index].values.first)}"),
            ),
            if (slots.keys.toList()[widget.index].values.first.millisecondsSinceEpoch >
                widget.endDateTime.millisecondsSinceEpoch)
              Text(
                " Exceeded",
                style:
                GoogleFonts.poppins(color: AppTheme.greycolor, fontWeight: FontWeight.w500, height: 1.8, fontSize: 12),
              )
          ],
        ));
  }
}