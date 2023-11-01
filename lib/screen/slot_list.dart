import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:resvago_vendor/model/createslot_model.dart';
import 'package:resvago_vendor/screen/slotViwe%20screen.dart';
import 'package:resvago_vendor/widget/appassets.dart';
import 'package:resvago_vendor/widget/custom_textfield.dart';
import '../controllers/slot_controller.dart';
import '../widget/addsize.dart';
import '../widget/apptheme.dart';
import 'add_booking_slot_screen.dart';

extension GetTotalDates on List<CreateSlotData>{
  List<DateTime> get totalDates{
    var kk = DateFormat("dd-MMM-yyyy");
    List<DateTime> slotsDate = [];
    for (var element in this) {
      DateTime initialDate = kk.parse(element.startDateForLunch);
      if ((element.endDateForLunch ?? "").toString().isEmpty) {
        slotsDate.add(initialDate);
      } else {
        DateTime lastDate = kk.parse(element.endDateForLunch);
        while (initialDate.isBefore(lastDate.add(const Duration(days: 1)))) {
          slotsDate.add(initialDate);
          // print(initialDate);
          initialDate = initialDate.add(const Duration(days: 1));
        }
      }
    }
    print(slotsDate);
    return slotsDate;
  }
}

extension ChangeToDate on String{
  DateTime get formatDate {
    var kk = DateFormat("dd-MMM-yyyy");
    return kk.parse(this);
  }
}

List<CreateSlotData> slotDataList = [];

class SlotListScreen extends StatefulWidget {
  const SlotListScreen({super.key});

  @override
  State<SlotListScreen> createState() => _SlotListScreenState();
}

