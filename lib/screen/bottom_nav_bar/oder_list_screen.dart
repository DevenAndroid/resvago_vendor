import 'dart:developer';
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
  int filter = 0;
  String? selectedValue;
  double totalEarnings1 = 0;
  double totalEarnings2 = 0;
  double totalEarnings = 0;

  Future<double> calculateTotalEarnings() async {
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore.instance
        .collection('dining_order')
        .where("vendorId", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .where("order_status", isEqualTo: "Order Completed")
        .get();
    for (QueryDocumentSnapshot<Map<String, dynamic>> documentSnapshot in querySnapshot.docs) {
      double orderAmount = double.parse(documentSnapshot.data()["total"].toString());
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

  Future<void> fetchTotalEarnings() async {
    double earnings = await calculateTotalEarnings();
    double earnings1 = await calculateTotalEarnings1();
    setState(() {
      totalEarnings1 = earnings;
      totalEarnings2 = earnings1;
      totalEarnings = earnings + earnings1;
      log("dgdfhdfh$totalEarnings");
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchTotalEarnings();
  }

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
                                "\$${totalEarnings}",
                                style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 28),
                              ),
                              Text(
                                "Your earning this month".tr,
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
                        // Expanded(
                        //   child: SizedBox(
                        //     height: 50,
                        //     // width: size.width * .4,
                        //     child: Padding(
                        //       padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 2),
                        //       child: PopupMenuButton<int>(
                        //         constraints: const BoxConstraints(maxHeight: 300),
                        //         position: PopupMenuPosition.under,
                        //         offset: Offset.fromDirection(1, 1),
                        //         onSelected: (value) {
                        //           setState(() {});
                        //         },
                        //         // icon: Icon(Icons.keyboard_arrow_down),
                        //         itemBuilder: (context) => [
                        //           PopupMenuItem(
                        //               child: Column(
                        //             children: [
                        //               InkWell(
                        //                 onTap: () {
                        //                   dropDownValue1.value = 'No';
                        //                 },
                        //                 child: Text('No'.tr,
                        //                     style: const TextStyle(
                        //                         fontSize: 15, color: Colors.blueGrey, fontWeight: FontWeight.w500)),
                        //               ),
                        //             ],
                        //           )),
                        //           PopupMenuItem(
                        //               child: Column(
                        //             children: [
                        //               InkWell(
                        //                 onTap: () {
                        //                   setState(() {
                        //                     dropDownValue1.value = 'Yes';
                        //                   });
                        //                 },
                        //                 child: Text('Yes'.tr,
                        //                     style: const TextStyle(
                        //                         fontSize: 15, color: Colors.blueGrey, fontWeight: FontWeight.w500)),
                        //               ),
                        //             ],
                        //           )),
                        //         ],
                        //         child: Container(
                        //           padding: const EdgeInsets.all(9),
                        //           decoration: BoxDecoration(
                        //             borderRadius: BorderRadius.circular(10),
                        //             border: Border.all(color: Colors.white.withOpacity(.35)),
                        //             color: Colors.white.withOpacity(.10),
                        //           ),
                        //           child: Row(
                        //             mainAxisAlignment: MainAxisAlignment.center,
                        //             children: [
                        //               Obx(() {
                        //                 return Row(
                        //                   mainAxisAlignment: MainAxisAlignment.center,
                        //                   crossAxisAlignment: CrossAxisAlignment.center,
                        //                   children: [
                        //                     Center(
                        //                       child: Text(
                        //                         dropDownValue1.value.toString().isEmpty
                        //                             ? "Filter"
                        //                             : dropDownValue1.value.toString(),
                        //                         style: const TextStyle(
                        //                             fontSize: 15, color: Colors.white, fontWeight: FontWeight.w500),
                        //                       ),
                        //                     ),
                        //                   ],
                        //                 );
                        //               }),
                        //               const Spacer(),
                        //               const Icon(
                        //                 Icons.arrow_drop_down,
                        //                 color: Colors.white,
                        //               )
                        //             ],
                        //           ),
                        //         ),
                        //       ),
                        //     ),
                        //   ),
                        // ),
                        // const SizedBox(width: 20),
                        Expanded(
                          child: Container(
                              padding: const EdgeInsets.all(1),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: Colors.white.withOpacity(.35)),
                                color: AppTheme.primaryColor,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                child: DropdownButtonFormField<String>(
                                  dropdownColor: AppTheme.primaryColor,
                                  icon: const Icon(Icons.arrow_drop_down_rounded, color: Colors.white),
                                  value: selectedValue,
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      selectedValue = newValue!;
                                      log(selectedValue.toString());
                                      if (filter == 0) {
                                        getDiningPlacedOrder();
                                      }
                                    });
                                  },
                                  items: <String>['Place Order', 'Order Rejected', 'Order Completed']
                                      .map<DropdownMenuItem<String>>((String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(
                                        value,
                                        style: const TextStyle(color: Colors.white),
                                      ),
                                    );
                                  }).toList(),
                                  decoration: InputDecoration(
                                    hintText: "Status".tr,
                                    border: InputBorder.none,
                                    contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                                    focusColor: Colors.white,
                                    hintStyle: const TextStyle(fontSize: 15, color: Colors.white, fontWeight: FontWeight.w500),
                                  ),
                                ),
                              )),
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
                        onChanged: (value) => {
                          setState(() {
                            searchQuery = value;
                          })
                        },
                        decoration: InputDecoration(
                          hintText: "Search".tr,
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.only(left: 10),
                          focusColor: Colors.white,
                          hintStyle: const TextStyle(fontSize: 15, color: Colors.white, fontWeight: FontWeight.w500),
                        ),
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ]),
                ),
              ),
              TabBar(
                  onTap: (value) {
                    filter = value;
                    log(filter.toString());
                    setState(() {});
                  },
                  labelColor: const Color(0xFF454B5C),
                  indicatorColor: const Color(0xFF3B5998),
                  indicatorWeight: 4,
                  tabs: [
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
                            stream: selectedValue == "Place Order" && filter == 0
                                ? getDiningPlacedOrder()
                                : selectedValue == "Order Rejected" && filter == 0
                                    ? getDiningPlacedOrder()
                                    : selectedValue == "Order Completed" && filter == 0
                                        ? getDiningPlacedOrder()
                                        : getDiningOrdersStreamFromFirestore(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return const Center(
                                    child: CircularProgressIndicator()); // Show a loading indicator while data is being fetched
                              } else if (snapshot.hasError) {
                                return Text('Error: ${snapshot.error}');
                              } else {
                                List<MyDiningOrderModel> users = snapshot.data ?? [];
                                List<MyDiningOrderModel> diningOrder = snapshot.data ?? [];
                                log(diningOrder.toString());
                                final filteredUsers = filterDiningOrder(diningOrder, searchQuery); //
                                return filteredUsers.isNotEmpty
                                    ? ListView.builder(
                                        padding: EdgeInsets.zero,
                                        physics: const NeverScrollableScrollPhysics(),
                                        itemCount: filteredUsers.length,
                                        shrinkWrap: true,
                                        itemBuilder: (context, index) {
                                          final item = filteredUsers[index];
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
                                                          color: item.orderStatus == "Order Completed"
                                                              ? Colors.green
                                                              : item.orderStatus == "Order Rejected"
                                                                  ? Colors.red
                                                                  : const Color(0xFFFFB26B),
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
                            stream: selectedValue == "Place Order" && filter == 1
                                ? getPlacedOrder()
                                : selectedValue == "Order Rejected" && filter == 1
                                    ? getPlacedOrder()
                                    : selectedValue == "Order Completed" && filter == 1
                                        ? getPlacedOrder()
                                        : getOrdersStreamFromFirestore(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return const Center(
                                    child: CircularProgressIndicator()); // Show a loading indicator while data is being fetched
                              } else if (snapshot.hasError) {
                                return Text('Error: ${snapshot.error}');
                              } else {
                                List<MyOrderModel> users = snapshot.data ?? [];
                                List<MyOrderModel> order = snapshot.data ?? [];
                                log(order.toString());
                                final filteredOrders = filterOrder(order, searchQuery); //
                                return filteredOrders.isNotEmpty
                                    ? ListView.builder(
                                        padding: EdgeInsets.zero,
                                        physics: const NeverScrollableScrollPhysics(),
                                        itemCount: filteredOrders.length,
                                        shrinkWrap: true,
                                        itemBuilder: (context, index) {
                                          final item = filteredOrders[index];
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
                                                          color: item.orderStatus == "Order Completed"
                                                              ? Colors.green
                                                              : item.orderStatus == "Order Rejected"
                                                                  ? Colors.red
                                                                  : const Color(0xFFFFB26B),
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

  List<MyOrderModel> orders = [];
  Stream<List<MyOrderModel>> getOrdersStreamFromFirestore() {
    return FirebaseFirestore.instance
        .collection('order')
        .where("vendorId", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
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

  Stream<List<MyOrderModel>> getPlacedOrder() {
    return FirebaseFirestore.instance
        .collection('order')
        .where("vendorId", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .where("order_status", isEqualTo: selectedValue)
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

  List<MyOrderModel> filterOrder(List<MyOrderModel> order, String query) {
    if (query.isEmpty) {
      return order; // Return all users if the search query is empty
    } else {
      // Filter the users based on the search query
      return order.where((order) {
        if (order.orderId is String) {
          return order.orderId.toLowerCase().contains(query.toLowerCase());
        }
        return false;
      }).toList();
    }
  }

  List<MyDiningOrderModel> diningOrders = [];
  Stream<List<MyDiningOrderModel>> getDiningOrdersStreamFromFirestore() {
    return FirebaseFirestore.instance
        .collection('dining_order')
        .where("vendorId", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
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

  Stream<List<MyDiningOrderModel>> getDiningPlacedOrder() {
    diningOrders = [];
    return FirebaseFirestore.instance
        .collection('dining_order')
        .where("vendorId", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .where("order_status", isEqualTo: selectedValue)
        .orderBy("time", descending: true)
        .snapshots()
        .map((querySnapshot) {
      log("Gdf");
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
}
