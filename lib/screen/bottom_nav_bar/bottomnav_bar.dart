import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:resvago_vendor/screen/bottom_nav_bar/wallet_screen.dart';
import 'package:resvago_vendor/widget/appassets.dart';
import '../../Setting screen.dart';
import '../../controllers/bottomnavbar_controller.dart';
import '../../model/profile_model.dart';
import '../../widget/apptheme.dart';
import '../Menu/menu_screen.dart';
import '../Promo_code_list.dart';
import '../bank_details_screen.dart';
import '../login_screen.dart';
import '../reviwe_screen.dart';
import '../set_store_time/set_store_time.dart';
import '../slot_screens/add_booking_slot_screen.dart';
import '../dashboard/dashboard_screen.dart';
import '../slot_screens/slot_list.dart';
import '../total earning screen.dart';
import 'menu_list_screen.dart';
import 'oder_list_screen.dart';

class BottomNavbar extends StatefulWidget {
  const BottomNavbar({Key? key}) : super(key: key);

  @override
  State<BottomNavbar> createState() => _BottomNavbarState();
}

class _BottomNavbarState extends State<BottomNavbar> {
  final bottomController = Get.put(BottomNavBarController());
  int currentDrawer = 0;
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
  final pages = [
    const VendorDashboard(),
    MenuScreen(
      back: 'Back',
    ),
    OderListScreen(back: 'Back'),
    WalletScreen(back: 'Back'),
  ];

