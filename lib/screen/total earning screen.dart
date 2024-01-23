import 'dart:convert';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:resvago_vendor/utils/helper.dart';
import 'package:resvago_vendor/widget/appassets.dart';
import 'package:resvago_vendor/widget/apptheme.dart';

import '../controllers/bottomnavbar_controller.dart';
import '../model/dining_order_modal.dart';
import '../model/order_details_modal.dart';
import '../widget/addsize.dart';
import 'bottom_nav_bar/wallet_screen.dart';

class TotalEarningScreen extends StatefulWidget {
  const TotalEarningScreen({super.key});

  @override
  State<TotalEarningScreen> createState() => _TotalEarningScreenState();
}

class _TotalEarningScreenState extends State<TotalEarningScreen> {
  final controller = Get.put(BottomNavBarController());
  double total = 0;
  double total1 = 0;
  double combinedTotal = 0; // Variable to store the sum
  var orderType = "Dining";
  String searchQuery = '';
  @override
  void initState() {
    super.initState();
    fetchTotalEarnings();
    getOrderList();
  }

  double totalEarnings1 = 0;
  double totalEarnings2 = 0;
  double totalEarnings3 = 0;
  double totalEarnings = 0;

  Future<double> calculateTotalEarnings() async {
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore.instance
        .collection('dining_order')
        .where("vendorId", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .where("order_status", isEqualTo: "Order Completed")
        .get();
    for (QueryDocumentSnapshot<Map<String, dynamic>> documentSnapshot in querySnapshot.docs) {
      double orderAmount = double.parse(documentSnapshot.data()["total"]);
      totalEarnings1 += orderAmount;
    }

    return totalEarnings1;
  }

  Future<double> calculateTotalEarnings1() async {
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore.instance
        .collection('order')
        .where("vendorId", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .where("order_status", isEqualTo: "Order Completed")
        .get();
    for (QueryDocumentSnapshot<Map<String, dynamic>> documentSnapshot in querySnapshot.docs) {
      double orderAmount = double.parse(documentSnapshot.data()["total"].toString());
      totalEarnings2 += orderAmount;
    }

    return totalEarnings2;
  }

  Future<double> adminCommission() async {
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore.instance
        .collection('order')
        .where("vendorId", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .where("order_status", isEqualTo: "Order Completed")
        .get();
    for (QueryDocumentSnapshot<Map<String, dynamic>> documentSnapshot in querySnapshot.docs) {
      double? orderAmount = double.tryParse(documentSnapshot.data()["admin_commission"].toString());
      log("fghgfj$orderAmount");
      totalEarnings3 += orderAmount!;
    }
    return totalEarnings3;
  }

  Future<void> fetchTotalEarnings() async {
    double earnings = await calculateTotalEarnings();
    double earnings1 = await calculateTotalEarnings1();
    double earnings2 = await adminCommission();
    setState(() {
      totalEarnings1 = earnings;
      totalEarnings2 = earnings1;
      totalEarnings = earnings + earnings1 - earnings2;
      log("dgdfhdfh$totalEarnings");
    });
  }

  List<MyOrderModel>? myOrder;
  getOrderList() {
    FirebaseFirestore.instance
        .collection("order")
        .where("vendorId", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((value) {
      log("fhfh${jsonEncode(value.docs.first.data())}");
      for (var element in value.docs) {
        var gg = element.data();
        log("fxvgxcb${jsonEncode(gg.toString())}");
        myOrder ??= [];
        myOrder!.add(MyOrderModel.fromJson(gg, element.id));
      }
    });
    setState(() {});
  }

  List<MyDiningOrderModel>? myDiningOrder;
  getDiningOrderList() {
    FirebaseFirestore.instance
        .collection("dining_order")
        .where("vendorId", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((value) {
      for (var element in value.docs) {
        var gg = element.data();
        myDiningOrder ??= [];
        myDiningOrder!.add(MyDiningOrderModel.fromJson(gg, element.id));
      }
    });
  }

  List<MyOrderModel> orders = [];
  Stream<List<MyOrderModel>> getOrdersStreamFromFirestore() {
    return FirebaseFirestore.instance
        .collection('order')
        .where("vendorId", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .where("order_status", isEqualTo: "Order Completed")
        .orderBy("time", descending: true)
        .snapshots()
        .map((querySnapshot) {
      orders = [];
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

  List<MyDiningOrderModel> diningOrders = [];
  Stream<List<MyDiningOrderModel>> getDiningOrdersStreamFromFirestore() {
    return FirebaseFirestore.instance
        .collection('dining_order')
        .where("vendorId", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .where("order_status", isEqualTo: "Order Completed")
        .orderBy("time", descending: true)
        .snapshots()
        .map((querySnapshot) {
      diningOrders = [];
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

  List<MyDiningOrderModel> filterDiningOrder(List<MyDiningOrderModel> diningOrder, String query) {
    if (query.isEmpty) {
      return diningOrder;
    } else {
      return diningOrder.where((diningOrder) {
        if (diningOrder.orderId is String) {
          return diningOrder.orderId.toLowerCase().contains(query.toLowerCase());
        }
        return false;
      }).toList();
    }
  }

  List<MyOrderModel> filterOrder(List<MyOrderModel> order, String query) {
    if (query.isEmpty) {
      return order;
    } else {
      return order.where((order) {
        if (order.orderId is String) {
          return order.orderId.toLowerCase().contains(query.toLowerCase());
        }
        return false;
      }).toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 273,
              child: Stack(children: [
                Container(
                  color: Colors.white,
                ),
                Container(
                  height: 260,
                  decoration: const BoxDecoration(
                      color: AppTheme.primaryColor,
                      borderRadius: BorderRadius.only(bottomLeft: Radius.circular(50), bottomRight: Radius.circular(50))),
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 20.0,
                      right: 20,
                      top: 10,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 30,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    Get.back();
                                  },
                                  child: const Icon(
                                    Icons.arrow_back_ios_rounded,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(width: 20),
                                Text(
                                  "Total Earning".tr,
                                  style: GoogleFonts.poppins(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w400),
                                ),
                              ],
                            ),
                            Container(
                              height: 35,
                              width: 35,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(4),
                                  color: Colors.white,
                                  border: Border.all(
                                    color: const Color(0xff363539).withOpacity(.1),
                                  )),
                              child: Padding(
                                  padding: const EdgeInsets.all(2.0),
                                  child: PopupMenuButton<int>(
                                      padding: EdgeInsets.zero,
                                      icon: const Icon(
                                        Icons.filter_list_sharp,
                                        color: AppTheme.primaryColor,
                                      ),
                                      color: Colors.white,
                                      surfaceTintColor: Colors.white,
                                      itemBuilder: (context) {
                                        return [
                                          PopupMenuItem(
                                            value: 1,
                                            onTap: () {
                                              orderType = "Dining";
                                              log(orderType.toString());
                                              setState(() {});
                                            },
                                            child: const Column(
                                              children: [Text("Dining Orders"), Divider()],
                                            ),
                                          ),
                                          PopupMenuItem(
                                            value: 1,
                                            onTap: () {
                                              orderType = "Delivery";
                                              log(orderType.toString());
                                              setState(() {});
                                            },
                                            child: const Column(
                                              children: [
                                                Text("Delivery Orders"),
                                                Divider(
                                                  color: Colors.white,
                                                )
                                              ],
                                            ),
                                          ),
                                        ];
                                      })),
                            )
                          ],
                        ),
                        Text(
                          "\$$totalEarnings",
                          style: GoogleFonts.poppins(color: Colors.white, fontSize: 45, fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(
                          height: 17,
                        ),
                        Center(
                          child: SizedBox(
                            width: AddSize.screenWidth,
                            height: 50,
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                    primary: const Color(0xFF355EB3),
                                    textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
                                onPressed: () {
                                  controller.updateIndexValue(3);
                                  Get.back();
                                  Get.back();
                                },
                                child: Text(
                                  "Withdrawal Amount".tr,
                                  style: GoogleFonts.poppins(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w500),
                                )),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Positioned.fill(
                  top: 222,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 16.0, right: 16),
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10), boxShadow: [
                            BoxShadow(
                                color: Colors.grey.shade300,
                                // offset: Offset(2, 2),
                                blurRadius: 05)
                          ]),
                          child: TextField(
                            maxLines: 1,
                            style: const TextStyle(fontSize: 17),
                            textAlignVertical: TextAlignVertical.center,
                            textInputAction: TextInputAction.search,
                            onChanged: (value) => {
                              setState(() {
                                searchQuery = value;
                              })
                            },
                            decoration: InputDecoration(
                                filled: true,
                                suffixIcon: IconButton(
                                  onPressed: () {
                                    // searchQuery = value;
                                  },
                                  icon: Icon(
                                    Icons.search_rounded,
                                    color: const Color(0xFF9DA4BB),
                                    size: AddSize.size25,
                                  ),
                                ),
                                border: const OutlineInputBorder(
                                    borderSide: BorderSide.none, borderRadius: BorderRadius.all(Radius.circular(10))),
                                fillColor: Colors.white,
                                contentPadding: EdgeInsets.symmetric(horizontal: AddSize.padding20, vertical: AddSize.padding10),
                                hintText: 'Search'.tr,
                                hintStyle: const TextStyle(fontSize: 14, color: Colors.black, fontWeight: FontWeight.w300)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ]),
            ),
            orderType == "Dining"
                ? StreamBuilder<List<MyDiningOrderModel>>(
                    stream: getDiningOrdersStreamFromFirestore(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        List<MyDiningOrderModel> myOrder = snapshot.data ?? [];
                        List<MyDiningOrderModel> diningOrder = snapshot.data ?? [];
                        log(diningOrder.toString());
                        final filteredUsers = filterDiningOrder(diningOrder, searchQuery); //
                        return filteredUsers.isNotEmpty
                            ? ListView.builder(
                                padding: const EdgeInsets.only(top: 15),
                                physics: const BouncingScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: filteredUsers.length,
                                itemBuilder: (BuildContext context, int index) {
                                  var orderItem = filteredUsers[index];
                                  return Padding(
                                      padding: const EdgeInsets.only(left: 16.0, right: 16),
                                      child: Column(
                                        children: [
                                          Container(
                                              padding: const EdgeInsets.all(8),
                                              decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius: BorderRadius.circular(10),
                                                  boxShadow: [
                                                    BoxShadow(
                                                        color: Colors.grey.shade300,
                                                        // offset: Offset(2, 2),
                                                        blurRadius: 05)
                                                  ]),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      SvgPicture.asset(AppAssets.arrowDown),
                                                      const SizedBox(
                                                        width: 12,
                                                      ),
                                                      Column(
                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Text(
                                                            "Order ID:".tr,
                                                            style: GoogleFonts.poppins(
                                                                color: const Color(0xFF21283D),
                                                                fontSize: 12,
                                                                fontWeight: FontWeight.w400),
                                                          ),
                                                          const SizedBox(
                                                            height: 3,
                                                          ),
                                                          Text(
                                                            "Amount:".tr,
                                                            style: GoogleFonts.poppins(
                                                                color: const Color(0xFF21283D),
                                                                fontSize: 12,
                                                                fontWeight: FontWeight.w400),
                                                          ),
                                                          // const SizedBox(
                                                          //   height: 3,
                                                          // ),
                                                          // Text(
                                                          //   "Admin Commission:",
                                                          //   style: GoogleFonts.poppins(
                                                          //       color: const Color(0xFF21283D),
                                                          //       fontSize: 12,
                                                          //       fontWeight: FontWeight.w400),
                                                          // ),
                                                          const SizedBox(
                                                            height: 3,
                                                          ),
                                                          Text(
                                                            "Earning:".tr,
                                                            style: GoogleFonts.poppins(
                                                                color: const Color(0xFF21283D),
                                                                fontSize: 12,
                                                                fontWeight: FontWeight.w400),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.only(right: 8.0),
                                                    child: Column(
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Text(
                                                          "#${orderItem.orderId}",
                                                          style: GoogleFonts.poppins(
                                                              color: const Color(0xFF424750),
                                                              fontSize: 12,
                                                              fontWeight: FontWeight.w300),
                                                        ),
                                                        const SizedBox(
                                                          height: 3,
                                                        ),
                                                        Text(
                                                          "\$${orderItem.total}",
                                                          style: GoogleFonts.poppins(
                                                              color: const Color(0xFF424750),
                                                              fontSize: 12,
                                                              fontWeight: FontWeight.w300),
                                                        ),
                                                        // const SizedBox(
                                                        //   height: 3,
                                                        // ),
                                                        // Text(
                                                        //   "\$${orderItem.total}",
                                                        //   style: GoogleFonts.poppins(
                                                        //       color: const Color(0xFF424750),
                                                        //       fontSize: 12,
                                                        //       fontWeight: FontWeight.w300),
                                                        // ),
                                                        const SizedBox(
                                                          height: 3,
                                                        ),
                                                        Text(
                                                          "\$${orderItem.total}",
                                                          style: GoogleFonts.poppins(
                                                              color: const Color(0xFF424750),
                                                              fontSize: 12,
                                                              fontWeight: FontWeight.w300),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              )),
                                          const SizedBox(
                                            height: 10,
                                          )
                                        ],
                                      ));
                                })
                            : Column(
                                children: [
                                  Container(
                                    margin: const EdgeInsets.only(
                                      top: 18,
                                    ),
                                    decoration: const BoxDecoration(
                                      color: Color(0xffFFFFFF),
                                    ),
                                    child: Column(
                                      // mainAxisAlignment: MainAxisAlignment.start,
                                      // crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          'Empty',
                                          style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w500),
                                        ),
                                        const SizedBox(
                                          height: 15,
                                        ),
                                        Text(
                                          'You do not have an active order of this time',
                                          style: GoogleFonts.poppins(
                                              fontSize: 15, fontWeight: FontWeight.w400, color: const Color(0xff747474)),
                                        ),
                                        const SizedBox(
                                          height: 40,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              );
                      }
                      return const SizedBox.shrink();
                    },
                  )
                : StreamBuilder<List<MyOrderModel>>(
                    stream: getOrdersStreamFromFirestore(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        List<MyOrderModel> myOrder = snapshot.data ?? [];
                        List<MyOrderModel> order = snapshot.data ?? [];
                        log(order.toString());
                        final filteredUsers = filterOrder(order, searchQuery); //
                        return filteredUsers.isNotEmpty
                            ? ListView.builder(
                                padding: const EdgeInsets.only(top: 15),
                                physics: const BouncingScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: filteredUsers.length,
                                itemBuilder: (BuildContext context, int index) {
                                  var orderItem = filteredUsers[index];
                                  log(orderItem.admin_commission.toString());
                                  String earning1 = "\$${(orderItem.total - (orderItem.admin_commission ?? 0.0)).toString()}";
                                  return Padding(
                                      padding: const EdgeInsets.only(left: 16.0, right: 16),
                                      child: Column(
                                        children: [
                                          Container(
                                              padding: const EdgeInsets.all(8),
                                              decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius: BorderRadius.circular(10),
                                                  boxShadow: [
                                                    BoxShadow(
                                                        color: Colors.grey.shade300,
                                                        // offset: Offset(2, 2),
                                                        blurRadius: 05)
                                                  ]),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      SvgPicture.asset(AppAssets.arrowDown),
                                                      const SizedBox(
                                                        width: 12,
                                                      ),
                                                      Column(
                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Text(
                                                            "Order ID:",
                                                            style: GoogleFonts.poppins(
                                                                color: const Color(0xFF21283D),
                                                                fontSize: 12,
                                                                fontWeight: FontWeight.w400),
                                                          ),
                                                          const SizedBox(
                                                            height: 3,
                                                          ),
                                                          Text(
                                                            "Amount:",
                                                            style: GoogleFonts.poppins(
                                                                color: const Color(0xFF21283D),
                                                                fontSize: 12,
                                                                fontWeight: FontWeight.w400),
                                                          ),
                                                          const SizedBox(
                                                            height: 3,
                                                          ),
                                                          Text(
                                                            "Admin Commission:",
                                                            style: GoogleFonts.poppins(
                                                                color: const Color(0xFF21283D),
                                                                fontSize: 12,
                                                                fontWeight: FontWeight.w400),
                                                          ),
                                                          const SizedBox(
                                                            height: 3,
                                                          ),
                                                          Text(
                                                            "Earning:",
                                                            style: GoogleFonts.poppins(
                                                                color: const Color(0xFF21283D),
                                                                fontSize: 12,
                                                                fontWeight: FontWeight.w400),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.only(right: 8.0),
                                                    child: Column(
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Text(
                                                          "#${orderItem.orderId}",
                                                          style: GoogleFonts.poppins(
                                                              color: const Color(0xFF424750),
                                                              fontSize: 12,
                                                              fontWeight: FontWeight.w300),
                                                        ),
                                                        const SizedBox(
                                                          height: 3,
                                                        ),
                                                        Text(
                                                          "\$${orderItem.total}",
                                                          style: GoogleFonts.poppins(
                                                              color: const Color(0xFF424750),
                                                              fontSize: 12,
                                                              fontWeight: FontWeight.w300),
                                                        ),
                                                        const SizedBox(
                                                          height: 3,
                                                        ),
                                                        Text(
                                                          "\$${(orderItem.admin_commission ?? "0.0")}",
                                                          style: GoogleFonts.poppins(
                                                              color: const Color(0xFF424750),
                                                              fontSize: 12,
                                                              fontWeight: FontWeight.w300),
                                                        ),
                                                        const SizedBox(
                                                          height: 3,
                                                        ),
                                                        Text(
                                                          "\$$earning1",
                                                          style: GoogleFonts.poppins(
                                                              color: const Color(0xFF424750),
                                                              fontSize: 12,
                                                              fontWeight: FontWeight.w300),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              )),
                                          const SizedBox(
                                            height: 10,
                                          )
                                        ],
                                      ));
                                })
                            : Column(
                                children: [
                                  Container(
                                    margin: const EdgeInsets.only(
                                      top: 18,
                                    ),
                                    decoration: const BoxDecoration(
                                      color: Color(0xffFFFFFF),
                                    ),
                                    child: Column(
                                      // mainAxisAlignment: MainAxisAlignment.start,
                                      // crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        const SizedBox(
                                          height: 15,
                                        ),
                                        Text(
                                          'You do not have an order of this time',
                                          style: GoogleFonts.poppins(
                                              fontSize: 15, fontWeight: FontWeight.w400, color: const Color(0xff747474)),
                                        ),
                                        const SizedBox(
                                          height: 40,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
          ],
        ).appPaddingForScreen,
      ),
    );
  }
}
