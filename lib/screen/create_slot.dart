import 'dart:async';
import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../controllers/slot_controller.dart';
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
  final slotController = Get.put(SlotController());
  Duration startDuration = const Duration(hours: 9, minutes: 00);
  Duration endDuration = const Duration(hours: 19, minutes: 00);
  DateTime get startDateTime => startDuration.fromTodayStart;

  DateTime get endDateTime => startDuration.inMinutes > endDuration.inMinutes
      ? endDuration.fromTodayStart.add(const Duration(days: 1))
      : endDuration.fromTodayStart;

  clearSlots() {
    if (slotController.slots.isNotEmpty) {
      slotController.slots.clear();
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
    // slotController.startTime.clear();
    // slotController.endTime.clear();
    // slotController.serviceDuration.clear();
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10,),
        Row(
          children: [
            Expanded(
              child: Text(
                !slotController.resetSlots ? "Create Slot".tr : "Create Slot".tr,
                style:
                    GoogleFonts.poppins(fontWeight: FontWeight.w500, color: const Color(0xff2F2F2F), fontSize: 15),
              ),
            ),
            if (slotController.serviceTimeSloat.isNotEmpty)
              TextButton(
                  onPressed: () {
                    slotController.resetSlots = !slotController.resetSlots;
                    setState(() {});
                  },
                  child: Text(!slotController.resetSlots ? "Create Slot".tr : "Previous Slot".tr))
          ],
        ),
        if (slotController.resetSlots == true ||
            !(slotController.serviceTimeSloat.isNotEmpty)) ...[
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
                        slotController.startTime.text = "$hour : $inMinute";
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
                                slotController.startTime.text = "$hour : $inMinute";
                                clearSlots();
                                setState(() {});
                              });
                            },
                          ),
                        );
                      },
                      hint: "Start Time".tr,
                      controller: slotController.startTime,
                      validator: (value) {
                        if (value!.trim().isEmpty) {
                          return "Start time is required".tr;
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
                        slotController.endTime.text = "$hour : $inMinute";
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
                                slotController.endTime.text = "$hour : $inMinute";
                                clearSlots();
                                setState(() {});
                              });
                            },
                          ),
                        );
                      },
                      hint: "End Time".tr,
                      controller: slotController.endTime,
                      validator: (value) {
                        if (value!.trim().isEmpty) {
                          return "End time is required".tr;
                        }
                        if(endDuration<=startDuration){
                          return  "Start time is less than end time".tr;
                        }
                        return null;
                      }),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          RegisterTextFieldWidget(
              controller: slotController.serviceDuration,
              onChanged: (f) {
                clearSlots();
              },
              hint: "Interval Time".tr,
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value!.trim().isEmpty) {
                  return "Service duration is required".tr;
                }
                if (startDateTime
                        .difference(endDateTime)
                        .abs()
                        .compareTo(Duration(minutes: int.tryParse(value) ?? 0)) ==
                    -1) {
                  return "Service duration is greater then start & end time duration".tr;
                }
                return null;
              }),
          const SizedBox(height: 10,),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    if (slotController.startTime.text.trim().isEmpty) {
                      showToast("Select start time".tr);
                      return;
                    }
                    if (slotController.endTime.text.trim().isEmpty) {
                      showToast("Select end time".tr);
                      return;
                    }
                    if (slotController.serviceDuration.text.trim().isEmpty) {
                      showToast("Select service duration".tr);
                      return;
                    }

                    slotController.slots.clear();
                    if (kDebugMode) {
                      print(startDateTime.difference(endDateTime).abs());
                      print(startDateTime
                          .difference(endDateTime)
                          .abs()
                          .compareTo(Duration(minutes: int.tryParse(slotController.serviceDuration.text) ?? 0)));
                      print(startDateTime
                              .difference(endDateTime)
                              .abs()
                              .compareTo(Duration(minutes: int.tryParse(slotController.serviceDuration.text) ?? 0)) ==
                          -1);
                    }

                    Duration minutes = Duration(minutes: int.tryParse(slotController.serviceDuration.text) ?? 0);

                    DateTime temp = startDateTime;
                    while (temp.millisecondsSinceEpoch < endDateTime.millisecondsSinceEpoch) {
                      slotController.slots[{temp: temp.add(minutes)}] = false;
                      temp = temp.add(minutes);
                    }
                    FocusManager.instance.primaryFocus!.unfocus();
                    setState(() {});
                    // updateValues();
                    log(slotController.slots.toString());
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryColor,
                      surfaceTintColor: AppTheme.primaryColor,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5))),
                  child: Text(
                    slotController.slots.isEmpty ? "Create Slot".tr : "Slots Created - ${slotController.slots.length}",
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
            constraints: const BoxConstraints(maxHeight: 200, minHeight: 0),
            child: Scrollbar(
              thumbVisibility: false, //always show scrollbar
              thickness: 5, //width of scrollbar
              interactive: true,
              radius: const Radius.circular(20), //corner radius of scrollbar
              scrollbarOrientation: ScrollbarOrientation.right, //which side to show scrollbar
              child: ListView.builder(
                  itemCount: slotController.slots.length,
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
            constraints: const BoxConstraints(maxHeight: 100, minHeight: 0),
            child: Scrollbar(
              thumbVisibility: false, //always show scrollbar
              thickness: 5, //width of scrollbar
              interactive: true,
              radius: const Radius.circular(20), //corner radius of scrollbar
              scrollbarOrientation: ScrollbarOrientation.right, //which side to show scrollbar
              child: ListView.builder(
                  itemCount: slotController.serviceTimeSloat.length,
                  padding: const EdgeInsets.only(top: 10),
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    final item = slotController.serviceTimeSloat[index];
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
                              slotController.serviceTimeSloat.removeAt(index);
                              if (slotController.serviceTimeSloat.isEmpty) {
                                slotController.resetSlots = true;
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
    );
  }
}


class DinnerCreateSlotsScreen extends StatefulWidget {
  const DinnerCreateSlotsScreen({super.key});

  @override
  State<DinnerCreateSlotsScreen> createState() => _DinnerCreateSlotsScreenState();
}

class _DinnerCreateSlotsScreenState extends State<DinnerCreateSlotsScreen> {
  final slotController = Get.put(SlotController());
  Duration startDuration = const Duration(hours: 9, minutes: 00);
  Duration endDuration = const Duration(hours: 19, minutes: 00);
  DateTime get startDateTime => startDuration.fromTodayStart;

  DateTime get endDateTime => startDuration.inMinutes > endDuration.inMinutes
      ? endDuration.fromTodayStart.add(const Duration(days: 1))
      : endDuration.fromTodayStart;

  clearSlots() {
    if (slotController.dinnerSlots.isNotEmpty) {
      slotController.dinnerSlots.clear();
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
    // slotController.dinnerStartTime.clear();
    // slotController.dinnerEndTime.clear();
    // slotController.dinnerServiceDuration.clear();
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10,),
        Row(
          children: [
            Expanded(
              child: Text(
                !slotController.dinnerResetSlots ? "Create Slot".tr : "Create Slot".tr,
                style:
                GoogleFonts.poppins(fontWeight: FontWeight.w500, color: const Color(0xff2F2F2F), fontSize: 15),
              ),
            ),
            if (slotController.dinnerServiceTimeSloat.isNotEmpty)
              TextButton(
                  onPressed: () {
                    slotController.dinnerResetSlots = !slotController.dinnerResetSlots;
                    setState(() {});
                  },
                  child: Text(!slotController.dinnerResetSlots ? "Create Slot".tr : "Previous Slot".tr))
          ],
        ),
        if (slotController.dinnerResetSlots == true || !(slotController.dinnerServiceTimeSloat.isNotEmpty)) ...[
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                  child: RegisterTextFieldWidget(
                      readOnly: true,
                      hint: "Start Time".tr,
                      onTap: () {
                        String hour =
                            "${startDuration.inHours < 10 ? "0${startDuration.inHours}" : startDuration.inHours}";
                        int minute = startDuration.inMinutes % 60;
                        String inMinute = "${minute < 10 ? "0$minute" : minute}";
                        slotController.dinnerStartTime.text = "$hour : $inMinute";
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
                                slotController.dinnerStartTime.text = "$hour : $inMinute";
                                clearSlots();
                                setState(() {});
                              });
                            },
                          ),
                        );
                      },
                      controller: slotController.dinnerStartTime,
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
                      hint: "End Time".tr,
                      onTap: () {
                        String hour =
                            "${endDuration.inHours < 10 ? "0${endDuration.inHours}" : endDuration.inHours}";
                        int minute = endDuration.inMinutes % 60;
                        String inMinute = "${minute < 10 ? "0$minute" : minute}";
                        slotController.dinnerEndTime.text = "$hour : $inMinute";
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
                                slotController.dinnerEndTime.text = "$hour : $inMinute";
                                clearSlots();
                                setState(() {});
                              });
                            },
                          ),
                        );
                      },
                      controller: slotController.dinnerEndTime,
                      validator: (value) {
                        if (value!.trim().isEmpty) {
                          return "End time is required".tr;
                        }
                        if(endDuration<=startDuration){
                          return  "Start time is less than end time".tr;
                        }
                        return null;
                      }),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          RegisterTextFieldWidget(
              controller: slotController.dinnerServiceDuration,
              hint: "Interval Time",
              onChanged: (f) {
                clearSlots();
              },
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value!.trim().isEmpty) {
                  return "Service duration is required".tr;
                }
                if (startDateTime
                    .difference(endDateTime)
                    .abs()
                    .compareTo(Duration(minutes: int.tryParse(value) ?? 0)) ==
                    -1) {
                  return "Service duration is greater then start & end time duration".tr;
                }
                return null;
              }),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    if (slotController.dinnerStartTime.text.trim().isEmpty) {
                      showToast("Select start time".tr);
                      return;
                    }
                    if (slotController.dinnerEndTime.text.trim().isEmpty) {
                      showToast("Select end time".tr);
                      return;
                    }
                    if (slotController.dinnerServiceDuration.text.trim().isEmpty) {
                      showToast("Select service duration".tr);
                      return;
                    }

                    slotController.dinnerSlots.clear();
                    if (kDebugMode) {
                      print(startDateTime.difference(endDateTime).abs());
                      print(startDateTime
                          .difference(endDateTime)
                          .abs()
                          .compareTo(Duration(minutes: int.tryParse(slotController.dinnerServiceDuration.text) ?? 0)));
                      print(startDateTime
                          .difference(endDateTime)
                          .abs()
                          .compareTo(Duration(minutes: int.tryParse(slotController.dinnerServiceDuration.text) ?? 0)) ==
                          -1);
                    }

                    Duration minutes = Duration(minutes: int.tryParse(slotController.dinnerServiceDuration.text) ?? 0);

                    DateTime temp = startDateTime;
                    while (temp.millisecondsSinceEpoch < endDateTime.millisecondsSinceEpoch) {
                      slotController.dinnerSlots[{temp: temp.add(minutes)}] = false;
                      temp = temp.add(minutes);
                    }
                    FocusManager.instance.primaryFocus!.unfocus();
                    setState(() {});
                    // updateValues();
                    log(slotController.dinnerSlots.toString());
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryColor,
                      surfaceTintColor: AppTheme.primaryColor,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5))),
                  child: Text(
                    slotController.dinnerSlots.isEmpty ? "Create Slot".tr : "Slots Created - ${slotController.dinnerSlots.length}",
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
            constraints: const BoxConstraints(maxHeight: 200, minHeight: 0),
            child: Scrollbar(
              thumbVisibility: false, //always show scrollbar
              thickness: 5, //width of scrollbar
              interactive: true,
              radius: const Radius.circular(20), //corner radius of scrollbar
              scrollbarOrientation: ScrollbarOrientation.right, //which side to show scrollbar
              child: ListView.builder(
                  itemCount: slotController.dinnerSlots.length,
                  padding: const EdgeInsets.only(top: 10),
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return DinnerSingleSlotUI(
                      index: index,
                      endDateTime: endDateTime,
                    );
                  }),
            ),
          ),
        ] else
          Container(
            constraints: const BoxConstraints(maxHeight: 100, minHeight: 0),
            child: Scrollbar(
              thumbVisibility: false, //always show scrollbar
              thickness: 5, //width of scrollbar
              interactive: true,
              radius: const Radius.circular(20), //corner radius of scrollbar
              scrollbarOrientation: ScrollbarOrientation.right, //which side to show scrollbar
              child: ListView.builder(
                  itemCount: slotController.dinnerServiceTimeSloat.length,
                  padding: const EdgeInsets.only(top: 10),
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    final item = slotController.dinnerServiceTimeSloat[index];
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
                              slotController.dinnerServiceTimeSloat.removeAt(index);
                              if (slotController.dinnerServiceTimeSloat.isEmpty) {
                                slotController.dinnerResetSlots = true;
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
    );
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
  const SingleSlotUI({super.key, required this.index, required this.endDateTime,});

  @override
  State<SingleSlotUI> createState() => _SingleSlotUIState();
}

class _SingleSlotUIState extends State<SingleSlotUI> {
  final DateFormat timeFormat = DateFormat("hh:mm a");
  final slotController = Get.put(SlotController());
  @override
  Widget build(BuildContext context) {
    if (kDebugMode) {
      print("SingleSlotUI...........      building");
    }
    return CheckboxListTile(
        value: slotController.slots.values.toList()[widget.index],
        onChanged: (ff) {
          if (ff == null) return;
          slotController.slots[slotController.slots.keys.toList()[widget.index]] = ff;
          setState(() {});
        },
        visualDensity: const VisualDensity(vertical: -4, horizontal: -3),
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Flexible(
              child: Text("${timeFormat.format(slotController.slots.keys.toList()[widget.index].keys.first)} -- "
                  "${timeFormat.format(slotController.slots.keys.toList()[widget.index].values.first)}"),
            ),
            // if (slotController.slots.keys.toList()[widget.index].values.first.millisecondsSinceEpoch >
            //     widget.endDateTime.millisecondsSinceEpoch)
            //   Text(
            //     " Exceeded",
            //     style:
            //         GoogleFonts.poppins(color: AppTheme.greycolor, fontWeight: FontWeight.w500, height: 1.8, fontSize: 12),
            //   )
          ],
        ));
  }
}

