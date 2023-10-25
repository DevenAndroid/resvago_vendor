import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:resvago_vendor/utils/helper.dart';
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
  // final Repositories repositories = Repositories();
  // final controller = Get.put(VendorStoreTimingController());

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
  StoreTimeData modelStoreAvailability = StoreTimeData();
  Future<void> addStoreTimeToFirestore() async {
    OverlayEntry loader = Helper.overlayLoader(context);
    Overlay.of(context).insert(loader);
    List<String> start = [];
    List<String> end = [];
    List<String> status = [];
    storeTimeList!.map((item) {
      start.add(item.startTime.toString().normalTime);
      end.add(item.endTime.toString().normalTime);
      status.add(item.status == true ? "1" : "0");
    });

    try {
      await firebaseService
          .manageStoreTime(
        storeTimeId: DateTime.now().microsecondsSinceEpoch,
        vendorId: FirebaseAuth.instance.currentUser!.phoneNumber,
        time: DateTime.now().millisecondsSinceEpoch,
        status: status,
        startTime: start,
        endTime: end,
      )
          .then((value) {
        Get.back();
        Helper.hideLoader(loader);
      });
    } catch (e) {
      Helper.hideLoader(loader);
      showToast(e.toString());
      log(e.toString());
      throw Exception(e.toString());
    }
  }

  Stream<List<StoreTimeData>> getSetStoreTime() {
    return FirebaseFirestore.instance
        .collection("vendor_storeTime")
        .doc(FirebaseAuth.instance.currentUser!.phoneNumber)
        .collection("store_time")
        .snapshots()
        .map((querySnapshot) {
      List<StoreTimeData> slotDataList = [];
      for (var element in querySnapshot.docs) {
        var gg = element.data();
        slotDataList.add(StoreTimeData.fromMap(gg, element.id));
      }
      return slotDataList;
    });
  }

  List<StoreTimeData>? storeTimeList;
  getVendorCategories() {
    FirebaseFirestore.instance
        .collection("vendor_storeTime")
        .doc(FirebaseAuth.instance.currentUser!.phoneNumber)
        .collection("store_time")
        .get()
        .then((value) {
      for (var element in value.docs) {
        var gg = element.data();
        log("Slot$gg");
        storeTimeList ??= [];
        storeTimeList!.add(StoreTimeData.fromMap(gg, element.id));
      }
      setState(() {
      });
    });
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


  addSetStoreTime(){
    for (int i = 0; i < 7; i++) {
      FirebaseFirestore.instance
          .collection('vendor_storeTime')
          .doc(FirebaseAuth.instance.currentUser!.phoneNumber)
          .collection('store_time')
          .doc()
          .set({
        'status': 'true',
        'startTime': '09:00',
        'endTime': '19:00',
      });
    }
  }

  @override
  void initState() {
    super.initState();
    addSetStoreTime();
    getVendorCategories();
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
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: backAppBar(title: "Set Store Time", context: context, backgroundColor: Colors.white),
        body: ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.symmetric(horizontal: 16).copyWith(top: 10),
          children: [
            if (storeTimeList != null)
              ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  physics: const BouncingScrollPhysics(),
                  itemCount: storeTimeList!.length,
                  itemBuilder: (context, index) {
                    var itemData = storeTimeList![index];
                    return Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10), border: Border.all(color: AppTheme.greycolor)),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Theme(
                              data: ThemeData(
                                  checkboxTheme: CheckboxThemeData(
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)))),
                              child: Checkbox(
                                activeColor: AppTheme.primaryColor,
                                checkColor: Colors.white,
                                value: itemData.status== "0" ? false : true ?? false,
                                onChanged: (value) {
                                  itemData.status = value;
                                  log(itemData.status.toString());
                                  setState(() {});
                                },
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: Text(
                                itemData.weekDay.toString(),
                                style: GoogleFonts.poppins(
                                    color: Colors.grey.shade900, fontSize: 14, fontWeight: FontWeight.w400),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: GestureDetector(
                                onTap: () {
                                  if ((itemData.status ?? false) == false) return;
                                  _showDialog(
                                    CupertinoTimerPicker(
                                      mode: CupertinoTimerPickerMode.hm,
                                      initialTimerDuration: itemData.startTime.toString().durationTime,
                                      onTimerDurationChanged: (Duration newDuration) {
                                        makeDelay(nowPerform: (bool v) {
                                          String hour =
                                              "${newDuration.inHours < 10 ? "0${newDuration.inHours}" : newDuration.inHours}";
                                          int minute = newDuration.inMinutes % 60;
                                          String inMinute = "${minute < 10 ? "0$minute" : minute}";
                                          itemData.startTime = "$hour:$inMinute";
                                          setState(() {});
                                        });
                                      },
                                    ),
                                  );
                                },
                                child: Row(
                                  children: [
                                    Text(
                                      itemData.startTime.toString().normalTime,
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
                                style: GoogleFonts.poppins(
                                    color: Colors.grey.shade900, fontSize: 14, fontWeight: FontWeight.w400),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: GestureDetector(
                                onTap: () {
                                  if ((itemData.status ?? false) == false) return;
                                  _showDialog(
                                    CupertinoTimerPicker(
                                      mode: CupertinoTimerPickerMode.hm,
                                      initialTimerDuration: itemData.endTime.toString().durationTime,
                                      onTimerDurationChanged: (Duration newDuration) {
                                        makeDelay(nowPerform: (bool v) {
                                          String hour =
                                              "${newDuration.inHours < 10 ? "0${newDuration.inHours}" : newDuration.inHours}";
                                          int minute = newDuration.inMinutes % 60;
                                          String inMinute = "${minute < 10 ? "0$minute" : minute}";
                                          itemData.endTime = "$hour:$inMinute";
                                          setState(() {});
                                        });
                                      },
                                    ),
                                  );
                                },
                                child: Row(
                                  children: [
                                    Text(
                                      itemData.endTime.toString().normalTime,
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
            const SizedBox(
              height: 100,
            ),
            ElevatedButton(
                onPressed: () {
                  addStoreTimeToFirestore();
                  // updateTime();
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
                    "Continue".toUpperCase(),
                    style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white),
                  ),
                ))
          ],
        ));
  }
}
