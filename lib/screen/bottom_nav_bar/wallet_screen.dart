import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:resvago_vendor/utils/helper.dart';
import 'package:resvago_vendor/widget/appassets.dart';
import 'package:resvago_vendor/widget/common_text_field.dart';
import 'package:resvago_vendor/widget/custom_textfield.dart';

import '../../routers/routers.dart';
import '../../widget/addsize.dart';
import '../../widget/apptheme.dart';

class WalletScreen extends StatefulWidget {
  String back;
  WalletScreen({super.key, required this.back});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  final List<String> moneyList = ["500", "800", "1000"];
  final TextEditingController addMoneyController = TextEditingController();
  // List<dynamic> diningOrderValues = [];
  // List<dynamic> deliveryOrderValues = [];

  // Future<List<String>> getDiningOrderValues() async {
  //   try {
  //     QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection("dining_order").get();
  //
  //     for (var doc in querySnapshot.docs) {
  //       if (doc.exists) {
  //         String fieldValue = doc.get("total");
  //         print("hhhhhhhh${diningOrderValues}");
  //         diningOrderValues.add(fieldValue);
  //       }
  //     }
  //
  //     return diningOrderValues;
  //   } catch (e) {
  //     print('Error: $e');
  //     return [];
  //   }
  // }
  //
  // Future<List<int>> getDeliveryOrderValues() async {
  //   try {
  //     QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection("order").get();
  //
  //     for (var doc in querySnapshot.docs) {
  //       if (doc.exists) {
  //         int fieldValue = doc.get("total");
  //         print("hhhhhhhh${deliveryOrderValues}");
  //         deliveryOrderValues.add(fieldValue);
  //       }
  //     }
  //
  //     return deliveryOrderValues;
  //   } catch (e) {
  //
  //
  //
  //
  //     print('Error: $e');
  //     return [];
  //   }
  // }

  double total = 0;
  double total1 = 0;
  double combinedTotal = 0; // Variable to store the sum

  @override
  void initState() {
    super.initState();
    fetchTotalEarnings();
    // FirebaseFirestore.instance.collection("dining_order").get().then((value) {
    //   total = 0;
    //   for (var element in value.docs) {
    //     total += double.tryParse(element.get("total").toString()) ?? 0;
    //   }
    //   updateCombinedTotal();
    // });
    //
    // FirebaseFirestore.instance.collection("order").get().then((value) {
    //   total1 = 0;
    //   for (var element in value.docs) {
    //     total1 += double.tryParse(element.get("total").toString()) ?? 0;
    //   }
    //   updateCombinedTotal();
    // });
  }

  void updateCombinedTotal() {
    if (total != 0 && total1 != 0) {
      combinedTotal = total + total1;
      setState(() {});
      print('Combined Total: $combinedTotal');
    }
  }



  double totalEarnings = 0;

