import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:resvago_vendor/model/createslot_model.dart';
import 'package:resvago_vendor/widget/custom_textfield.dart';

import '../widget/addsize.dart';
import '../widget/apptheme.dart';
import 'Menu/add_menu.dart';
import 'add_booking_slot_screen.dart';

class SlotListScreen extends StatefulWidget {
  const SlotListScreen({super.key});

  @override
  State<SlotListScreen> createState() => _SlotListScreenState();
}

class _SlotListScreenState extends State<SlotListScreen> {
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

  // CreateSlotData? slotData;
  // getSlots() {
  //   FirebaseFirestore.instance
  //       .collection('vendor_slot')
  //       .doc("${FirebaseAuth.instance.currentUser!.phoneNumber}slots")
  //       .get()
  //       .then((value) {
  //     var gg = value.data();
  //     log("Slots$gg");
  //     slotData = CreateSlotData.fromMap(gg!, value.id);
  //     log("Slots1$slotData");
  //     setState(() {});
  //   });
  // }
  bool isDescendingOrder = true;
  List<CreateSlotData>? slotDataList;
  getSlots() {
    return FirebaseFirestore.instance.collection("vendor_menu").doc(FirebaseAuth.instance.currentUser!.phoneNumber).
    collection("menus").orderBy('time', descending: isDescendingOrder).get().then((value) {
      for (var element in value.docs) {
        var gg = element.data();
        slotDataList ??= [];
        slotDataList!.add(CreateSlotData.fromMap(gg,element.id));
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
        child: Column(
          children: [
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
            // if (slotDataList!.isNotEmpty)
            //  ListView.builder(
            //    itemCount: slotDataList!.length,
            //    shrinkWrap: true,
            //    itemBuilder: (BuildContext context, int index) {
            //    return  Padding(
            //        padding: const EdgeInsets.all(8.0),
            //        child: Container(
            //          padding: const EdgeInsets.all(14),
            //          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
            //          child: Row(
            //            children: [
            //              Column(
            //                mainAxisAlignment: MainAxisAlignment.start,
            //                crossAxisAlignment: CrossAxisAlignment.start,
            //                children: [
            //                  Text(
            //                    slotDataList![index].startDateForLunch.toString() + slotDataList![index].endDateForLunch.toString(),
            //                    style: GoogleFonts.poppins(
            //                        color: const Color(0xFF1A2E33), fontWeight: FontWeight.w500, fontSize: 15),
            //                  ),
            //                  Text(
            //                    "Total Guest : ${slotDataList![index].endDateForLunch}",
            //                    style: GoogleFonts.poppins(
            //                        color: const Color(0xFF1A2E33), fontWeight: FontWeight.w500, fontSize: 15),
            //                  ),
            //                ],
            //              ),
            //              const Spacer(),
            //              const Icon(Icons.remove_red_eye_outlined)
            //            ],
            //          ),
            //        ));
            //  },)
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
          ],
        ),
      ),
    );
  }
}
