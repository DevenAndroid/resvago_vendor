import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:resvago_vendor/screen/dashboard/restaurant_open_time.dart';
import 'package:resvago_vendor/screen/user_profile.dart';
import 'package:resvago_vendor/utils/helper.dart';
import '../../Firebase_service/firebase_service.dart';
import '../../controllers/bottomnavbar_controller.dart';
import '../../model/dining_order_modal.dart';
import '../../model/order_details_modal.dart';
import '../../model/profile_model.dart';
import '../../model/signup_model.dart';
import '../../widget/addsize.dart';
import '../../widget/appassets.dart';
import '../../widget/apptheme.dart';
import '../bottom_nav_bar/oder_list_screen.dart';
import '../delivery_oders_details_screen.dart';
import '../oder_details_screen.dart';
import '../set_store_time/set_store_time.dart';

class VendorDashboard extends StatefulWidget {
  const VendorDashboard({super.key});
  static var vendorDashboard = "/vendorDashboard";
  @override
  State<VendorDashboard> createState() => _VendorDashboardState();
}

class _VendorDashboardState extends State<VendorDashboard> {
  final bottomController = Get.put(BottomNavBarController());
  final FirebaseService firebaseService = FirebaseService();
  DateTime? time;
  DateTime? time1;
  List imgList = [
    AppAssets.dashBoardImage1,
    AppAssets.dashBoardImage2,
    AppAssets.dashBoardImage3,
    AppAssets.dashBoardImage4,
  ];

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  int currentDrawer = 0;
  FirebaseService service = FirebaseService();
  ProfileData profileData = ProfileData();

  void restaurantData() {
    FirebaseFirestore.instance.collection("vendor_users").doc(FirebaseAuth.instance.currentUser!.uid).get().then((value) {
      if (value.exists) {
        if (value.data() == null) return;
        profileData = ProfileData.fromJson(value.data()!);
        log(profileData.toJson().toString());
        setState(() {});
      }
    });
  }

  @override
  void initState() {
    super.initState();
    if (!kIsWeb) {
      firebaseService.updateFirebaseToken();
    }
    restaurantData();
  }

