import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:resvago_vendor/helper.dart';
import 'package:resvago_vendor/widget/appassets.dart';
import 'package:resvago_vendor/widget/custom_textfield.dart';
import 'package:url_launcher/url_launcher.dart';
import '../Firebase_service/notification_api.dart';
import '../model/createslot_model.dart';
import '../model/order_details_modal.dart';
import '../widget/addsize.dart';
import '../widget/apptheme.dart';

class DeliveryOderDetailsScreen extends StatefulWidget {
  const DeliveryOderDetailsScreen({super.key, required this.model});
  final MyOrderModel model;

  @override
  State<DeliveryOderDetailsScreen> createState() => _DeliveryOderDetailsScreenState();
}

class _DeliveryOderDetailsScreenState extends State<DeliveryOderDetailsScreen> {
  MyOrderModel? get myOrderModel => widget.model;

  Color getStatusColor(String orderStatus) {
    switch (orderStatus) {
      case 'Order Accepted':
        return Colors.green;
      case 'Order Rejected':
        return Colors.red;
      case 'Place Order':
        return Colors.blue;
      case 'Order Completed':
        return Colors.blue;
      default:
        return Colors.blue;
    }
  }

  void launchPhoneCall(String phoneNumber) async {
    final url = 'tel:$phoneNumber';

    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  Future manageOrderForDining(
      {required String orderId,
      dynamic vendorId,
      dynamic fcm,
      dynamic address,
      dynamic date,
      required bool lunchSelected,
      dynamic slot,
      dynamic guest,
      dynamic offer,
      dynamic docId,
      dynamic total,
      dynamic couponDiscount,
      required Map<String, dynamic> restaurantInfo,
      required Map<String, dynamic> profileData,
      required List<dynamic> menuList,
      dynamic time}) async {
    try {
      final slotDocument = firestore.collection("vendor_slot").doc(vendorId.toString()).collection("slot").doc(date.toString());
      await firestore.runTransaction((transaction) {
        return transaction.get(slotDocument).then((transactionDoc) {
          log("transaction data.......        ${transactionDoc.data()}");
          CreateSlotData createSlotData = CreateSlotData.fromMap(transactionDoc.data() ?? {});
          createSlotData.morningSlots = createSlotData.morningSlots ?? {};
          createSlotData.eveningSlots = createSlotData.eveningSlots ?? {};
          log("transaction data.......        ${createSlotData.toMap()}");
          // log("transaction data.......        $slot");

          int? availableSeats =
              lunchSelected ? createSlotData.morningSlots![slot.toString()] : createSlotData.eveningSlots![slot.toString()];
          log("transaction data.......        ${slot}    ${guest}    $lunchSelected     $availableSeats   ");

          if (availableSeats != null) {
            if (availableSeats < int.parse("$guest")) {
              showToast("Some seats are booked\nPlease select seats again");
              throw Exception();
            } else {
              if (lunchSelected) {
                createSlotData.morningSlots![slot.toString()] = availableSeats - int.parse("$guest");
              } else {
                createSlotData.eveningSlots![slot.toString()] = availableSeats - int.parse("$guest");
              }
            }
          } else {
            showToast("Seats not available");
            throw Exception();
          }

          log("transaction data.......        ${createSlotData.toMap()}");
          // throw Exception();
          transaction.update(slotDocument, createSlotData.toMap());
        });
      }).then(
        (newPopulation) => print("Population increased to $newPopulation"),
        onError: (e) {
          throw Exception(e);
        },
      );
      await firestore.collection('dining_order').doc(docId).update({
        "order_status": "Order Rejected",
      });
      showToast("Order Placed Successfully");
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: backAppBar(title: "Orders Details", context: context),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    // crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SvgPicture.asset(
                        AppAssets.details,
                        height: 23,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Order ID: ${myOrderModel!.orderId.toString()}",
                            style: GoogleFonts.poppins(color: const Color(0xFF423E5E), fontWeight: FontWeight.w600, fontSize: 15),
                          ),
                          Text(
                            DateFormat.yMMMMd().format(
                                DateTime.parse(DateTime.fromMillisecondsSinceEpoch(myOrderModel!.time).toLocal().toString())),
                            style: GoogleFonts.poppins(color: const Color(0xFF303C5E), fontWeight: FontWeight.w400, fontSize: 11),
                          ),
                        ],
                      ),
                      const Spacer(),
                      FittedBox(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                          decoration: BoxDecoration(
                            color: const Color(0xFF65CD90),
                            borderRadius: BorderRadius.circular(9),
                          ),
                          child: Text(
                            myOrderModel!.orderStatus.toString(),
                            style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 11),
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
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Selected Items",
                            style: GoogleFonts.poppins(color: const Color(0xFF1A2E33), fontWeight: FontWeight.w600, fontSize: 16),
                          ),
                          const SizedBox(
                            height: 11,
                          ),
                          if (myOrderModel!.orderDetails!.menuList != null)
                            ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: myOrderModel!.orderDetails!.menuList!.length,
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  final item = myOrderModel!.orderDetails!.menuList![index];
                                  print("manish ${item.dishName}");
                                  return InkWell(
                                    onTap: () {},
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: Row(
                                                children: [
                                                  ClipRRect(
                                                    borderRadius: BorderRadius.circular(10),
                                                    child: Image.network(
                                                      item.image.toString(),
                                                      height: 60,
                                                      width: 60,
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    width: 15,
                                                  ),
                                                  Expanded(
                                                    child: Column(
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Text(
                                                          item.dishName,
                                                          style: GoogleFonts.poppins(
                                                              color: const Color(0xFF1A2E33),
                                                              fontWeight: FontWeight.w600,
                                                              fontSize: 15),
                                                        ),
                                                        const SizedBox(
                                                          height: 4,
                                                        ),
                                                        Text(
                                                          "Qty: ${item.qty}",
                                                          style: GoogleFonts.poppins(
                                                              fontSize: 12,
                                                              fontWeight: FontWeight.w300,
                                                              color: const Color(0xFF3B5998)),
                                                        ),
                                                        const SizedBox(
                                                          height: 4,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            Text(
                                              "\$${item.price}",
                                              style: GoogleFonts.poppins(
                                                  color: const Color(0xFF384953), fontWeight: FontWeight.w300, fontSize: 15),
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
                        ],
                      ))),
              Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Customer Details",
                            style: GoogleFonts.poppins(color: const Color(0xFF1A2E33), fontWeight: FontWeight.w500, fontSize: 16),
                          ),
                          const SizedBox(
                            height: 6,
                          ),
                          Divider(
                            thickness: 1,
                            color: Colors.grey.withOpacity(.3),
                          ),
                          const SizedBox(
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
                                          color: const Color(0xFF486769), fontWeight: FontWeight.w300, fontSize: 14),
                                    ),
                                    Text(
                                      myOrderModel!.customerData!.userName,
                                      style: GoogleFonts.poppins(
                                          color: const Color(0xFF21283D), fontWeight: FontWeight.w500, fontSize: 16),
                                    ),
                                  ],
                                ),
                                const Spacer(),
                                SvgPicture.asset(AppAssets.contact)
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Divider(
                            thickness: 1,
                            color: Colors.grey.withOpacity(.3),
                          ),
                          const SizedBox(
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
                                          color: const Color(0xFF486769), fontWeight: FontWeight.w300, fontSize: 14),
                                    ),
                                    Text(
                                      myOrderModel!.customerData!.mobileNumber,
                                      style: GoogleFonts.poppins(
                                          color: const Color(0xFF21283D), fontWeight: FontWeight.w500, fontSize: 16),
                                    ),
                                  ],
                                ),
                                const Spacer(),
                                GestureDetector(
                                  onTap: () {
                                    String phoneNumber = myOrderModel!.customerData!
                                        .mobileNumber; // Replace with the actual phone number retrieved from your API
                                    launchPhoneCall(phoneNumber);
                                  },
                                  child: Image.asset(
                                    AppAssets.call,
                                    height: 40,
                                  ),
                                )
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Divider(
                            thickness: 1,
                            color: Colors.grey.withOpacity(.3),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0, right: 8),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Customer Address",
                                        style: GoogleFonts.poppins(
                                            color: const Color(0xFF486769), fontWeight: FontWeight.w300, fontSize: 14),
                                      ),
                                      Text(
                                        myOrderModel!.address.toString(),
                                        style: GoogleFonts.poppins(
                                            color: const Color(0xFF21283D), fontWeight: FontWeight.w500, fontSize: 16),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
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
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Subtotal",
                                style: GoogleFonts.poppins(
                                    color: const Color(0xFF1E2538), fontWeight: FontWeight.w300, fontSize: 14),
                              ),
                              Text(
                                "\$${myOrderModel!.total.toString()}",
                                style: GoogleFonts.poppins(
                                    color: const Color(0xFF3A3A3A), fontWeight: FontWeight.w500, fontSize: 16),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 6,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Service Fees",
                                style: GoogleFonts.poppins(
                                    color: const Color(0xFF1E2538), fontWeight: FontWeight.w300, fontSize: 14),
                              ),
                              Text(
                                "\$0.00",
                                style: GoogleFonts.poppins(
                                    color: const Color(0xFF3A3A3A), fontWeight: FontWeight.w500, fontSize: 16),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 6,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Meat Pasta",
                                style: GoogleFonts.poppins(
                                    color: const Color(0xFF1E2538), fontWeight: FontWeight.w300, fontSize: 14),
                              ),
                              Text(
                                "\$0.00",
                                style: GoogleFonts.poppins(
                                    color: const Color(0xFF3A3A3A), fontWeight: FontWeight.w500, fontSize: 16),
                              ),
                            ],
                          ),
                          Divider(
                            thickness: 1,
                            color: Colors.grey.withOpacity(.3),
                          ),
                          const SizedBox(
                            height: 3,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Total",
                                style: GoogleFonts.poppins(
                                    color: const Color(0xFF3A3A3A), fontWeight: FontWeight.w500, fontSize: 16),
                              ),
                              Text(
                                "\$${myOrderModel!.total.toString()}",
                                style: GoogleFonts.poppins(
                                    color: const Color(0xFF3A3A3A), fontWeight: FontWeight.w500, fontSize: 16),
                              ),
                            ],
                          ),
                        ],
                      ))),
              const SizedBox(
                height: 20,
              ),
              if (myOrderModel!.orderStatus == "Order Completed")
                Padding(
                  padding: const EdgeInsets.only(right: 50, left: 50),
                  child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.maxFinite, 50),
                        primary: Colors.blue,
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      child: Text(
                        "Order Completed",
                        style: Theme.of(context)
                            .textTheme
                            .headline5!
                            .copyWith(color: AppTheme.backgroundcolor, fontWeight: FontWeight.w500, fontSize: AddSize.font18),
                      )),
                ),
              if (myOrderModel!.orderStatus == "Order Accepted")
                Padding(
                  padding: const EdgeInsets.only(right: 50, left: 50),
                  child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          myOrderModel!.orderStatus = 'Order Completed';
                        });
                        FirebaseFirestore.instance
                            .collection('order')
                            .doc(myOrderModel!.docid)
                            .update({'order_status': 'Order Completed'});
                        sendPushNotification(
                            body: myOrderModel!.orderDetails.toString(),
                            deviceToken: myOrderModel!.fcmToken,
                            image: "https://www.funfoodfrolic.com/wp-content/uploads/2021/08/Macaroni-Thumbnail-Blog.jpg",
                            title: "Your Order is Completed with Order ID ${myOrderModel!.orderId}",
                            orderID: myOrderModel!.orderId);

                        showToast("Order is Completed");
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.maxFinite, 50),
                        primary: const Color(0xFFFF6559),
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      child: Text(
                        "Delivery Order",
                        style: Theme.of(context)
                            .textTheme
                            .headline5!
                            .copyWith(color: AppTheme.backgroundcolor, fontWeight: FontWeight.w500, fontSize: AddSize.font18),
                      )),
                ),
              if (myOrderModel!.orderStatus == "Order Rejected")
                Padding(
                  padding: const EdgeInsets.only(right: 50, left: 50),
                  child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.maxFinite, 50),
                        primary: const Color(0xFFFF6559),
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      child: Text(
                        "Order Rejected",
                        style: Theme.of(context)
                            .textTheme
                            .headline5!
                            .copyWith(color: AppTheme.backgroundcolor, fontWeight: FontWeight.w500, fontSize: AddSize.font18),
                      )),
                ),
              if (myOrderModel!.orderStatus != "Order Accepted" &&
                  myOrderModel!.orderStatus != "Order Rejected" &&
                  myOrderModel!.orderStatus != "Order Completed")
                Padding(
                  padding: const EdgeInsets.only(left: 18.0, right: 18),
                  child: Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                myOrderModel!.orderStatus = 'Order Accepted';
                              });
                              FirebaseFirestore.instance
                                  .collection('order')
                                  .doc(myOrderModel!.docid)
                                  .update({'order_status': 'Order Accepted'});
                              sendPushNotification(
                                  body: myOrderModel!.orderDetails.toString(),
                                  deviceToken: myOrderModel!.fcmToken,
                                  image: "https://www.funfoodfrolic.com/wp-content/uploads/2021/08/Macaroni-Thumbnail-Blog.jpg",
                                  title: "Your Order is Accepted with Order ID ${myOrderModel!.orderId}",
                                  orderID: myOrderModel!.orderId);

                              showToast("Order is Accepted");
                            },
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size(double.maxFinite, 50),
                              primary: Colors.green,
                              elevation: 0,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            ),
                            child: Text(
                              "Accept Order",
                              style: Theme.of(context).textTheme.headline5!.copyWith(
                                  color: AppTheme.backgroundcolor, fontWeight: FontWeight.w500, fontSize: AddSize.font18),
                            )),
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      Expanded(
                          child: ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  myOrderModel!.orderStatus = 'Order Rejected';
                                });
                                FirebaseFirestore.instance
                                    .collection('order')
                                    .doc(myOrderModel!.docid)
                                    .update({'order_status': 'Order Rejected'});

                                sendPushNotification(
                                    body: myOrderModel!.orderDetails.toString(),
                                    deviceToken: myOrderModel!.fcmToken,
                                    image: "https://www.funfoodfrolic.com/wp-content/uploads/2021/08/Macaroni-Thumbnail-Blog.jpg",
                                    title: "Your Order is Rejected with Order ID ${myOrderModel!.orderId}",
                                    orderID: myOrderModel!.orderId);

                                showToast("Order is Rejected");
                              },
                              style: ElevatedButton.styleFrom(
                                minimumSize: const Size(double.maxFinite, 50),
                                primary: const Color(0xFFFF6559),
                                elevation: 0,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              ),
                              child: Text(
                                "Reject Order",
                                style: Theme.of(context).textTheme.headline5!.copyWith(
                                    color: AppTheme.backgroundcolor, fontWeight: FontWeight.w500, fontSize: AddSize.font18),
                              )))
                    ],
                  ),
                ),
              const SizedBox(
                height: 40,
              ),
            ],
          ),
        ));
  }
}
