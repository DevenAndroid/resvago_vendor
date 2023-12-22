import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:resvago_vendor/screen/delivery_oders_details_screen.dart';
import 'package:resvago_vendor/utils/helper.dart';
import 'package:resvago_vendor/widget/apptheme.dart';
import '../../model/dining_order_modal.dart';
import '../../model/order_details_modal.dart';
import '../../widget/appassets.dart';
import '../oder_details_screen.dart';

class OderListScreen extends StatefulWidget {
  String back;
  OderListScreen({super.key, required this.back});

  @override
  State<OderListScreen> createState() => _OderListScreenState();
}

class _OderListScreenState extends State<OderListScreen> {
  RxString dropDownValue1 = ''.obs;
  RxString dropDownValue2 = ''.obs;
  String searchQuery = '';

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: Colors.transparent,
        body: DefaultTabController(
          length: 2,
          child: Column(
            children: [
              Container(
                height: 320,
                decoration: const BoxDecoration(
                    image: DecorationImage(fit: BoxFit.fill, image: AssetImage(AppAssets.oderlistbg)),
                    borderRadius: BorderRadius.only(bottomLeft: Radius.circular(40), bottomRight: Radius.circular(40))),
                child: Padding(
                  padding: const EdgeInsets.only(left: 15.0, right: 15),
                  child: Column(children: [
                    const SizedBox(
                      height: 40,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Padding(
                        //   padding: const EdgeInsets.only(left: 0),
                        //   child: GestureDetector(
                        //       onTap: () {
                        //         Get.back();
                        //       },
                        //       child: Image.asset(
                        //         AppAssets.backWhite,
                        //         height: AddSize.size25,
                        //       )),
                        // ),
                        const SizedBox(
                          width: 20,
                        ),
                        Text(
                          "Order List".tr,
                          style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 17),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      padding: const EdgeInsets.all(9),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.white.withOpacity(.35)),
                        color: Colors.white.withOpacity(.10),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "\$0.00",
                                style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 28),
                              ),
                              Text(
                                "Your earning this month",
                                style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w400, fontSize: 12),
                              ),
                            ],
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              elevation: 0,
                              backgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                            onPressed: () {},
                            child: Text(
                              "Withdrawal".tr,
                              style: GoogleFonts.poppins(color: AppTheme.primaryColor, fontWeight: FontWeight.w600, fontSize: 14),
                            ),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 50,
                            // width: size.width * .4,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 2),
                              child: PopupMenuButton<int>(
                                constraints: const BoxConstraints(maxHeight: 300),
                                position: PopupMenuPosition.under,
                                offset: Offset.fromDirection(1, 1),
                                onSelected: (value) {
                                  setState(() {});
                                },
                                // icon: Icon(Icons.keyboard_arrow_down),
                                itemBuilder: (context) => [
                                  PopupMenuItem(
                                      child: Column(
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          dropDownValue1.value = 'No';
                                        },
                                        child: Text('No'.tr,
                                            style: const TextStyle(
                                                fontSize: 15, color: Colors.blueGrey, fontWeight: FontWeight.w500)),
                                      ),
                                    ],
                                  )),
                                  PopupMenuItem(
                                      child: Column(
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          setState(() {
                                            dropDownValue1.value = 'Yes';
                                          });
                                        },
                                        child: Text('Yes'.tr,
                                            style: const TextStyle(
                                                fontSize: 15, color: Colors.blueGrey, fontWeight: FontWeight.w500)),
                                      ),
                                    ],
                                  )),
                                ],
                                child: Container(
                                  padding: const EdgeInsets.all(9),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(color: Colors.white.withOpacity(.35)),
                                    color: Colors.white.withOpacity(.10),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Obx(() {
                                        return Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Center(
                                              child: Text(
                                                dropDownValue1.value.toString().isEmpty
                                                    ? "Filter"
                                                    : dropDownValue1.value.toString(),
                                                style: const TextStyle(
                                                    fontSize: 15, color: Colors.white, fontWeight: FontWeight.w500),
                                              ),
                                            ),
                                          ],
                                        );
                                      }),
                                      const Spacer(),
                                      const Icon(
                                        Icons.arrow_drop_down,
                                        color: Colors.white,
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: SizedBox(
                            height: 50,
                            // width: size.width * .4,
                            child: PopupMenuButton<int>(
                              constraints: const BoxConstraints(maxHeight: 300),
                              position: PopupMenuPosition.under,
                              offset: Offset.fromDirection(1, 1),
                              onSelected: (value) {
                                setState(() {});
                              },
                              // icon: Icon(Icons.keyboard_arrow_down),
                              itemBuilder: (context) => [
                                PopupMenuItem(
                                    child: Column(
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        dropDownValue2.value = 'False';
                                        Get.back();
                                      },
                                      child: Text('False'.tr,
                                          style:
                                              const TextStyle(fontSize: 15, color: Colors.blueGrey, fontWeight: FontWeight.w500)),
                                    ),
                                  ],
                                )),
                                PopupMenuItem(
                                    child: Column(
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          dropDownValue2.value = 'True';
                                          Get.back();
                                        });
                                      },
                                      child: Text('True'.tr,
                                          style:
                                              const TextStyle(fontSize: 15, color: Colors.blueGrey, fontWeight: FontWeight.w500)),
                                    ),
                                  ],
                                )),
                              ],
                              child: Container(
                                padding: const EdgeInsets.all(9),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: Colors.white.withOpacity(.35)),
                                  color: Colors.white.withOpacity(.10),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Obx(() {
                                      return Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Center(
                                            child: Text(
                                              dropDownValue2.value.toString().isEmpty
                                                  ? "Status"
                                                  : dropDownValue2.value.toString(),
                                              style:
                                                  const TextStyle(fontSize: 15, color: Colors.white, fontWeight: FontWeight.w500),
                                            ),
                                          ),
                                        ],
                                      );
                                    }),
                                    const Spacer(),
                                    const Icon(
                                      Icons.arrow_drop_down,
                                      color: Colors.white,
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      padding: const EdgeInsets.all(1),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.white.withOpacity(.35)),
                        color: Colors.white.withOpacity(.10),
                      ),
                      child: TextFormField(
                        decoration: InputDecoration(
                          hintText: "Search".tr,
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.only(left: 10),
                          focusColor: Colors.white,
                          hintStyle: GoogleFonts.poppins(
                            color: Colors.white,
                            textStyle: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w300,
                            ),
                            fontSize: 14,
                            // fontFamily: 'poppins',
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ]),
                ),
              ),
              TabBar(labelColor: const Color(0xFF454B5C), indicatorColor: const Color(0xFF3B5998), indicatorWeight: 4, tabs: [
                Tab(
                  text: "Dining Orders".tr,
                ),
                Tab(
                  text: "Delivery Orders".tr,
                ),
              ]),
              Expanded(
                child: TabBarView(children: [
                  SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Order No.".tr,
                                style: GoogleFonts.poppins(
                                    color: const Color(0xFF3B5998), fontWeight: FontWeight.w600, fontSize: 12),
                              ),
                              Text(
                                "Status".tr,
                                style: GoogleFonts.poppins(
                                    color: const Color(0xFF3B5998), fontWeight: FontWeight.w600, fontSize: 12),
                              ),
                              Text(
                                "Earning".tr,
                                style: GoogleFonts.poppins(
                                    color: const Color(0xFF3B5998), fontWeight: FontWeight.w600, fontSize: 12),
                              ),
                            ],
                          ),
                          Divider(
                            thickness: 1,
                            color: Colors.black12.withOpacity(0.09),
                          ),
                          StreamBuilder<List<MyDiningOrderModel>>(
                            stream: getDiningOrdersStreamFromFirestore(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return const Center(
                                    child: CircularProgressIndicator()); // Show a loading indicator while data is being fetched
                              } else if (snapshot.hasError) {
                                return Text('Error: ${snapshot.error}');
                              } else {
                                List<MyDiningOrderModel> users = snapshot.data ?? [];
                                return users.isNotEmpty
                                    ? ListView.builder(
                                        padding: EdgeInsets.zero,
                                        physics: const NeverScrollableScrollPhysics(),
                                        itemCount: users.length,
                                        shrinkWrap: true,
                                        itemBuilder: (context, index) {
                                          final item = users[index];
                                          return GestureDetector(
                                            behavior: HitTestBehavior.translucent,
                                            onTap: () {
                                              Get.to(() => OderDetailsScreen(
                                                    myDiningOrderModel: item,
                                                  ));
                                            },
                                            child: Column(
                                              children: [
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Column(
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Text(
                                                          item.orderId.toString(),
                                                          style: GoogleFonts.poppins(
                                                              color: const Color(0xFF454B5C),
                                                              fontWeight: FontWeight.w600,
                                                              fontSize: 14),
                                                        ),
                                                        Text(
                                                          DateFormat("dd-mm-yy hh:mm a").format(DateTime.parse(
                                                              DateTime.fromMillisecondsSinceEpoch(item.time)
                                                                  .toLocal()
                                                                  .toString())),
                                                          style: GoogleFonts.poppins(
                                                              color: const Color(0xFF8C9BB2),
                                                              fontWeight: FontWeight.w500,
                                                              fontSize: 11),
                                                        ),
                                                      ],
                                                    ),
                                                    Text(
                                                      item.orderStatus,
                                                      style: GoogleFonts.poppins(
                                                          color: const Color(0xFFFFB26B),
                                                          fontWeight: FontWeight.w600,
                                                          fontSize: 12),
                                                    ),
                                                    Text(
                                                      "\$${item.total}",
                                                      style: GoogleFonts.poppins(
                                                          color: const Color(0xFF454B5C),
                                                          fontWeight: FontWeight.w600,
                                                          fontSize: 12),
                                                    ),
                                                  ],
                                                ),
                                                Divider(
                                                  thickness: 1,
                                                  color: Colors.black12.withOpacity(0.09),
                                                ),
                                              ],
                                            ),
                                          );
                                        })
                                    : Center(
                                        child: Text("No order received yet".tr),
                                      );
                              }
                            },
                          ),
                          const SizedBox(
                            height: 50,
                          )
                        ],
                      ),
                    ),
                  ),
                  SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Order No.".tr,
                                style: GoogleFonts.poppins(
                                    color: const Color(0xFF3B5998), fontWeight: FontWeight.w600, fontSize: 12),
                              ),
                              Text(
                                "Status".tr,
                                style: GoogleFonts.poppins(
                                    color: const Color(0xFF3B5998), fontWeight: FontWeight.w600, fontSize: 12),
                              ),
                              Text(
                                "Earning".tr,
                                style: GoogleFonts.poppins(
                                    color: const Color(0xFF3B5998), fontWeight: FontWeight.w600, fontSize: 12),
                              ),
                            ],
                          ),
                          Divider(
                            thickness: 1,
                            color: Colors.black12.withOpacity(0.09),
                          ),
                          StreamBuilder<List<MyOrderModel>>(
                            stream: getOrdersStreamFromFirestore(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return const Center(
                                    child: CircularProgressIndicator()); // Show a loading indicator while data is being fetched
                              } else if (snapshot.hasError) {
                                return Text('Error: ${snapshot.error}');
                              } else {
                                List<MyOrderModel> users = snapshot.data ?? [];

                                return users.isNotEmpty
                                    ? ListView.builder(
                                        padding: EdgeInsets.zero,
                                        physics: const NeverScrollableScrollPhysics(),
                                        itemCount: users.length,
                                        shrinkWrap: true,
                                        itemBuilder: (context, index) {
                                          final item = users[index];
                                          return GestureDetector(
                                            behavior: HitTestBehavior.translucent,
                                            onTap: () {
                                              Get.to(() => DeliveryOderDetailsScreen(
                                                    model: item,
                                                  ));
                                            },
                                            child: Column(
                                              children: [
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Column(
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Text(
                                                          item.orderId.toString(),
                                                          style: GoogleFonts.poppins(
                                                              color: const Color(0xFF454B5C),
                                                              fontWeight: FontWeight.w600,
                                                              fontSize: 14),
                                                        ),
                                                        Text(
                                                          DateFormat("dd-mm-yy hh:mm a").format(DateTime.parse(
                                                              DateTime.fromMillisecondsSinceEpoch(item.time)
                                                                  .toLocal()
                                                                  .toString())),
                                                          style: GoogleFonts.poppins(
                                                              color: const Color(0xFF8C9BB2),
                                                              fontWeight: FontWeight.w500,
                                                              fontSize: 11),
                                                        ),
                                                      ],
                                                    ),
                                                    Text(
                                                      item.orderStatus,
                                                      style: GoogleFonts.poppins(
                                                          color: const Color(0xFFFFB26B),
                                                          fontWeight: FontWeight.w600,
                                                          fontSize: 12),
                                                    ),
                                                    Text(
                                                      "\$${item.total}",
                                                      style: GoogleFonts.poppins(
                                                          color: const Color(0xFF454B5C),
                                                          fontWeight: FontWeight.w600,
                                                          fontSize: 12),
                                                    ),
                                                  ],
                                                ),
                                                Divider(
                                                  thickness: 1,
                                                  color: Colors.black12.withOpacity(0.09),
                                                ),
                                              ],
                                            ),
                                          );
                                        })
                                    : Center(
                                        child: Text("No order received yet".tr),
                                      );
                              }
                              return const CircularProgressIndicator();
                            },
                          ),
                          const SizedBox(
                            height: 30,
                          )
                        ],
                      ),
                    ),
                  ),
                ]),
              )
            ],
          ).appPaddingForScreen,
        ));
  }

  Stream<List<MyOrderModel>> getOrdersStreamFromFirestore() {
    return FirebaseFirestore.instance
        .collection('order')
        .where("vendorId", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .orderBy("time", descending: true)
        .snapshots()
        .map((querySnapshot) {
      List<MyOrderModel> orders = [];
      try {
        for (var doc in querySnapshot.docs) {
          orders.add(MyOrderModel.fromJson(doc.data(), doc.id));
        }
      } catch (e) {
        throw Exception(e.toString());
      }
      return orders;
    });
  }

  Stream<List<MyDiningOrderModel>> getDiningOrdersStreamFromFirestore() {
    return FirebaseFirestore.instance
        .collection('dining_order')
        .where("vendorId", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .orderBy("time", descending: true)
        .snapshots()
        .map((querySnapshot) {
      List<MyDiningOrderModel> diningOrders = [];
      try {
        for (var doc in querySnapshot.docs) {
          diningOrders.add(MyDiningOrderModel.fromJson(doc.data(), doc.id));
        }
      } catch (e) {
        throw Exception(e.toString());
      }
      return diningOrders;
    });
  }
}
