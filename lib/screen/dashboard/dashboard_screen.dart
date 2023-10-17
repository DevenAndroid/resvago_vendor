import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../Firebase_service/firebase_service.dart';
import '../../model/signup_model.dart';
import '../../widget/addsize.dart';
import '../../widget/appassets.dart';
import '../../widget/apptheme.dart';

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

  FirebaseService service = FirebaseService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xffF5F5F5),
        appBar: AppBar(
          toolbarHeight: 100,
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
                  Padding(
                    padding: const EdgeInsets.only(top: 18),
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
                            imageUrl:
                                "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAIsAAACLCAMAAABmx5rNAAAAk1BMVEX///8AESEAAACqrrL8/Pz///0AABIAAAsAABb+/f8AEiD3+PgACBwAABQAABgDEyTCxMYkJy8NEBnm5+nf4OBERksAAAXv8PFJTFAAABvIy800N0AqLDFVWWGcoKK6vL8sLzlOUlnU1tiPkpV0eHtdY2aFiIppa281ODxgZGwbICkADRcUGiYRGCASFSQAChlBRFDZEkPCAAADqElEQVR4nO2a23aqMBCGQyCEkwoCxkMLFizWnt//6XbQrVUrhNYw7rX2fFcsb/ydmX+YTCQEQRAEQRAEQRAEQRAE+QZj359uhRUXuWmaYRIz4t5UiZ+tlxNaw59W5q1UWBYjxZpSJzB2BA6lVUxukSvGRDa2Dc8z9oyMDx6ZPrGgpbgkTmkgv/+I0cgI6EbAlg2zXDIfD4xL8KdEJhAwTRYp7oYXpRgjexoT0NCIsTO6rMUwJgsCWb3+o92kREIrQCnEpI1RqdM0mcNJEc9BixTDc1IoJS7JqOG1iTF4TlyINsOIv2jw0CEwfA3jJNn6absU2QG5YBBiXFKqtEgr5UC+fnSUWiYVjBaRKspF4mwglBASP7U6estsKkC0JJFaS5D+f1riZYccAWkRqVqLcw8z3Vn3ak/zFVB/qTr0OhNIy7yDlgRGCvNVxevJcoHRYpFyogqLnBmARt5k3C5ltoBx9BbFm1qGBQ4xbbP1ZO1DHgQKGnhN4/fgBTBDdV2GdoOXPCcq5MESVIw5uZymwetczt3Aq4b5m3T20Zph90zr4zQwMjLxip+HZvBSCbDOcoDV5598QY/KZmjTh3m9JAKWsqdYLeoF2XZNllbw6TlFJHlWVWWWJ/6NlZzkA9o9W+paEaE4+37ZVA6fQ5avn015avrkeKfr1kdtM+XTzAdcBvlZRIfGjL6Wp4uWefVKhyOHRhlE7VgWYyRc8J2TA27f3Wd5kSRJkWf3d/bh80VIGOvZ3S4jVmUfWpxnBDalzvv7u0Nlq/l6Ww7syu37peSSYnm8H/OM0d+10NfTDros+tw61z/UfB40zQpnnztRPWj2VsQWMan6nLYnqA8mfZl7uwVqW2CexSmgZT9CrC47w1MtMjIZIT1UjWywpvqMdk4/50eLhB/da2UfmuAj1B2XumuJlx9LkWkavgmiN01Si/9w+Y5Ghf3gax6vOi1SL4dGt5mYPLb+PEM7LcE40XoDycim7ZKmHXuj10sdVi7NUK1XOP50doWW4VTnOJPzK6Rsr3A0IR35+ftqqbE/9dlaeUmjghaaypeR8roUySSVuqwkOizd2wkioUnLVYbeoc3WHXbLSi2arqytDvt/FUGqx0dd7miUWiI9O4j8uuayw9bT7kr+gyG3AY/rmRxW13aXGr7SoqX1Px1dsR+1aKm0xEWPqedcfR+tYsg1NbswpdeShnqkMCK2fy38PXkhdL0bNSxSbrJWRBAEQRAEQRAEQRAE+Rf4A9JzM5mdCizPAAAAAElFTkSuQmCC",
                            height: AddSize.size30,
                            width: AddSize.size30,
                            errorWidget: (_, __, ___) => const Icon(Icons.person),
                            placeholder: (_, __) => const SizedBox(),
                          )),
                    ),
                  ),
                  Positioned(
                      top: 30,
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
        body: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AddSize.padding16,
          ),
          child: CustomScrollView(
            // physics: const BouncingScrollPhysics(),
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
                      height: AddSize.size10,
                    ),
                  ],
                ),
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
                              // physics: const BouncingScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: 4,
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
        ));
  }
}