class _SlotListScreenState extends State<SlotListScreen> {
  final slotController = Get.put(SlotController());
  var selectedItem = '';
  bool isDescendingOrder = true;
  Stream<List<CreateSlotData>> getSlots() {
    return FirebaseFirestore.instance
        .collection("vendor_slot")
        .doc(FirebaseAuth.instance.currentUser!.phoneNumber)
        .collection("slot")
        .snapshots()
        .map((querySnapshot) {
      List<CreateSlotData> slotDataList = [];
      for (var element in querySnapshot.docs) {
        var gg = element.data();
        slotDataList.add(CreateSlotData.fromMap(gg, element.id));
      }
      return slotDataList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: backAppBar(title: "Slot List", context: context),
      body: SingleChildScrollView(
          child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(children: [
          const SizedBox(
            height: 10,
          ),
          Align(
            alignment: Alignment.centerRight,
            child: GestureDetector(
              onTap: () {
                slotController.startDate.text = "";
                slotController.endDate.text = "";
                slotController.startTime.text = "";
                slotController.endTime.text = "";
                slotController.dinnerStartDate.text = "";
                slotController.dinnerEndDate.text = "";
                slotController.dinnerStartTime.text = "";
                slotController.dinnerEndTime.text = "";
                slotController.serviceDuration.text = "";
                slotController.dinnerServiceDuration.text = "";
                slotController.noOfGuest.text = "";
                slotController.setOffer.text = "";
                slotController.dateType.value = "date";
                slotController.slots.clear();
                slotController.dinnerSlots.clear();
                Get.to(()=> AddBookingSlot(slotId: DateTime.now().millisecondsSinceEpoch.toString(), slotsDate: slotDataList.totalDates,));
              },
              child: Container(
                height: AddSize.size20 * 2.2,
                width: AddSize.size20 * 2.2,
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                    child: Icon(
                  Icons.add,
                  color: AppTheme.backgroundcolor,
                  size: AddSize.size25,
                )),
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          StreamBuilder(
            stream: getSlots(),
            builder: (BuildContext context, AsyncSnapshot<List<CreateSlotData>> snapshot) {
              if (snapshot.hasData && snapshot.data != null) {
                slotDataList = snapshot.data!;
                return ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    physics: const BouncingScrollPhysics(),
                    itemCount: slotDataList.length,
                    itemBuilder: (context, index) {
                      return Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Image.asset(
                                  AppAssets.calenderImg,
                                  height: 50,
                                  fit: BoxFit.cover,
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "${slotDataList[index].startDateForLunch}  To  ${slotDataList[index].endDateForLunch}",
                                      style: GoogleFonts.poppins(
                                          color: const Color(0xFF1A2E33), fontWeight: FontWeight.w500, fontSize: 13),
                                    ),
                                    Text(
                                      "Total Guest : ${slotDataList[index].noOfGuest.toString()}",
                                      style: GoogleFonts.poppins(
                                          color: const Color(0xFF1A2E33), fontWeight: FontWeight.w300, fontSize: 13),
                                    ),
                                  ],
                                ),
                                // const Spacer(),
                                PopupMenuButton(
                                    color: Colors.white,
                                    iconSize: 20,
                                    icon: const Icon(
                                      Icons.more_vert,
                                      color: Colors.grey,
                                    ),
                                    padding: EdgeInsets.zero,
                                    onSelected: (value) {
                                      setState(() {
                                        selectedItem = value.toString();
                                      });

                                      Navigator.pushNamed(context, value.toString());
                                    },
                                    itemBuilder: (ac) {
                                      return [
                                        PopupMenuItem(
                                          onTap: () {
                                            slotController.slots.clear();
                                            slotController.dinnerSlots.clear();
                                            Get.to(() => AddBookingSlot(
                                                slotId: slotDataList[index].slotId, slotDataList: slotDataList[index],
                                              slotsDate: slotDataList.where((element) => element.slotId.toString() != slotDataList[index].slotId).toList().totalDates,
                                            ));
                                          },
                                          // value: '/Edit',
                                          child: const Text("Edit"),
                                        ),
                                        PopupMenuItem(
                                          onTap: () {
                                            Get.to(() => SlotViewScreen(
                                                slotId: slotDataList[index].slotId, slotDataList: slotDataList[index]));
                                          },
                                          // value: '/slotViewScreen',
                                          child: const Text("View"),
                                        ),
                                        PopupMenuItem(
                                          onTap: () {
                                            FirebaseFirestore.instance
                                                .collection('vendor_slot')
                                                .doc(FirebaseAuth.instance.currentUser!.phoneNumber)
                                                .collection("slot")
                                                .doc(slotDataList[index].slotId.toString())
                                                .delete();
                                          },
                                          // value: '/deactivate',
                                          child: const Text("Delete"),
                                        )
                                      ];
                                    })
                              ]));
                    });
              }
              return const Center(
                child: CircularProgressIndicator(),
              );
            },
          )
        ]),
      )
          // StreamBuilder<List<CreateSlotData>>(
          //     stream: getSlots(),
          //     builder: (context, snapshot) {
          //       if (snapshot.connectionState == ConnectionState.waiting) {
          //         return LoadingAnimationWidget.fourRotatingDots(
          //           color: AppTheme.primaryColor,
          //           size: 40,
          //         );
          //       }
          //       if (snapshot.hasData) {
          //         List<CreateSlotData> slot = snapshot.data ?? [];
          //         log("AAAAA----$slot");
          //         return slot.isNotEmpty
          //             ? ListView.builder(
          //                 shrinkWrap: true,
          //                 scrollDirection: Axis.vertical,
          //                 physics: const NeverScrollableScrollPhysics(),
          //                 itemCount: slot.length,
          //                 itemBuilder: (context, index) {
          //                   var slotItem = slot[index];
          //                   return Padding(
          //                       padding: const EdgeInsets.all(8.0),
          //                       child: Container(
          //                         padding: const EdgeInsets.all(14),
          //                         decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
          //                         child: Row(
          //                           children: [
          //                             Column(
          //                               mainAxisAlignment: MainAxisAlignment.start,
          //                               crossAxisAlignment: CrossAxisAlignment.start,
          //                               children: [
          //                                 Text(
          //                                   "Start Date",
          //                                   style: GoogleFonts.poppins(
          //                                       color: const Color(0xFF1A2E33), fontWeight: FontWeight.w300, fontSize: 14),
          //                                 ),
          //                                 Text(
          //                                   "10 Oct 2023",
          //                                   style: GoogleFonts.poppins(
          //                                       color: const Color(0xFF1A2E33), fontWeight: FontWeight.w500, fontSize: 15),
          //                                 ),
          //                               ],
          //                             ),
          //                             const Spacer(),
          //                             const Icon(Icons.remove_red_eye_outlined)
          //                           ],
          //                         ),
          //                       ));
          //                 })
          //             : const Center(
          //                 child: Text("No Slot Created"),
          //               );
          //       }
          //       return const SizedBox.shrink();
          //     })

          ),
    );
  }
}
