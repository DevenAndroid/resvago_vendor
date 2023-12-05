import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:resvago_vendor/screen/dashboard/restaurant_open_time.dart';
import 'package:resvago_vendor/screen/user_profile.dart';
import 'package:resvago_vendor/utils/helper.dart';
import '../../Firebase_service/firebase_service.dart';
import '../../controllers/bottomnavbar_controller.dart';
import '../../model/profile_model.dart';
import '../../model/signup_model.dart';
import '../../widget/addsize.dart';
import '../../widget/appassets.dart';
import '../../widget/apptheme.dart';
import '../bottom_nav_bar/oder_list_screen.dart';
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
        log("fgdfgdgfdfg");
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
    // firebaseService.updateFirebaseToken();
    restaurantData();
  }

  @override
  Widget build(BuildContext context) {
    // firebaseService.sendNotifications();
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
        key: _scaffoldKey,
        backgroundColor: const Color(0xffF5F5F5),
        appBar: AppBar(
          // toolbarHeight: 80,
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
        body: Theme(
          data: ThemeData(useMaterial3: true),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: AddSize.padding16,
            ),
            child: CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: <Widget>[
                const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [],
                    ),
                  ),
                ),
                SliverGrid.builder(
                  itemCount: 4,
                  // shrinkWrap: true,
                  // physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: kIsWeb
                      ? SliverGridDelegateWithMaxCrossAxisExtent(
                          mainAxisExtent: AddSize.screenHeight * .15,
                          maxCrossAxisExtent: 260,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 5,
                        )
                      : SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 5,
                          mainAxisSpacing: 0,
                          mainAxisExtent: AddSize.screenHeight * .15),
                  itemBuilder: (BuildContext context, int index) {
                    return Column(
                        children: [
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: AddSize.padding14, vertical: AddSize.padding10),
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), color: AppTheme.backgroundcolor),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 40,
                              width: 40,
                              child: Image.asset(imgList[index].toString()),
                            ),
                            Text(
                              "20",
                              style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                                  height: 1.5, fontWeight: FontWeight.w500, fontSize: AddSize.font20, color: AppTheme.blackcolor),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  index == 0
                                      ? "Gross Sales"
                                      : index == 1
                                          ? "Earning"
                                          : index == 2
                                              ? "Sold items"
                                              : "Order Received",
                                  style: GoogleFonts.ibmPlexSansArabic(
                                      height: 1.5,
                                      fontWeight: FontWeight.w500,
                                      fontSize: AddSize.font12,
                                      color: const Color(0xff8C9BB2)),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 15),
                                  child: Text(
                                    "10%",
                                    //"10%",
                                    style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                                        height: 1.5, fontWeight: FontWeight.w600, fontSize: AddSize.font12, color: Colors.green),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      )
                    ]);
                  },
                ),
                SliverToBoxAdapter(
                  child: Column(
                    children: [
                      SizedBox(
                        height: AddSize.size12,
                      ),
                      Container(
                        decoration: BoxDecoration(color: AppTheme.backgroundcolor, borderRadius: BorderRadius.circular(20)),
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: AddSize.padding16, vertical: AddSize.padding10),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Latest Sales".tr,
                                    style: GoogleFonts.ibmPlexSansArabic(
                                        height: 1.5,
                                        color: const Color(0xff454B5C),
                                        fontWeight: FontWeight.w600,
                                        fontSize: AddSize.font16),
                                  ),
                                  GestureDetector(
                                      behavior: HitTestBehavior.translucent,
                                      onTap: () {
                                        Get.to(()=>OderListScreen(back: 'Back'));
                                      },
                                      child: Text(
                                        "See All".tr,
                                        style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                                            decoration: TextDecoration.underline,
                                            height: 1.5,
                                            fontWeight: FontWeight.w500,
                                            color: AppTheme.primaryColor,
                                            fontSize: AddSize.font16),
                                      ))
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Order No.".tr,
                                    style: GoogleFonts.ibmPlexSansArabic(
                                        height: 1.5,
                                        color: const Color(0xff65CD90),
                                        fontWeight: FontWeight.w600,
                                        fontSize: AddSize.font16),
                                  ),
                                  const SizedBox(width: 20),
                                  Text(
                                    "Status".tr,
                                    style: GoogleFonts.ibmPlexSansArabic(
                                        height: 1.5,
                                        color: const Color(0xff65CD90),
                                        fontWeight: FontWeight.w600,
                                        fontSize: AddSize.font16),
                                  ),
                                  Text(
                                    "Earning".tr,
                                    style: GoogleFonts.ibmPlexSansArabic(
                                        height: 1.5,
                                        color: const Color(0xff65CD90),
                                        fontWeight: FontWeight.w600,
                                        fontSize: AddSize.font16),
                                  ),
                                ],
                              ),
                              const Divider(),
                              ListView.builder(
                                // physics: const AlwaysScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: 3,
                                itemBuilder: (BuildContext context, int index) {
                                  return InkWell(
                                    onTap: () {
                                      // Get.toNamed(VendorOrderList
                                      //     .vendorOrderList);
                                    },
                                    child: Column(
                                      children: [
                                        SizedBox(
                                          height: AddSize.size5,
                                        ),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "#123",
                                                  style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                                                      height: 1.5, fontWeight: FontWeight.w500, fontSize: AddSize.font14),
                                                ),
                                                Text(
                                                  "2 June, 2021 - 11:57PM",
                                                  style: GoogleFonts.ibmPlexSansArabic(
                                                      fontSize: AddSize.font12,
                                                      color: const Color(0xff8C9BB2),
                                                      fontWeight: FontWeight.w500),
                                                ),
                                              ],
                                            ),
                                            Flexible(child: Container()),
                                            Text(
                                              "Pending",
                                              style: GoogleFonts.ibmPlexSansArabic(
                                                  height: 1.5,
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: AddSize.font14,
                                                  color: const Color(0xffFF557E)),
                                            ),
                                            Flexible(child: Container()),
                                            Text(
                                              "\$100",
                                              style: GoogleFonts.ibmPlexSansArabic(
                                                  height: 1.5,
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: AddSize.font16,
                                                  color: AppTheme.blackcolor),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: AddSize.size5,
                                        ),
                                        const Divider(),
                                      ],
                                    ),
                                  );
                                },
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ).appPaddingForScreen,
          ),
        ));
  }
}
