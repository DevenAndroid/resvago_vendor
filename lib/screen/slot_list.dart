import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:resvago_vendor/model/createslot_model.dart';
import 'package:resvago_vendor/widget/appassets.dart';
import 'package:resvago_vendor/widget/custom_textfield.dart';

import '../widget/addsize.dart';
import '../widget/apptheme.dart';
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
  var selectedItem = '';
  CreateSlotData? slotData;
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
            if (slotData != null)
              Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
                    child: Row(
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Start Date",
                              style: GoogleFonts.poppins(
                                  color: const Color(0xFF1A2E33), fontWeight: FontWeight.w300, fontSize: 14),
                            ),
                            Text(
                              slotData!.startDateForLunch.toString(),
                              style: GoogleFonts.poppins(
                                  color: const Color(0xFF1A2E33), fontWeight: FontWeight.w500, fontSize: 15),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            if (slotData!.endDateForLunch.toString().trim().isEmpty)
                              const SizedBox()
                            else
                              Column(
                                children: [
                                  Text(
                                    "End Date",
                                    style: GoogleFonts.poppins(
                                        color: const Color(0xFF1A2E33), fontWeight: FontWeight.w300, fontSize: 14),
                                  ),
                                  Text(
                                    slotData!.endDateForLunch.toString(),
                                    style: GoogleFonts.poppins(
                                        color: const Color(0xFF1A2E33), fontWeight: FontWeight.w500, fontSize: 15),
                                  ),
                                ],
                              ),
                            if (slotData!.noOfGuest.toString().trim().isEmpty)
                              const SizedBox()
                            else
                              Column(
                                children: [
                                  Text(
                                    "Total Guest : ${slotData!.noOfGuest}",
                                    style: GoogleFonts.poppins(
                                        color: const Color(0xFF1A2E33), fontWeight: FontWeight.w300, fontSize: 14),
                                  ),
                                ],
                              )
                          ],
                        ),
                        const Spacer(),
                        const Icon(Icons.remove_red_eye_outlined)
                      ],
                    ),
                  )),

    ListView.builder(
                   shrinkWrap: true,
                   scrollDirection: Axis.vertical,
                   physics: const NeverScrollableScrollPhysics(),
                   itemCount:10,
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
                               Image.asset(AppAssets.calenderImg,height: 50,),
                               const SizedBox(width: 20,),
                               Column(
                                 mainAxisAlignment: MainAxisAlignment.start,
                                 crossAxisAlignment: CrossAxisAlignment.start,
                                 children: [
                                Text("10 Oct 2023 To 12 Oct 2023",
                                 style: GoogleFonts.poppins(
                                     color: const Color(0xFF1A2E33), fontWeight: FontWeight.w400, fontSize: 14),
                               ),
                                   Text("Total Guest : 25",
                                     style: GoogleFonts.poppins(
                                         color: const Color(0xFF1A2E33), fontWeight: FontWeight.w300, fontSize: 14),
                                   ),

                                 ],
                               ),
                               const Spacer(),
                               PopupMenuButton(color: Colors.white,iconSize: 20,icon:const Icon(Icons.more_vert,color: Colors.grey,),padding: EdgeInsets.zero,onSelected: (value) {
                                 setState(() {
                                   selectedItem = value.toString();
                                 });

                                 Navigator.pushNamed(context, value.toString());
                               }, itemBuilder: ( ac) {
                                 return  [
                                   PopupMenuItem(
                                     onTap: (){},
                                     value: '/Edit',
                                     child: const Text("Edit"),
                                   ),
                                   PopupMenuItem(
                                     onTap: (){
                                       // Get.toNamed(MyRouters.slotViewScreen);
                                     },
                                     value: '/slotViewScreen',
                                     child: const Text("View"),
                                   ),
                                   PopupMenuItem(
                                     onTap: (){},
                                     value: '/deactivate',
                                     child: const Text("deactivate"),
                                   )
                                 ];
                               })
                             ]
    )));})])
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
