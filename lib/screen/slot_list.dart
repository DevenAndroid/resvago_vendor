import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:resvago_vendor/model/createslot_model.dart';
import 'package:resvago_vendor/widget/appassets.dart';
import 'package:resvago_vendor/widget/custom_textfield.dart';
import '../controllers/slot_controller.dart';
import '../routers/routers.dart';
import '../widget/addsize.dart';
import '../widget/apptheme.dart';
import 'add_booking_slot_screen.dart';

class SlotListScreen extends StatefulWidget {
  const SlotListScreen({super.key});

  @override
  State<SlotListScreen> createState() => _SlotListScreenState();
}

class _SlotListScreenState extends State<SlotListScreen> {
  final slotController = Get.put(SlotController());
  // Stream<List<CreateSlotData>> getSlots() {
  //   return FirebaseFirestore.instance
  //       .collection('vendor_slot')
  //       .doc("${FirebaseAuth.instance.currentUser!.phoneNumber}slots")
  //       .snapshots()
  //       .map((querySnapshot) {
  //     List<CreateSlotData> menuList = [];
  //     try {
  //       var gg = querySnapshot.data();
  //       menuList.add(CreateSlotData.fromMap(gg!, querySnapshot.id.toString()));
  //       log(menuList.toString());
  //     } catch (e) {
  //       throw Exception(e.toString());
  //     }
  //     return menuList;
  //   });
  // }
  var selectedItem = '';
  CreateSlotData? slotData;
  // getSlots() {
  //   return FirebaseFirestore.instance
  //       .collection("vendor_menu")
  //       .doc(FirebaseAuth.instance.currentUser!.phoneNumber)
  //       .collection("menus")
  //       .orderBy('time', descending: isDescendingOrder)
  //       .get()
  //       .then((value) {
  //     for (var element in value.docs) {
  //       var gg = element.data();
  //       slotDataList ??= [];
  //       slotDataList!.add(CreateSlotData.fromMap(gg, element.id));
  //     }
  //     setState(() {});
  //   });
  // }

  bool isDescendingOrder = true;
  List<CreateSlotData>? slotDataList = [];
  getSlots() {
    return FirebaseFirestore.instance
        .collection("vendor_slot")
        .doc(FirebaseAuth.instance.currentUser!.phoneNumber)
        .collection("slot")
        .orderBy('time', descending: isDescendingOrder)
        .get()
        .then((value) {
      for (var element in value.docs) {
        var gg = element.data();
        slotDataList ??= [];
        slotDataList!.add(CreateSlotData.fromMap(gg, element.id));
        // log(slotDataList![0].startDateForLunch.toString());
        // log(slotDataList![0].endDateForLunch.toString());
        // log(slotDataList![0].startTimeForDinner.toString());
        // log(slotDataList![0].endTimeForDinner.toString());
      }
      setState(() {});
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getSlots();
    // getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: backAppBar(title: "Slot List", context: context),
      body: SingleChildScrollView(
          child: Column(children: [
        const SizedBox(
          height: 10,
        ),
        Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: Align(
            alignment: Alignment.centerRight,
            child: GestureDetector(
              onTap: () {
                Get.to(AddBookingSlot(slotId: DateTime.now().millisecondsSinceEpoch.toString()));
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
        ),
        if (slotDataList!.isNotEmpty)
          ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: slotDataList!.length,
              itemBuilder: (context, index) {
                return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Image.asset(
                                AppAssets.calenderImg,
                                height: 50,
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "${slotDataList![index].startDateForLunch}  To  ${slotDataList![index].endDateForLunch}",
                                    style: GoogleFonts.poppins(
                                        color: const Color(0xFF1A2E33), fontWeight: FontWeight.w400, fontSize: 14),
                                  ),
                                  Text(
                                    "Total Guest : ${slotDataList![index].noOfGuest.toString()}",
                                    style: GoogleFonts.poppins(
                                        color: const Color(0xFF1A2E33), fontWeight: FontWeight.w300, fontSize: 14),
                                  ),
                                ],
                              ),
                              const Spacer(),
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
                                          slotController.startDate.text = slotDataList![index].startDateForLunch;
                                          slotController.endDate.text = slotDataList![index].endDateForLunch;
                                          slotController.startTime.text = slotDataList![index].startTimeForLunch;
                                          slotController.endTime.text = slotDataList![index].endTimeForLunch;
                                          slotController.dinnerStartDate.text = slotDataList![index].startDateForDinner;
                                          slotController.dinnerEndDate.text = slotDataList![index].endDateForDinner;
                                          slotController.dinnerStartTime.text = slotDataList![index].startTimeForDinner;
                                          slotController.dinnerEndTime.text = slotDataList![index].endTimeForDinner;
                                          slotController.serviceDuration.text = slotDataList![index].lunchDuration;
                                          slotController.dinnerServiceDuration.text = slotDataList![index].dinnerDuration;
                                          slotController.noOfGuest.text = slotDataList![index].noOfGuest;
                                          Get.to(() => AddBookingSlot(
                                              slotId: slotDataList![index].slotId, slotDataList: slotDataList![index]));
                                        },
                                        // value: '/Edit',
                                        child: const Text("Edit"),
                                      ),
                                      PopupMenuItem(
                                        onTap: () {
                                          Get.toNamed(MyRouters.slotViewScreen);
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
                                              .doc(slotDataList![index].slotId)
                                              .delete()
                                              .then((value) {
                                            setState(() {});
                                          });
                                        },
                                        // value: '/deactivate',
                                        child: const Text("Delete"),
                                      )
                                    ];
                                  })
                            ])));
              })
      ])
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