  @override
  void initState() {
    super.initState();
    restaurantData();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Obx(() {
      return Scaffold(
        key: bottomController.scaffoldKey,
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
                              imageUrl: profileData.image.toString(),
                              height: screenSize.height * 0.12,
                              width: screenSize.height * 0.12,
                              errorWidget: (_, __, ___) => const SizedBox(),
                              placeholder: (_, __) => const SizedBox(),
                              fit: BoxFit.cover,
                            ),
                          ),
                          Text(profileData.restaurantName ?? "",
                              style: GoogleFonts.poppins(
                                fontSize: 15,
                                color: const Color(0xFFFFFFFF),
                                fontWeight: FontWeight.w600,
                              )),
                          Expanded(
                            child: Text(profileData.email ?? "",
                                style: GoogleFonts.poppins(
                                  fontSize: 15,
                                  color: const Color(0xFFFFFFFF),
                                  fontWeight: FontWeight.w400,
                                )),
                          ),
                        ],
                      ),
                    )),
              ),
              ListTile(
                visualDensity: const VisualDensity(horizontal: -4, vertical: -2),
                leading: const Icon(Icons.dashboard),
                title: Text('Dashboard'.tr,
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
                title: Text('Menu'.tr,
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      color: const Color(0xFF4F535E),
                      fontWeight: FontWeight.w400,
                    )),
                onTap: () {
                  setState(() {
                    currentDrawer = 1;
                    Get.to(() => MenuScreen(
                      back: '',
                    ));
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
                title: Text('Promo Code List'.tr,
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
                leading: const Icon(Icons.line_style),
                title: Text('Slot List'.tr,
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
                leading: const Icon(Icons.monetization_on),
                title: Text('Total Earning'.tr,
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
              const Divider(
                height: 5,
                color: Color(0xffEFEFEF),
                thickness: 1,
              ),
              ListTile(
                visualDensity: const VisualDensity(horizontal: -4, vertical: -2),
                leading: const Icon(Icons.access_time),
                title: Text('Set Store Time'.tr,
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      color: const Color(0xFF4F535E),
                      fontWeight: FontWeight.w400,
                    )),
                onTap: () {
                  setState(() {
                    currentDrawer = 7;
                    Get.to(const SetTimeScreen());
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
                leading: const Icon(Icons.food_bank),
                title: Text('Bank Details'.tr,
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      color: const Color(0xFF4F535E),
                      fontWeight: FontWeight.w400,
                    )),
                onTap: () async {
                  Get.to(const BankDetailsScreen());
                },
              ),
              const Divider(
                height: 5,
                color: Color(0xffEFEFEF),
                thickness: 1,
              ),
              ListTile(
                visualDensity: const VisualDensity(horizontal: -4, vertical: -2),
                leading: const Icon(Icons.settings),
                title: Text('Setting'.tr,
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
                leading: const Icon(Icons.settings),
                title: Text('FeedBack'.tr,
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      color: const Color(0xFF4F535E),
                      fontWeight: FontWeight.w400,
                    )),
                onTap: () {
                  setState(() {
                    currentDrawer = 5;
                    Get.to(const ReviewScreen());
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
                leading: const Icon(Icons.logout),
                title: Text('Log Out'.tr,
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      color: const Color(0xFF4F535E),
                      fontWeight: FontWeight.w400,
                    )),
                onTap: () async {
                  await FirebaseAuth.instance.signOut();
                  Get.offAll(const LoginScreen());
                },
              ),
              const SizedBox(
                height: 100,
              ),
            ],
          ),
        ),
        body: pages.elementAt(bottomController.pageIndex.value),
        extendBody: true,
        // extendBodyBehindAppBar: true,
        backgroundColor: Colors.white,
        bottomNavigationBar: buildMyNavBar(context),
      );
    });
  }

  buildMyNavBar(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: double.maxFinite,
          decoration: const BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey,
                offset: Offset(0.0, 1.0), //(x,y)
                blurRadius: 6.0,
              ),
            ],
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(0),
              topRight: Radius.circular(0),
            ),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: MaterialButton(
                      padding: const EdgeInsets.only(bottom: 10),
                      onPressed: () {
                        bottomController.updateIndexValue(0);
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(
                            height: 8,
                          ),
                          bottomController.pageIndex.value == 0
                              ? SvgPicture.asset(
                                  AppAssets.home,
                                  color: AppTheme.primaryColor,
                                )
                              : SvgPicture.asset(AppAssets.home),
                          const SizedBox(
                            height: 6,
                          ),
                          bottomController.pageIndex.value == 0
                              ?  Text(
                                  " Dashboard".tr,
                                  style: const TextStyle(color: AppTheme.primaryColor, fontSize: 15, fontWeight: FontWeight.w400),
                                )
                              :  Text(
                                  " Dashboard".tr,
                                  style: const TextStyle(color: AppTheme.registortext, fontSize: 15, fontWeight: FontWeight.w400),
                                )
                        ],
                      ),
                    ),
                  ),
                  Flexible(
                    child: MaterialButton(
                      padding: const EdgeInsets.only(bottom: 10),
                      onPressed: () {
                        bottomController.updateIndexValue(1);
                      },
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 8,
                          ),
                          bottomController.pageIndex.value == 1
                              ? SvgPicture.asset(
                                  AppAssets.menu,
                                  color: AppTheme.primaryColor,
                                )
                              : SvgPicture.asset(
                                  AppAssets.menu,
                                  color: Colors.black,
                                ),
                          const SizedBox(
                            height: 5,
                          ),
                          bottomController.pageIndex.value == 1
                              ?  Text(
                                  "Menu".tr,
                                  style: const TextStyle(color: AppTheme.primaryColor, fontSize: 15, fontWeight: FontWeight.w400),
                                )
                              :  Text(
                                  "Menu".tr,
                                  style: const TextStyle(color: AppTheme.registortext, fontSize: 15, fontWeight: FontWeight.w400),
                                )
                        ],
                      ),
                    ),
                  ),
                  Flexible(
                    child: MaterialButton(
                      padding: const EdgeInsets.only(bottom: 10),
                      onPressed: () {
                        bottomController.updateIndexValue(2);
                      },
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 8,
                          ),
                          bottomController.pageIndex.value == 2
                              ? SvgPicture.asset(
                                  AppAssets.oders,
                                  color: AppTheme.primaryColor,
                                )
                              : SvgPicture.asset(AppAssets.oders),
                          const SizedBox(
                            height: 5,
                          ),
                          bottomController.pageIndex.value == 2
                              ?  Text(
                                  "Oders".tr,
                                  style: const TextStyle(color: AppTheme.primaryColor, fontSize: 15, fontWeight: FontWeight.w400),
                                )
                              :  Text(
                                  "Oders".tr,
                                  style: const TextStyle(color: AppTheme.registortext, fontSize: 15, fontWeight: FontWeight.w400),
                                )
                        ],
                      ),
                    ),
                  ),
                  Flexible(
                    child: MaterialButton(
                      padding: const EdgeInsets.only(bottom: 10),
                      onPressed: () {
                        bottomController.updateIndexValue(3);
                      },
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 8,
                          ),
                          bottomController.pageIndex.value == 3
                              ? SvgPicture.asset(
                                  AppAssets.wallet,
                                  color: AppTheme.primaryColor,
                                )
                              : SvgPicture.asset(AppAssets.wallet),
                          const SizedBox(
                            height: 5,
                          ),
                          bottomController.pageIndex.value == 3
                              ?  Text(
                                  "Wallet".tr,
                                  style: const TextStyle(color: AppTheme.primaryColor, fontSize: 15, fontWeight: FontWeight.w400),
                                )
                              :  Text(
                                  "Wallet".tr,
                                  style: const TextStyle(color: AppTheme.registortext, fontSize: 15, fontWeight: FontWeight.w400),
                                )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
