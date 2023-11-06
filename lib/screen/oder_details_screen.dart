import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:resvago_vendor/widget/appassets.dart';
import 'package:resvago_vendor/widget/custom_textfield.dart';

import '../Firebase_service/notification_api.dart';
import '../model/order_details_modal.dart';

class OderDetailsScreen extends StatefulWidget {
  const OderDetailsScreen({super.key, required this.myOrderModel});
  final MyOrderModel myOrderModel;

  @override
  State<OderDetailsScreen> createState() => _OderDetailsScreenState();
}

class _OderDetailsScreenState extends State<OderDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    widget.myOrderModel.fcmToken;
    return Scaffold(
      appBar: backAppBar(title: "Orders Details", context: context),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                padding: EdgeInsets.all(14),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SvgPicture.asset(
                      AppAssets.details,
                      height: 23,
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
// mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "Order ID: 8520255",
                          style: GoogleFonts.poppins(
                              color: const Color(0xFF423E5E),
                              fontWeight: FontWeight.w600,
                              fontSize: 15),
                        ),
                        Text(
                          "Monday, 2 June, 2021",
                          style: GoogleFonts.poppins(
                              color: const Color(0xFF303C5E),
                              fontWeight: FontWeight.w400,
                              fontSize: 11),
                        ),
                      ],
                    ),
                    Spacer(),
                    GestureDetector(
                      onTap: (){
                        sendPushNotification(body: "newfwn",
                        deviceToken: widget.myOrderModel.fcmToken,
                        image: "",
                        title: "Manish");
                      },
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 7),
                        decoration: BoxDecoration(
                          color: Color(0xFF65CD90),
                          borderRadius: BorderRadius.circular(9),
                        ),
                        child: Text(
                          "Completed",
                          style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                              fontSize: 11),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                    padding: EdgeInsets.all(14),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.asset(AppAssets.pasta),
                        SizedBox(
                          width: 15,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "jack Smith",
                              style: GoogleFonts.poppins(
                                  color: const Color(0xFF1A2E33),
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Date",
                                      style: GoogleFonts.poppins(
                                          color: const Color(0xFF384953),
                                          fontWeight: FontWeight.w300,
                                          fontSize: 15),
                                    ),
                                    Text(
                                      "24 Oct 23",
                                      style: GoogleFonts.poppins(
                                          color: const Color(0xFF384953),
                                          fontWeight: FontWeight.w500,
                                          fontSize: 13),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  width: 15,
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Time",
                                      style: GoogleFonts.poppins(
                                          color: const Color(0xFF384953),
                                          fontWeight: FontWeight.w300,
                                          fontSize: 15),
                                    ),
                                    Text(
                                      "6:30PM",
                                      style: GoogleFonts.poppins(
                                          color: const Color(0xFF384953),
                                          fontWeight: FontWeight.w500,
                                          fontSize: 13),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  width: 15,
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Guest",
                                      style: GoogleFonts.poppins(
                                          color: const Color(0xFF384953),
                                          fontWeight: FontWeight.w300,
                                          fontSize: 15),
                                    ),
                                    Text(
                                      "12",
                                      style: GoogleFonts.poppins(
                                          color: const Color(0xFF384953),
                                          fontWeight: FontWeight.w500,
                                          fontSize: 13),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  width: 15,
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Offer",
                                      style: GoogleFonts.poppins(
                                          color: const Color(0xFF384953),
                                          fontWeight: FontWeight.w300,
                                          fontSize: 15),
                                    ),
                                    Text(
                                      "-20%",
                                      style: GoogleFonts.poppins(
                                          color: const Color(0xFF384953),
                                          fontWeight: FontWeight.w500,
                                          fontSize: 13),
                                    ),
                                  ],
                                ),
                              ],
                            )
                          ],
                        )
                      ],
                    ))),
            Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                    padding: EdgeInsets.all(14),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10)),
                    child: Row(
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Selected Items",
                              style: GoogleFonts.poppins(
                                  color: const Color(0xFF1A2E33),
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16),
                            ),
                            SizedBox(
                              height: 11,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Image.asset(AppAssets.pasta),
                                SizedBox(
                                  width: 15,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Salad veggie",
                                        style: GoogleFonts.poppins(
                                            color: const Color(0xFF1A2E33),
                                            fontWeight: FontWeight.w600,
                                            fontSize: 15),
                                      ),
                                      SizedBox(
                                        height: 6,
                                      ),
                                      Text(
                                        "\$10.00",
                                        style: GoogleFonts.poppins(
                                            color: const Color(0xFF384953),
                                            fontWeight: FontWeight.w300,
                                            fontSize: 15),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Image.asset(AppAssets.pasta),
                                SizedBox(
                                  width: 15,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Salad veggie",
                                        style: GoogleFonts.poppins(
                                            color: const Color(0xFF1A2E33),
                                            fontWeight: FontWeight.w600,
                                            fontSize: 15),
                                      ),
                                      SizedBox(
                                        height: 6,
                                      ),
                                      Text(
                                        "\$10.00",
                                        style: GoogleFonts.poppins(
                                            color: const Color(0xFF384953),
                                            fontWeight: FontWeight.w300,
                                            fontSize: 15),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                        Spacer(),
                        Padding(
                          padding: const EdgeInsets.only(top: 98.0),
                          child: Image.asset(AppAssets.qr),
                        )
                      ],
                    ))),
            Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                    padding: EdgeInsets.all(14),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Customer Details",
                          style: GoogleFonts.poppins(
                              color: const Color(0xFF1A2E33),
                              fontWeight: FontWeight.w500,
                              fontSize: 16),
                        ),
                        SizedBox(
                          height: 6,
                        ),
                        Divider(
                          thickness: 1,
                          color: Colors.grey.withOpacity(.3),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0, right: 8),
                          child: Row(
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Customer Name",
                                    style: GoogleFonts.poppins(
                                        color: const Color(0xFF486769),
                                        fontWeight: FontWeight.w300,
                                        fontSize: 14),
                                  ),
                                  Text(
                                    "McDonald’s",
                                    style: GoogleFonts.poppins(
                                        color: const Color(0xFF21283D),
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16),
                                  ),
                                ],
                              ),
                              Spacer(),
                              SvgPicture.asset(AppAssets.contact)
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Divider(
                          thickness: 1,
                          color: Colors.grey.withOpacity(.3),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0, right: 8),
                          child: Row(
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Customer Number",
                                    style: GoogleFonts.poppins(
                                        color: const Color(0xFF486769),
                                        fontWeight: FontWeight.w300,
                                        fontSize: 14),
                                  ),
                                  Text(
                                    "+91 9876454321",
                                    style: GoogleFonts.poppins(
                                        color: const Color(0xFF21283D),
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16),
                                  ),
                                ],
                              ),
                              Spacer(),
                              Image.asset(
                                AppAssets.call,
                                height: 40,
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Divider(
                          thickness: 1,
                          color: Colors.grey.withOpacity(.3),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0, right: 8),
                          child: Row(
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Customer Address",
                                    style: GoogleFonts.poppins(
                                        color: const Color(0xFF486769),
                                        fontWeight: FontWeight.w300,
                                        fontSize: 14),
                                  ),
                                  Text(
                                    "Douglas, Cork, T16 XN73, uk",
                                    style: GoogleFonts.poppins(
                                        color: const Color(0xFF21283D),
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16),
                                  ),
                                ],
                              ),
                              Spacer(),
                              Image.asset(
                                AppAssets.location,
                                height: 40,
                              )
                            ],
                          ),
                        ),
                      ],
                    ))),
            Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                    padding: EdgeInsets.all(14),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10)),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Subtotal",
                              style: GoogleFonts.poppins(
                                  color: const Color(0xFF1E2538),
                                  fontWeight: FontWeight.w300,
                                  fontSize: 14),
                            ),
                            Text(
                              "\$12.99",
                              style: GoogleFonts.poppins(
                                  color: const Color(0xFF3A3A3A),
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 6,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Service Fees",
                              style: GoogleFonts.poppins(
                                  color: const Color(0xFF1E2538),
                                  fontWeight: FontWeight.w300,
                                  fontSize: 14),
                            ),
                            Text(
                              "\$5.00",
                              style: GoogleFonts.poppins(
                                  color: const Color(0xFF3A3A3A),
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 6,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Meat Pasta",
                              style: GoogleFonts.poppins(
                                  color: const Color(0xFF1E2538),
                                  fontWeight: FontWeight.w300,
                                  fontSize: 14),
                            ),
                            Text(
                              "\$3.00",
                              style: GoogleFonts.poppins(
                                  color: const Color(0xFF3A3A3A),
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16),
                            ),
                          ],
                        ),
                        Divider(
                          thickness: 1,
                          color: Colors.grey.withOpacity(.3),
                        ),
                        SizedBox(
                          height: 3,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Total",
                              style: GoogleFonts.poppins(
                                  color: const Color(0xFF3A3A3A),
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16),
                            ),
                            Text(
                              "\$26.00",
                              style: GoogleFonts.poppins(
                                  color: const Color(0xFF3A3A3A),
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16),
                            ),
                          ],
                        ),
                      ],
                    ))),
            SizedBox(
              height: 20,
            )
          ],
        ),
      ),
    );
  }

}