class DinnerSingleSlotUI extends StatefulWidget {
  final int index;
  final DateTime endDateTime;
  const DinnerSingleSlotUI({super.key, required this.index, required this.endDateTime,});

  @override
  State<DinnerSingleSlotUI> createState() => _DinnerSingleSlotUIState();
}

class _DinnerSingleSlotUIState extends State<DinnerSingleSlotUI> {
  final DateFormat timeFormat = DateFormat("hh:mm a");
  final slotController = Get.put(SlotController());
  @override
  Widget build(BuildContext context) {
    if (kDebugMode) {
      print("SingleSlotUI...........      building");
    }
    return CheckboxListTile(
        value: slotController.dinnerSlots.values.toList()[widget.index],
        onChanged: (ff) {
          if (ff == null) return;
          slotController.dinnerSlots[slotController.dinnerSlots.keys.toList()[widget.index]] = ff;
          setState(() {});
        },
        visualDensity: const VisualDensity(vertical: -4, horizontal: -3),
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Flexible(
              child: Text("${timeFormat.format(slotController.dinnerSlots.keys.toList()[widget.index].keys.first)} -- "
                  "${timeFormat.format(slotController.dinnerSlots.keys.toList()[widget.index].values.first)}"),
            ),
            // if (slotController.dinnerSlots.keys.toList()[widget.index].values.first.millisecondsSinceEpoch >
            //     widget.endDateTime.millisecondsSinceEpoch)
            //   Text(
            //     " Exceeded",
            //     style:
            //     GoogleFonts.poppins(color: AppTheme.greycolor, fontWeight: FontWeight.w500, height: 1.8, fontSize: 12),
            //   )
          ],
        ));
  }
}
