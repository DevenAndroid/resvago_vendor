import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:resvago_vendor/screen/bottom_nav_bar/wallet_screen.dart';
import 'package:resvago_vendor/widget/app_strings_file.dart';
import 'package:resvago_vendor/widget/appassets.dart';
import '../../controllers/bottomnavbar_controller.dart';
import '../../widget/apptheme.dart';
import '../Menu/menu_screen.dart';
import '../slot_screens/add_booking_slot_screen.dart';
import '../dashboard/dashboard_screen.dart';
import 'menu_list_screen.dart';
import 'oder_list_screen.dart';

class BottomNavbar extends StatefulWidget {
  const BottomNavbar({Key? key}) : super(key: key);

  @override
  State<BottomNavbar> createState() => _BottomNavbarState();
}

class _BottomNavbarState extends State<BottomNavbar> {
  final bottomController = Get.put(BottomNavBarController());

  final pages = [
    const VendorDashboard(),
    MenuScreen(
      back: 'Back',
    ),
    OderListScreen(back: 'Back'),
    WalletScreen(back: 'Back'),
  ];

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Scaffold(
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
                          SizedBox(
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
                                  AppStrings.dashBoard.tr,
                                  style: TextStyle(color: AppTheme.primaryColor, fontSize: 15, fontWeight: FontWeight.w400),
                                )
                              :  Text(
                                 AppStrings.dashBoard.tr,
                                  style: TextStyle(color: AppTheme.registortext, fontSize: 15, fontWeight: FontWeight.w400),
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
                            AppStrings.menu.tr,
                                  style: TextStyle(color: AppTheme.primaryColor, fontSize: 15, fontWeight: FontWeight.w400),
                                )
                              :  Text(
                            AppStrings.menu.tr,
                                  style: TextStyle(color: AppTheme.registortext, fontSize: 15, fontWeight: FontWeight.w400),
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
                            AppStrings.orders.tr,
                                  style: TextStyle(color: AppTheme.primaryColor, fontSize: 15, fontWeight: FontWeight.w400),
                                )
                              :  Text(
                            AppStrings.orders.tr,
                                  style: TextStyle(color: AppTheme.registortext, fontSize: 15, fontWeight: FontWeight.w400),
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
                            AppStrings.wallet.tr,
                                  style: TextStyle(color: AppTheme.primaryColor, fontSize: 15, fontWeight: FontWeight.w400),
                                )
                              :  Text(
                            AppStrings.wallet.tr,
                                  style: TextStyle(color: AppTheme.registortext, fontSize: 15, fontWeight: FontWeight.w400),
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
