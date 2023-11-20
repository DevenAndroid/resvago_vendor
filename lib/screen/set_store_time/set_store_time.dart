import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:resvago_vendor/utils/helper.dart';
import 'package:resvago_vendor/widget/app_strings_file.dart';
import '../../Firebase_service/firebase_service.dart';
import '../../helper.dart';
import '../../model/menu_model.dart';
import '../../model/set_store_time_model.dart';
import '../../widget/appassets.dart';
import '../../widget/apptheme.dart';
import '../../widget/custom_textfield.dart';

class SetTimeScreen extends StatefulWidget {
  const SetTimeScreen({Key? key}) : super(key: key);
  static var route = "/setTimeScreen";

  @override
  State<SetTimeScreen> createState() => _SetTimeScreenState();
}

class _SetTimeScreenState extends State<SetTimeScreen> {
  Timer? debounce;

  makeDelay({required Function(bool gg) nowPerform}) {
    if (debounce != null) {
      debounce!.cancel();
    }
    debounce = Timer(const Duration(milliseconds: 600), () {
      nowPerform(true);
    });
  }

  FirebaseService firebaseService = FirebaseService();
  FirebaseFirestore firestore = FirebaseFirestore.instance;

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

  List<String> weekDays = [
    "Mon",
    "Tue",
    "Wed",
    "Thu",
    "Fri",
    "Sat",
    "Sun",
  ];

  List<Map<dynamic, dynamic>> weekSchedule = [];
  List<Map<String, dynamic>> weekSchedule1 = [];
  @override
  void initState() {
    super.initState();
    weekSchedule.clear();
    weekSchedule = generateWeekSchedule();
    log(weekSchedule.toString());
    getWeekSchedule(userId);
  }

  @override
  void dispose() {
    super.dispose();
    if (debounce != null) {
      debounce!.cancel();
    }
  }

  List<Map<dynamic, dynamic>> generateWeekSchedule() {
    List<Map<dynamic, dynamic>> weekSchedule = [];

    DateTime currentDate = DateTime.now();
    DateTime startTime = DateTime(currentDate.year, currentDate.month, currentDate.day, 9, 0);
    DateTime endTime = DateTime(currentDate.year, currentDate.month, currentDate.day, 19, 0);
    String formattedStartTime = DateFormat.Hm().format(startTime);
    String formattedEndTime = DateFormat.Hm().format(endTime);
    bool status = false;
    for (var element in weekDays) {
      weekSchedule.add({
        'day': element,
        'start_time': formattedStartTime,
        'end_time': formattedEndTime,
        'status': status,
      });
    }
    setState(() {

    });
    return weekSchedule;
  }

  void uploadWeekSchedule(String userId, List<Map<dynamic, dynamic>> weekSchedule) {
    FirebaseFirestore.instance.collection('week_schedules').doc(userId).set({
      'schedule': weekSchedule,
    }).then((value) {
      showToast("Availability updated Successfully");
      weekSchedule.clear();
    }).catchError((error) {
      if (kDebugMode) {
        print('Failed to upload week schedule: $error');
      }
    });
  }

  Future<List<Map<String, dynamic>>> getWeekSchedule(String userId) async {
    try {
      DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance.collection('week_schedules').doc(userId).get();
      if (documentSnapshot.exists) {
        Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;
        List<Map<String, dynamic>> weekSchedule = List.from(data['schedule']);
        weekSchedule1 = weekSchedule;
        log(weekSchedule1.toString());
        setState(() {

        });
        return weekSchedule;
      } else {
        return [];
      }
    } catch (error) {
      rethrow;
    }
  }

