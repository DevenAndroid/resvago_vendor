import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../widget/apptheme.dart';

class AppBarScreen extends StatefulWidget implements PreferredSizeWidget {
  const AppBarScreen({super.key});

  @override
  State<AppBarScreen> createState() => _AppBarScreenState();

  @override
  Size get preferredSize => const Size(double.maxFinite, 100);
}

class _AppBarScreenState extends State<AppBarScreen> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: GestureDetector(
                onTap: () {
                  Get.back();
                },
                child: Image.asset(
                  'assets/icons/backicon.png',
                  height: 25,
                ),
              ),
            ),
          ],
        ),
      ),
      toolbarHeight: 100,
      backgroundColor: Colors.transparent,
      elevation: 0,
      titleSpacing: 0,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // const SizedBox(height: 10,),
          Text(
            "Hi, Demo".tr,
            style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 20, color: const Color(0xff292F45)),
          ),
          const SizedBox(
            height: 10,
          ),
          GestureDetector(
            onTap: () {
              // Get.toNamed(SetTimeScreen.route);
            },
            child: Row(
              children: [
                Expanded(
                  child: Obx(() {
                    return Text(
                      "Restaurant Time:  10am to 9pm",
                      style: GoogleFonts.poppins(fontWeight: FontWeight.w400, fontSize: 16, color: AppTheme.greycolor),
                    );
                  }),
                ),
                const Icon(
                  Icons.edit,
                  color: AppTheme.greycolor,
                  size: 15,
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 4,
          ),
          Text("Status")
        ],
      ),
      actions: [
        GestureDetector(
            onTap: () {
              // Get.toNamed(VendorProfileScreen.route);
            },
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 16.0, top: 8),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(1000),
                    child: Container(
                        height: 45,
                        width: 45,
                        clipBehavior: Clip.antiAlias,
                        // margin: EdgeInsets.all(1),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          // color: Colors.brown
                        ),
                        child: Image.network(
                          "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAIsAAACLCAMAAABmx5rNAAAAk1BMVEX///8AESEAAACqrrL8/Pz///0AABIAAAsAABb+/f8AEiD3+PgACBwAABQAABgDEyTCxMYkJy8NEBnm5+nf4OBERksAAAXv8PFJTFAAABvIy800N0AqLDFVWWGcoKK6vL8sLzlOUlnU1tiPkpV0eHtdY2aFiIppa281ODxgZGwbICkADRcUGiYRGCASFSQAChlBRFDZEkPCAAADqElEQVR4nO2a23aqMBCGQyCEkwoCxkMLFizWnt//6XbQrVUrhNYw7rX2fFcsb/ydmX+YTCQEQRAEQRAEQRAEQRAE+QZj359uhRUXuWmaYRIz4t5UiZ+tlxNaw59W5q1UWBYjxZpSJzB2BA6lVUxukSvGRDa2Dc8z9oyMDx6ZPrGgpbgkTmkgv/+I0cgI6EbAlg2zXDIfD4xL8KdEJhAwTRYp7oYXpRgjexoT0NCIsTO6rMUwJgsCWb3+o92kREIrQCnEpI1RqdM0mcNJEc9BixTDc1IoJS7JqOG1iTF4TlyINsOIv2jw0CEwfA3jJNn6absU2QG5YBBiXFKqtEgr5UC+fnSUWiYVjBaRKspF4mwglBASP7U6estsKkC0JJFaS5D+f1riZYccAWkRqVqLcw8z3Vn3ak/zFVB/qTr0OhNIy7yDlgRGCvNVxevJcoHRYpFyogqLnBmARt5k3C5ltoBx9BbFm1qGBQ4xbbP1ZO1DHgQKGnhN4/fgBTBDdV2GdoOXPCcq5MESVIw5uZymwetczt3Aq4b5m3T20Zph90zr4zQwMjLxip+HZvBSCbDOcoDV5598QY/KZmjTh3m9JAKWsqdYLeoF2XZNllbw6TlFJHlWVWWWJ/6NlZzkA9o9W+paEaE4+37ZVA6fQ5avn015avrkeKfr1kdtM+XTzAdcBvlZRIfGjL6Wp4uWefVKhyOHRhlE7VgWYyRc8J2TA27f3Wd5kSRJkWf3d/bh80VIGOvZ3S4jVmUfWpxnBDalzvv7u0Nlq/l6Ww7syu37peSSYnm8H/OM0d+10NfTDros+tw61z/UfB40zQpnnztRPWj2VsQWMan6nLYnqA8mfZl7uwVqW2CexSmgZT9CrC47w1MtMjIZIT1UjWywpvqMdk4/50eLhB/da2UfmuAj1B2XumuJlx9LkWkavgmiN01Si/9w+Y5Ghf3gax6vOi1SL4dGt5mYPLb+PEM7LcE40XoDycim7ZKmHXuj10sdVi7NUK1XOP50doWW4VTnOJPzK6Rsr3A0IR35+ftqqbE/9dlaeUmjghaaypeR8roUySSVuqwkOizd2wkioUnLVYbeoc3WHXbLSi2arqytDvt/FUGqx0dd7miUWiI9O4j8uuayw9bT7kr+gyG3AY/rmRxW13aXGr7SoqX1Px1dsR+1aKm0xEWPqedcfR+tYsg1NbswpdeShnqkMCK2fy38PXkhdL0bNSxSbrJWRBAEQRAEQRAEQRAE+Rf4A9JzM5mdCizPAAAAAElFTkSuQmCC",
                          errorBuilder: (_, __, ___) => Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(1000), border: Border.all(color: Colors.grey)),
                              child: Icon(
                                Icons.person_2_rounded,
                                color: Colors.grey.shade500,
                              )),
                        )),
                  ),
                ),
              ],
            ))
      ],
    );
  }
}
