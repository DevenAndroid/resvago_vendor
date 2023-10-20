import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:resvago_vendor/Setting%20screen.dart';
import 'package:resvago_vendor/routers/routers.dart';
import 'package:resvago_vendor/screen/create_promo_code_screen.dart';
import 'package:resvago_vendor/screen/slot_list.dart';
import 'package:resvago_vendor/screen/total%20earning%20screen.dart';
import 'package:resvago_vendor/screen/user_profile.dart';
import '../../Firebase_service/firebase_service.dart';
import '../../model/signup_model.dart';
import '../../widget/addsize.dart';
import '../../widget/appassets.dart';
import '../../widget/apptheme.dart';
import '../Promo_code_list.dart';

class VendorDashboard extends StatefulWidget {
  const VendorDashboard({Key? key}) : super(key: key);
  static var vendorDashboard = "/vendorDashboard";
  @override
  State<VendorDashboard> createState() => _VendorDashboardState();
}

class _VendorDashboardState extends State<VendorDashboard> {
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
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
        key: _scaffoldKey,
        backgroundColor: const Color(0xffF5F5F5),
        drawer: Drawer(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
          width: MediaQuery.sizeOf(context).width * .70,
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              SizedBox(
                height: 230,
                child: DrawerHeader(
                    decoration: const BoxDecoration(
                        gradient: LinearGradient(
                      colors: [
                        AppTheme.primaryColor,
                        AppTheme.primaryColor,
                      ],
                    )),
                    child: Align(
                      alignment: Alignment.center,
                      child: Column(
                        children: [
                          Container(
                            margin: const EdgeInsets.all(4),
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            decoration: const ShapeDecoration(
                              shape: CircleBorder(),
                              color: Colors.white,
                            ),
                            child: CachedNetworkImage(
                              imageUrl:
                                  "https://images.pexels.com/photos/220453/pexels-photo-220453.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500",
                              height: screenSize.height * 0.12,
                              width: screenSize.height * 0.12,
                              errorWidget: (_, __, ___) => const SizedBox(),
                              placeholder: (_, __) => const SizedBox(),
                              fit: BoxFit.cover,
                            ),
                          ),
                          Text("TestVendor",
                              style: GoogleFonts.poppins(
                                fontSize: 18,
                                color: const Color(0xFFFFFFFF),
                                fontWeight: FontWeight.w600,
                              )),
                          Text("TestVendor@gmail.com",
                              style: GoogleFonts.poppins(
                                fontSize: 15,
                                color: const Color(0xFFFFFFFF),
                                fontWeight: FontWeight.w400,
                              )),
                        ],
                      ),
                    )),
              ),
              ListTile(
                visualDensity: const VisualDensity(horizontal: -4, vertical: -2),
                leading: const Icon(Icons.dashboard),
                title: Text('Dashboard',
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      color: const Color(0xFF4F535E),
                      fontWeight: FontWeight.w400,
                    )),
                onTap: () {
                  setState(() {
                    currentDrawer = 0;
                    Get.back();
                  });
                },
              ),
              const Divider(
                height: 5,
                color: Color(0xffEFEFEF),
                thickness: 1,
              ),
              ListTile(
                visualDensity: const VisualDensity(horizontal: -4, vertical: -2),
                leading: const Icon(Icons.restaurant_menu_sharp),
                title: Text('Menu',
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      color: const Color(0xFF4F535E),
                      fontWeight: FontWeight.w400,
                    )),
                onTap: () {
                  setState(() {
                    currentDrawer = 1;
                    Get.toNamed(MyRouters.menuScreen);
                  });
                },
              ),
              const Divider(
                height: 5,
                color: Color(0xffEFEFEF),
                thickness: 1,
              ),
              ListTile(
                visualDensity: const VisualDensity(horizontal: -4, vertical: -2),
                leading: const Icon(Icons.countertops_outlined),
                title: Text('Create Coupon',
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      color: const Color(0xFF4F535E),
                      fontWeight: FontWeight.w400,
                    )),
                onTap: () {
                  setState(() {
                    currentDrawer = 1;
                    Get.to(const CreatePromoCodeScreen(isEditMode: false,));
                  });
                },
              ),
              const Divider(
                height: 5,
                color: Color(0xffEFEFEF),
                thickness: 1,
              ),
              ListTile(
                visualDensity: const VisualDensity(horizontal: -4, vertical: -2),
                leading: const Icon(Icons.countertops_outlined),
                title: Text('Coupon List',
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      color: const Color(0xFF4F535E),
                      fontWeight: FontWeight.w400,
                    )),
                onTap: () {
                  setState(() {
                    Get.to(const PromoCodeList());
                    currentDrawer = 2;
                    Get.to(const CreatePromoCodeScreen());
                  });
                },
              ),
              const Divider(
                height: 5,
                color: Color(0xffEFEFEF),
                thickness: 1,
              ),
              ListTile(
                visualDensity: const VisualDensity(horizontal: -4, vertical: -2),
                leading: const Icon(Icons.countertops_outlined),
                title: Text('Promo Code List',
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      color: const Color(0xFF4F535E),
                      fontWeight: FontWeight.w400,
                    )),
                onTap: () {
                  setState(() {
                    currentDrawer = 3;
                    Get.to(const PromoCodeList());
                  });
                },
              ),
              const Divider(
                height: 5,
                color: Color(0xffEFEFEF),
                thickness: 1,
              ),
              ListTile(
                visualDensity: const VisualDensity(horizontal: -4, vertical: -2),
                leading: const Icon(Icons.countertops_outlined),
                title: Text('Slot List',
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      color: const Color(0xFF4F535E),
                      fontWeight: FontWeight.w400,
                    )),
                onTap: () {
                  setState(() {
                    currentDrawer = 4;
                    Get.to(const SlotListScreen());
                  });
                },
              ),
              const Divider(
                height: 5,
                color: Color(0xffEFEFEF),
                thickness: 1,
              ),
              ListTile(
                visualDensity: const VisualDensity(horizontal: -4, vertical: -2),
                leading: const Icon(Icons.countertops_outlined),
                title: Text('Setting',
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      color: const Color(0xFF4F535E),
                      fontWeight: FontWeight.w400,
                    )),
                onTap: () {
                  setState(() {
                    currentDrawer = 5;
                    Get.to(const SettingScreen());
                  });
                },
              ),
              const Divider(
                height: 5,
                color: Color(0xffEFEFEF),
                thickness: 1,
              ),
              ListTile(
                visualDensity: const VisualDensity(horizontal: -4, vertical: -2),
                leading: const Icon(Icons.countertops_outlined),
                title: Text('Total Earning',
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      color: const Color(0xFF4F535E),
                      fontWeight: FontWeight.w400,
                    )),
                onTap: () {
                  setState(() {
                    currentDrawer = 6;
                    Get.to(const TotalEarningScreen());
                  });
                },
              ),
            ],
          ),
        ),
        appBar: AppBar(
          // toolbarHeight: 100,
          elevation: 0,
          leadingWidth: 45,
          backgroundColor: const Color(0xffF5F5F5),
          title: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Hi, Demo",
                style: GoogleFonts.ibmPlexSansArabic(
                    fontWeight: FontWeight.w500, fontSize: AddSize.font16, color: const Color(0xff292F45)),
              ),
              GestureDetector(
                onTap: () {
                  // Get.toNamed(SetTimeScreen.setTimeScreen);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Restaurant Time:",
                      style: GoogleFonts.ibmPlexSansArabic(
                          fontWeight: FontWeight.w500, fontSize: AddSize.font14, color: const Color(0xff737A8A)),
                    ),
                    Text(
                      "  25/12/2023",
                      style: GoogleFonts.ibmPlexSansArabic(
                          fontWeight: FontWeight.w400, fontSize: AddSize.font14, color: AppTheme.primaryColor),
                    ),
                    SizedBox(
                      width: AddSize.size5,
                    ),
                    InkWell(
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
          leading: Padding(
            padding: const EdgeInsets.only(left: 20),
            child: GestureDetector(
                onTap: () {
                  Get.back();
                },
                child: Image.asset(
                  AppAssets.back,
                  height: AddSize.size15,
                )),
          ),
          actions: [
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: AddSize.padding10,
              ),
              child: Stack(
                children: [
                  GestureDetector(
                    onTap: () {
                      Get.to(const UserProfileScreen());
                    },
                    child: CircleAvatar(
                      backgroundColor: Colors.transparent,
                      radius: 30,
                      child: Container(
                          height: AddSize.size45,
                          width: AddSize.size45,
                          clipBehavior: Clip.antiAlias,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50), border: Border.all(color: Colors.white)),
                          child: CachedNetworkImage(
                            fit: BoxFit.cover,
                            imageUrl:FirebaseAuth.instance.currentUser!.photoURL.toString(),
                               height: AddSize.size30,
                            width: AddSize.size30,
                            errorWidget: (_, __, ___) => const Icon(Icons.person),
                            placeholder: (_, __) => const SizedBox(),
                          )),
                    ),
                  ),
                  Positioned(
                      top: 10,
                      left: 06,
                      child: Container(
                        height: 12,
                        width: 12,
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(
                          color: AppTheme.userActive,
                          border: Border.all(color: AppTheme.backgroundcolor, width: 1),
                          borderRadius: BorderRadius.circular(50),
                          // color: Colors.brown
                        ),
                      ))
                ],
              ),
            )
          ],
        ),
        body: Theme(
          data: ThemeData(
            useMaterial3: true
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: AddSize.padding16,
            ),
            child: CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: <Widget>[
                const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [],
                    ),
                  ),
                ),
                SliverGrid.count(
                    crossAxisSpacing: AddSize.size12,
                    mainAxisSpacing: AddSize.size12,
                    crossAxisCount: 2,
                    childAspectRatio: AddSize.size10 / 7,
                    children: List.generate(
                      4,
                      (index) => Container(
                        padding: EdgeInsets.symmetric(horizontal: AddSize.padding16, vertical: AddSize.padding16),
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
                                  height: 1.5,
                                  fontWeight: FontWeight.w500,
                                  fontSize: AddSize.font20,
                                  color: AppTheme.blackcolor),
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
                                      fontSize: AddSize.font14,
                                      color: const Color(0xff8C9BB2)),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 15),
                                  child: Text(
                                    "10%",
                                    //"10%",
                                    style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                                        height: 1.5,
                                        fontWeight: FontWeight.w600,
                                        fontSize: AddSize.font14,
                                        color: Colors.green),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    )),
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
                                  TextButton(
                                      onPressed: () {
                                        // Get.toNamed(VendorOrderList
                                        //     .vendorOrderList);
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
            ),
          ),
        ));
  }
}