  String userId = FirebaseAuth.instance.currentUser!.uid!; // Replace this with the actual user ID
  @override
  Widget build(BuildContext context) {
    for(var i = 0; i < 20; i++){
      print(DateFormat('EEE').format(DateTime.now().add(Duration(days: i))));
    }
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: backAppBar(title: AppStrings.setStoreTime.tr, context: context, backgroundColor: Colors.white),
        body: ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.symmetric(horizontal: 16).copyWith(top: 10),
          children: [
            if (weekSchedule.isNotEmpty && weekSchedule1.isEmpty)
              ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  physics: const BouncingScrollPhysics(),
                  itemCount: weekSchedule.length,
                  itemBuilder: (context, index) {
                    var itemData = weekSchedule[index];
                    return Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Container(
                        decoration:
                            BoxDecoration(borderRadius: BorderRadius.circular(10), border: Border.all(color: AppTheme.greycolor)),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Theme(
                              data: ThemeData(
                                  checkboxTheme:
                                      CheckboxThemeData(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)))),
                              child: Checkbox(
                                activeColor: AppTheme.primaryColor,
                                checkColor: Colors.white,
                                value: itemData["status"],
                                onChanged: (value) {
                                  itemData["status"] = value;
                                  log(itemData["status"].toString());
                                  setState(() {});
                                },
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: Text(
                                itemData["day"].toString(),
                                style:
                                    GoogleFonts.poppins(color: Colors.grey.shade900, fontSize: 14, fontWeight: FontWeight.w400),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: GestureDetector(
                                onTap: () {
                                  if ((itemData["status"] ?? false) == false) return;
                                  _showDialog(
                                    CupertinoTimerPicker(
                                      mode: CupertinoTimerPickerMode.hm,
                                      initialTimerDuration: itemData["start_time"].toString().durationTime,
                                      onTimerDurationChanged: (Duration newDuration) {
                                        makeDelay(nowPerform: (bool v) {
                                          String hour =
                                              "${newDuration.inHours < 10 ? "0${newDuration.inHours}" : newDuration.inHours}";
                                          int minute = newDuration.inMinutes % 60;
                                          String inMinute = "${minute < 10 ? "0$minute" : minute}";
                                          itemData["start_time"] = "$hour:$inMinute";
                                          setState(() {});
                                        });
                                      },
                                    ),
                                  );
                                },
                                child: Row(
                                  children: [
                                    Text(
                                      itemData["start_time"].toString().normalTime,
                                      style: GoogleFonts.poppins(
                                          fontWeight: FontWeight.w500, fontSize: 15, color: Colors.grey.shade700),
                                    ),
                                    const Icon(Icons.keyboard_arrow_down_rounded)
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                "To",
                                style:
                                    GoogleFonts.poppins(color: Colors.grey.shade900, fontSize: 14, fontWeight: FontWeight.w400),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: GestureDetector(
                                onTap: () {
                                  if ((itemData["status"] ?? false) == false) return;
                                  _showDialog(
                                    CupertinoTimerPicker(
                                      mode: CupertinoTimerPickerMode.hm,
                                      initialTimerDuration: itemData["end_time"].toString().durationTime,
                                      onTimerDurationChanged: (Duration newDuration) {
                                        makeDelay(nowPerform: (bool v) {
                                          String hour =
                                              "${newDuration.inHours < 10 ? "0${newDuration.inHours}" : newDuration.inHours}";
                                          int minute = newDuration.inMinutes % 60;
                                          String inMinute = "${minute < 10 ? "0$minute" : minute}";
                                          itemData["end_time"] = "$hour:$inMinute";
                                          setState(() {});
                                        });
                                      },
                                    ),
                                  );
                                },
                                child: Row(
                                  children: [
                                    Text(
                                      itemData["end_time"].toString().normalTime,
                                      style: GoogleFonts.poppins(
                                          fontWeight: FontWeight.w500, fontSize: 15, color: Colors.grey.shade700),
                                    ),
                                    const Icon(Icons.keyboard_arrow_down_rounded)
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
            if(weekSchedule1.isNotEmpty)
            ListView.builder(
              physics: const BouncingScrollPhysics(),
              shrinkWrap: true,
              itemCount: weekSchedule1.length,
              itemBuilder: (context, index) {
                var daySchedule = weekSchedule1[index];
                return Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Container(
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(10), border: Border.all(color: AppTheme.greycolor)),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Theme(
                          data: ThemeData(
                              checkboxTheme:
                                  CheckboxThemeData(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)))),
                          child: Checkbox(
                            activeColor: AppTheme.primaryColor,
                            checkColor: Colors.white,
                            value: daySchedule["status"],
                            onChanged: (value) {
                              daySchedule["status"] = value;
                              log(daySchedule["status"].toString());
                              setState(() {});
                            },
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Text(
                            daySchedule["day"].toString(),
                            style: GoogleFonts.poppins(color: Colors.grey.shade900, fontSize: 14, fontWeight: FontWeight.w400),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: GestureDetector(
                            onTap: () {
                              if ((daySchedule["status"] ?? false) == false) return;
                              _showDialog(
                                CupertinoTimerPicker(
                                  mode: CupertinoTimerPickerMode.hm,
                                  initialTimerDuration: daySchedule["start_time"].toString().durationTime,
                                  onTimerDurationChanged: (Duration newDuration) {
                                    makeDelay(nowPerform: (bool v) {
                                      String hour =
                                          "${newDuration.inHours < 10 ? "0${newDuration.inHours}" : newDuration.inHours}";
                                      int minute = newDuration.inMinutes % 60;
                                      String inMinute = "${minute < 10 ? "0$minute" : minute}";
                                      daySchedule["start_time"] = "$hour:$inMinute";
                                      setState(() {});
                                    });
                                  },
                                ),
                              );
                            },
                            child: Row(
                              children: [
                                Text(
                                  daySchedule["start_time"].toString().normalTime,
                                  style:
                                      GoogleFonts.poppins(fontWeight: FontWeight.w500, fontSize: 15, color: Colors.grey.shade700),
                                ),
                                const Icon(Icons.keyboard_arrow_down_rounded)
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            "To",
                            style: GoogleFonts.poppins(color: Colors.grey.shade900, fontSize: 14, fontWeight: FontWeight.w400),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: GestureDetector(
                            onTap: () {
                              if ((daySchedule["status"] ?? false) == false) return;
                              _showDialog(
                                CupertinoTimerPicker(
                                  mode: CupertinoTimerPickerMode.hm,
                                  initialTimerDuration: daySchedule["end_time"].toString().durationTime,
                                  onTimerDurationChanged: (Duration newDuration) {
                                    makeDelay(nowPerform: (bool v) {
                                      String hour =
                                          "${newDuration.inHours < 10 ? "0${newDuration.inHours}" : newDuration.inHours}";
                                      int minute = newDuration.inMinutes % 60;
                                      String inMinute = "${minute < 10 ? "0$minute" : minute}";
                                      daySchedule["end_time"] = "$hour:$inMinute";
                                      setState(() {});
                                    });
                                  },
                                ),
                              );
                            },
                            child: Row(
                              children: [
                                Text(
                                  daySchedule["end_time"].toString().normalTime,
                                  style:
                                      GoogleFonts.poppins(fontWeight: FontWeight.w500, fontSize: 15, color: Colors.grey.shade700),
                                ),
                                const Icon(Icons.keyboard_arrow_down_rounded)
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
                onPressed: () {
                  if(weekSchedule.isNotEmpty){
                    uploadWeekSchedule(FirebaseAuth.instance.currentUser!.uid!, weekSchedule);
                    // weekSchedule.clear();
                  }
                  if(weekSchedule1.isNotEmpty){
                    uploadWeekSchedule(FirebaseAuth.instance.currentUser!.uid!, weekSchedule1);
                  }
                  // getWeekSchedule(userId);
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryColor,
                    surfaceTintColor: AppTheme.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    )),
                child: Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: Text(
                   AppStrings.continues.tr,
                    style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white),
                  ),
                )),
            SizedBox(
              height: 20,
            ),
          ],
        ));
  }
}