  Future<double> calculateTotalEarnings() async {
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore.instance
        .collection('dining_order')
        .where("vendorId", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .where("order_status", isEqualTo: "Order Completed")
        .get();
    for (QueryDocumentSnapshot<Map<String, dynamic>> documentSnapshot in querySnapshot.docs) {
      double orderAmount = double.parse(documentSnapshot.data()["total"]);
      totalEarnings += orderAmount;
    }

    return totalEarnings;
  }

  Future<void> fetchTotalEarnings() async {
    double earnings = await calculateTotalEarnings();
    setState(() {
      totalEarnings = earnings;
      log("dgdfhdfh$totalEarnings");
    });
  }
  @override
  Widget build(BuildContext context) {
    print(total);
    return Scaffold(
      appBar: backAppBar(title: "Withdrawal Money".tr, context: context, dispose: widget.back),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                    padding: EdgeInsets.all(14),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
                    child: Row(
                      children: [
                        Column(
                          children: [
                            Text(
                              "My Balance".tr,
                              style: GoogleFonts.poppins(
                                  color: const Color(0xFF3A3A3A), fontWeight: FontWeight.w400, fontSize: 16),
                            ),
                            Text(
                              "\$${totalEarnings.toString()}",
                              style: GoogleFonts.poppins(
                                  color: const Color(0xFF3A3A3A), fontWeight: FontWeight.w600, fontSize: 31),
                            ),
                          ],
                        ),
                        Spacer(),
                        Image.asset(
                          AppAssets.withdrawl,
                          height: 40,
                        )
                      ],
                    ))),
            Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                    padding: EdgeInsets.all(14),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
                    child: Column(
                      children: [
                        TextFormField(
                            keyboardType: TextInputType.number,
                            textAlign: TextAlign.center,
                            style: Theme.of(context)
                                .textTheme
                                .headline5!
                                .copyWith(color: AppTheme.blackcolor, fontWeight: FontWeight.w600, fontSize: AddSize.font24),
                            controller: addMoneyController,
                            cursorColor: AppTheme.primaryColor,
                            // validator: validateMoney,
                            decoration: const InputDecoration(
                              hintText: "+\$100",
                              hintStyle:
                                  TextStyle(color: const Color(0xFF3A3A3A), fontWeight: FontWeight.w600, fontSize: 31),
                            )),
                        SizedBox(
                          height: AddSize.size15,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: List.generate(
                            moneyList.length,
                            (index) => chipList(moneyList[index]),
                          ),
                        ),
                        SizedBox(
                          height: 25,
                        ),
                        CommonButtonBlue(
                          title: "Withdrawal".tr,
                          onPressed: () {
                            Get.toNamed(MyRouters.bankDetailsScreen);
                          },
                        )
                      ],
                    ))),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                padding: EdgeInsets.all(14),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Amount".tr,
                          style:
                              GoogleFonts.poppins(color: const Color(0xFF3B5998), fontWeight: FontWeight.w600, fontSize: 12),
                        ),
                        // const SizedBox(width: 0,),
                        Text(
                          "Date".tr,
                          style:
                              GoogleFonts.poppins(color: const Color(0xFF3B5998), fontWeight: FontWeight.w600, fontSize: 12),
                        ),
                        Text(
                          "Status".tr,
                          style:
                              GoogleFonts.poppins(color: const Color(0xFF3B5998), fontWeight: FontWeight.w600, fontSize: 12),
                        ),
                      ],
                    ),
                    Divider(
                      thickness: 1,
                      color: Colors.black12.withOpacity(0.09),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: 6,
                        itemBuilder: (context, index) {
                          return Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "#1234",
                                    style: GoogleFonts.poppins(
                                        color: const Color(0xFF454B5C), fontWeight: FontWeight.w600, fontSize: 14),
                                  ),
                                  Text(
                                    "2 June, 2021 - 11:57PM",
                                    style: GoogleFonts.poppins(
                                        color: const Color(0xFF8C9BB2), fontWeight: FontWeight.w500, fontSize: 11),
                                  ),
                                  Text(
                                    "Processing",
                                    style: GoogleFonts.poppins(
                                        color: const Color(0xFFFFB26B), fontWeight: FontWeight.w600, fontSize: 12),
                                  ),
                                ],
                              ),
                              Divider(
                                thickness: 1,
                                color: Colors.black12.withOpacity(0.09),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                            ],
                          );
                        })
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 50,
            ),
          ],
        ).appPaddingForScreen,
      ),
    );
  }

  chipList(title) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return ChoiceChip(
      padding: EdgeInsets.symmetric(horizontal: width * .005, vertical: height * .005),
      backgroundColor: AppTheme.backgroundcolor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30), side: BorderSide(color: Colors.grey.shade300)),
      label: Text("+\$${title}", style: TextStyle(color: Colors.grey.shade600, fontSize: 14, fontWeight: FontWeight.w500)),
      selected: false,
      onSelected: (value) {
        setState(() {
          addMoneyController.text = title;
          FocusManager.instance.primaryFocus!.unfocus();
        });
      },
    );
  }
}