  Future<int> totalSoldItem() async {
    final item1 = await FirebaseFirestore.instance
        .collection('order')
        .where("vendorId", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .where("order_status", isEqualTo: "Order Completed")
        .count()
        .get();
    final item2 = await FirebaseFirestore.instance
        .collection('dining_order')
        .where("vendorId", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .where("order_status", isEqualTo: "Order Completed")
        .count()
        .get();
    return item1.count + item2.count;
  }

  @override
  Widget build(BuildContext context) {
    if (!kIsWeb) {
      firebaseService.sendNotifications();
    }
    log("sfdsfgdsg${FirebaseAuth.instance.currentUser!.uid}");
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          // toolbarHeight: 80,
          surfaceTintColor: Colors.white,
          elevation: 0,
          leadingWidth: 45,
          automaticallyImplyLeading: false,
          //backgroundColor: const Color(0xffF5F5F5),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () {
                    bottomController.scaffoldKey.currentState!.openDrawer();
                  },
                  child: const Icon(Icons.menu, color: Color(0xff292F45))),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Hi, ${(profileData.restaurantName ?? "")}",
                      style: GoogleFonts.ibmPlexSansArabic(
                          fontWeight: FontWeight.w500, fontSize: AddSize.font16, color: const Color(0xff292F45)),
                    ),
                    GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () {
                        Get.to(const SetTimeScreen());
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Restaurant Time:".tr,
                            style: GoogleFonts.ibmPlexSansArabic(
                                fontWeight: FontWeight.w500, fontSize: AddSize.font14, color: const Color(0xff737A8A)),
                          ),
                          Flexible(child: RestaurantTimingScreen(docId: profileData.docid.toString())),
                          SizedBox(
                            width: AddSize.size5,
                          ),
                          GestureDetector(
                            behavior: HitTestBehavior.translucent,
                            onTap: () async {
                              User? currentUser = FirebaseAuth.instance.currentUser;
                              RegisterData? thisUserModel = await service.getUserInfo(uid: currentUser!.uid);
                              log(thisUserModel.toString());
                            },
                            child: Icon(
                              Icons.edit,
                              color: AppTheme.primaryColor,
                              size: AddSize.size15,
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          actions: [
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 10, top: 5),
                  child: GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () {
                      Get.to(const UserProfileScreen());
                    },
                    child: Stack(
                      children: [
                        SizedBox(
                          height: 45,
                          width: 45,
                          child: Container(
                            decoration: BoxDecoration(border: Border.all(color: Colors.grey, width: 1), shape: BoxShape.circle),
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(100),
                                child: Image.network(
                                  profileData.image.toString(),
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => CachedNetworkImage(
                                    fit: BoxFit.cover,
                                    imageUrl: profileData.image.toString(),
                                    height: AddSize.size30,
                                    width: AddSize.size30,
                                    errorWidget: (_, __, ___) => const Icon(
                                      Icons.person,
                                      size: 20,
                                      color: Colors.black,
                                    ),
                                    placeholder: (_, __) => const SizedBox(),
                                  ),
                                )),
                          ),
                        ),
                        Positioned(
                            top: 2,
                            left: 0,
                            child: Container(
                              height: 13,
                              width: 13,
                              clipBehavior: Clip.antiAlias,
                              decoration: BoxDecoration(
                                color: AppTheme.userActive,
                                border: Border.all(color: AppTheme.backgroundcolor, width: 2),
                                borderRadius: BorderRadius.circular(50),
                                // color: Colors.brown
                              ),
                            ))
                      ],
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
        body: DefaultTabController(
          length: 2,
          child: Theme(
            data: ThemeData(useMaterial3: true),
            child: Column(children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Container(
                        // height: 120,
                        // width: 160,
                        padding: EdgeInsets.symmetric(horizontal: AddSize.padding14, vertical: AddSize.padding10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: AppTheme.backgroundcolor,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.1),
                              spreadRadius: 5,
                              blurRadius: 7,
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 40,
                              width: 40,
                              child: Image.asset(imgList[0].toString()),
                            ),
                            Text(
                              "0",
                              style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                                  height: 1.5, fontWeight: FontWeight.w500, fontSize: AddSize.font20, color: AppTheme.blackcolor),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Gross Sales",
                                  style: GoogleFonts.ibmPlexSansArabic(
                                      height: 1.5,
                                      fontWeight: FontWeight.w500,
                                      fontSize: AddSize.font12,
                                      color: const Color(0xff8C9BB2)),
                                ),
                                Text(
                                  "0%",
                                  //"10%",
                                  style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                                      height: 1.5, fontWeight: FontWeight.w600, fontSize: AddSize.font12, color: Colors.green),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Expanded(
                      child: Container(
                        // height: 120,
                        // width: 160,
                        padding: EdgeInsets.symmetric(horizontal: AddSize.padding14, vertical: AddSize.padding10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: AppTheme.backgroundcolor,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.1),
                              spreadRadius: 5,
                              blurRadius: 7,
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 40,
                              width: 40,
                              child: Image.asset(imgList[1].toString()),
                            ),
                            Text(
                              "0",
                              style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                                  height: 1.5, fontWeight: FontWeight.w500, fontSize: AddSize.font20, color: AppTheme.blackcolor),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Earning",
                                  style: GoogleFonts.ibmPlexSansArabic(
                                      height: 1.5,
                                      fontWeight: FontWeight.w500,
                                      fontSize: AddSize.font12,
                                      color: const Color(0xff8C9BB2)),
                                ),
                                Text(
                                  "0%",
                                  //"10%",
                                  style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                                      height: 1.5, fontWeight: FontWeight.w600, fontSize: AddSize.font12, color: Colors.green),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Container(
                        // height: 120,
                        // width: 160,
                        padding: EdgeInsets.symmetric(horizontal: AddSize.padding14, vertical: AddSize.padding10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: AppTheme.backgroundcolor,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.1),
                              spreadRadius: 5,
                              blurRadius: 7,
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 40,
                              width: 40,
                              child: Image.asset(imgList[2].toString()),
                            ),
                            FutureBuilder(
                              future: totalSoldItem(),
                              builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
                                if (snapshot.hasData) {
                                  return Text(
                                    (snapshot.data ?? "0").toString(),
                                    style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                                        height: 1.5,
                                        fontWeight: FontWeight.w500,
                                        fontSize: AddSize.font20,
                                        color: AppTheme.blackcolor),
                                  );
                                }
                                return Text(
                                  "0",
                                  style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                                      height: 1.5,
                                      fontWeight: FontWeight.w500,
                                      fontSize: AddSize.font20,
                                      color: AppTheme.blackcolor),
                                );
                              },
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Sold Items",
                                  style: GoogleFonts.ibmPlexSansArabic(
                                      height: 1.5,
                                      fontWeight: FontWeight.w500,
                                      fontSize: AddSize.font12,
                                      color: const Color(0xff8C9BB2)),
                                ),
                                Text(
                                  "0%",
                                  //"10%",
                                  style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                                      height: 1.5, fontWeight: FontWeight.w600, fontSize: AddSize.font12, color: Colors.green),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Expanded(
                      child: Container(
                        // height: 120,
                        // width: 160,
                        padding: EdgeInsets.symmetric(horizontal: AddSize.padding14, vertical: AddSize.padding10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: AppTheme.backgroundcolor,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.1),
                              spreadRadius: 5,
                              blurRadius: 7,
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 40,
                              width: 40,
                              child: Image.asset(imgList[3].toString()),
                            ),
                            Text(
                              (profileData.order_count ?? "").toString(),
                              style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                                  height: 1.5, fontWeight: FontWeight.w500, fontSize: AddSize.font20, color: AppTheme.blackcolor),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Order Received",
                                  style: GoogleFonts.ibmPlexSansArabic(
                                      height: 1.5,
                                      fontWeight: FontWeight.w500,
                                      fontSize: AddSize.font12,
                                      color: const Color(0xff8C9BB2)),
                                ),
                                Text(
                                  "10%",
                                  //"10%",
                                  style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                                      height: 1.5, fontWeight: FontWeight.w600, fontSize: AddSize.font12, color: Colors.green),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const TabBar(labelColor: Color(0xFF454B5C), indicatorColor: Color(0xFF3B5998), indicatorWeight: 4, tabs: [
                Tab(
                  text: "Dining",
                ),
                Tab(
                  text: "Delivery",
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
                                return const Center(child: CircularProgressIndicator());
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
                                        child: Text("No User Found".tr),
                                      );
                              }
                            },
                          ),
                          SizedBox(height: 50,)
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
                                        child: Text("No User Found".tr),
                                      );
                              }
                              return const CircularProgressIndicator();
                            },
                          ),
                          SizedBox(height: 50,)
                        ],
                      ),
                    ),
                  ),
                ]),
              )
            ]).appPaddingForScreen,
          ),
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
