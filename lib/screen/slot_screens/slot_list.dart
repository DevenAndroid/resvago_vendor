import 'dart:convert';
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:resvago_vendor/model/createslot_model.dart';
import 'package:resvago_vendor/screen/slot_screens/add_booking_slot_screen.dart';
import 'package:resvago_vendor/screen/slot_screens/slotViwe%20screen.dart';
import 'package:resvago_vendor/widget/appassets.dart';
import 'package:resvago_vendor/widget/custom_textfield.dart';
import '../../../controllers/slot_controller.dart';
import '../../../widget/addsize.dart';
import '../../../widget/apptheme.dart';
import 'edit_slots_screen.dart';

class SlotListScreen extends StatefulWidget {
  const SlotListScreen({super.key});

  @override
  State<SlotListScreen> createState() => _SlotListScreenState();
}

class _SlotListScreenState extends State<SlotListScreen> {
  final slotController = Get.put(SlotController());
  var selectedItem = '';
  bool isDescendingOrder = true;
  int pagination = 0;
  Future<List<CreateSlotData>> getSlots() async {
    final item = await FirebaseFirestore.instance
        .collection("vendor_slot")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("slot")
        .where("slot_date", isLessThan: DateTime.now().add(Duration(days: 30 + pagination)).millisecondsSinceEpoch)
        .where("slot_date", isGreaterThan: DateTime.now().add(Duration(days: pagination - 5)).millisecondsSinceEpoch)
        .get();
    return item.docs.map((e) => CreateSlotData.fromMap(e.data())).toList();
  }

  List<CreateSlotData>? slotsList;
  bool paginationWorking = false;

  getSlotsWithPagination({bool? reset}) {
    if (reset == true) {
      paginationWorking = false;
      pagination = 0;
    }
    if (paginationWorking) return;
    if (pagination == -1) return;
    paginationWorking = true;
    getSlots().then((value) {
      if (reset == true) {
        slotsList = [];
      }
      pagination = pagination + 35;
      if (value.isNotEmpty) {
        slotsList ??= [];
        slotsList!.addAll(value);
      } else {
        pagination = -1;
      }
      log("pagination....       $pagination");
      setState(() {});
      paginationWorking = false;
    }).catchError((e) {
      paginationWorking = false;
    });
  }

  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    getSlotsWithPagination(reset: true);
    scrollController.addListener(() {
      if (scrollController.position.pixels > (scrollController.position.maxScrollExtent - 10)) {
        getSlotsWithPagination();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: backAppBar(title: "Slot List", context: context),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(children: [
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
                Get.to(() => AddBookingSlot(
                      slotId: DateTime.now().millisecondsSinceEpoch.toString(),
                      refreshValues: () {
                        getSlotsWithPagination(reset: true);
                      },
                      slotsDate: const [],
                    ));
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
          Expanded(
            child: slotsList != null
                ? slotsList!.isNotEmpty
                    ? ListView.builder(
                        shrinkWrap: true,
                        controller: scrollController,
                        physics: const BouncingScrollPhysics(),
                        itemCount: slotsList!.length,
                        itemBuilder: (context, index) {
                          final item = slotsList![index];
                          return Container(
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      AppAssets.calenderImg,
                                      height: 50,
                                      fit: BoxFit.cover,
                                    ),
                                    const SizedBox(
                                      width: 15,
                                    ),
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            DateFormat("dd-MMM-yyyy").format(DateTime.fromMillisecondsSinceEpoch(item.slotDate!)),
                                            style: GoogleFonts.poppins(
                                                color: const Color(0xFF1A2E33), fontWeight: FontWeight.w500, fontSize: 13),
                                          ),
                                          Text(
                                            "${'Total Guest'.tr} : ${item.noOfGuest}",
                                            style: GoogleFonts.poppins(
                                                color: const Color(0xFF1A2E33), fontWeight: FontWeight.w300, fontSize: 13),
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                        ],
                                      ),
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
                                                final slotController = Get.put(SlotController());
                                                slotController.clearAll();
                                                Get.to(() => EditSlotsScreen(
                                                      createSlotData: item,
                                                      refreshValues: () {
                                                        getSlotsWithPagination(reset: true);
                                                      },
                                                    ));
                                                // slotController.slots.clear();
                                                // slotController.dinnerSlots.clear();
                                                // Get.to(() => AddBookingSlot(
                                                //   slotId: slotDataList[index].slotId, slotDataList: slotDataList[index],
                                                //   slotsDate: slotDataList.where((element) => element.slotId.toString() != slotDataList[index].slotId).toList().totalDates,
                                                // ));
                                              },
                                              // value: '/Edit',
                                              child:  Text("Edit".tr),
                                            ),
                                            PopupMenuItem(
                                              onTap: () {
                                                Get.to(() => SlotViewScreen(slotDataList: item));
                                              },
                                              // value: '/slotViewScreen',
                                              child:  Text("View".tr),
                                            ),
                                            PopupMenuItem(
                                              onTap: () {
                                                showDialog(
                                                  context: context,
                                                  builder: (ctx) => AlertDialog(
                                                    title:  Text("Delete Slot".tr),
                                                    content:  Text("Are you sure you want to delete this slot".tr),
                                                    actions: <Widget>[
                                                      TextButton(
                                                        onPressed: () {
                                                          Get.back();
                                                        },
                                                        child: Container(
                                                          decoration: BoxDecoration(
                                                              color: Colors.red, borderRadius: BorderRadius.circular(11)),
                                                          width: 100,
                                                          padding: const EdgeInsets.all(14),
                                                          child:  Center(
                                                              child: Text(
                                                            "Cancel".tr,
                                                            style: const TextStyle(color: Colors.white),
                                                          )),
                                                        ),
                                                      ),
                                                      TextButton(
                                                        onPressed: () {
                                                          FirebaseFirestore.instance
                                                              .collection('vendor_slot')
                                                              .doc(FirebaseAuth.instance.currentUser!.uid)
                                                              .collection("slot")
                                                              .doc(item.slotId.toString())
                                                              .delete();
                                                          slotsList!.removeAt(index);
                                                          setState(() {});
                                                          Get.back();
                                                        },
                                                        child: Container(
                                                          decoration: BoxDecoration(
                                                              color: Colors.green, borderRadius: BorderRadius.circular(11)),
                                                          width: 100,
                                                          padding: const EdgeInsets.all(14),
                                                          child:  Center(
                                                              child: Text(
                                                            "okay".tr,
                                                            style: const TextStyle(color: Colors.white),
                                                          )),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                );
                                                setState(() {});
                                              },
                                              // value: '/deactivate',
                                              child:  Text("Delete".tr),
                                            )
                                          ];
                                        })
                                  ]));
                        })
                    :  Center(
                        child: Text("Slots are not created yet".tr),
                      )
                :  Center(
                    child: Text("Slots are not created yet".tr),
                  ),
          )
        ]),
      ),
    );
  }
}
