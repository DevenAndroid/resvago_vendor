import 'dart:convert';
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:resvago_vendor/model/withdraw_model.dart';
import 'package:resvago_vendor/utils/helper.dart';
import 'package:resvago_vendor/widget/appassets.dart';
import 'package:resvago_vendor/widget/common_text_field.dart';
import 'package:resvago_vendor/widget/custom_textfield.dart';
import '../../Firebase_service/firebase_service.dart';
import '../../helper.dart';
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
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  double total = 0;
  double total1 = 0;
  double combinedTotal = 0; // Variable to store the sum

  @override
  void initState() {
    super.initState();
    totalWalletEarnings();
    fetchTotalEarnings();
    getWithDrawData();
  }

  double totalEarnings1 = 0;
  double totalEarnings2 = 0;
  double totalEarnings3 = 0;
  double totalEarnings4 = 0;
  double totalEarnings = 0;
  double totalWalletAmount = 0;

  Future<double> calculateTotalEarnings() async {
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore.instance
        .collection('dining_order')
        .where("vendorId", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .where("order_status", isEqualTo: "Order Completed")
        .get();
    for (QueryDocumentSnapshot<Map<String, dynamic>> documentSnapshot in querySnapshot.docs) {
      double orderAmount = double.parse(documentSnapshot.data()["total"].toString());
      totalEarnings1 += orderAmount;
    }

    return totalEarnings1;
  }

  Future<double> calculateTotalEarnings1() async {
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore.instance
        .collection('order')
        .where("vendorId", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .where("order_status", isEqualTo: "Order Completed")
        .get();
    for (QueryDocumentSnapshot<Map<String, dynamic>> documentSnapshot in querySnapshot.docs) {
      double orderAmount = double.parse(documentSnapshot.data()["total"].toString());
      totalEarnings2 += orderAmount;
    }
    return totalEarnings2;
  }

  Future<double> adminCommission() async {
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore.instance
        .collection('order')
        .where("vendorId", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .where("order_status", isEqualTo: "Order Completed")
        .get();
    for (QueryDocumentSnapshot<Map<String, dynamic>> documentSnapshot in querySnapshot.docs) {
      double orderAmount = documentSnapshot.data()["admin_commission"];
      log("fghgfj$orderAmount");
      totalEarnings4 += orderAmount;
    }
    return totalEarnings4;
  }

  Future<void> fetchTotalEarnings() async {
    double earnings = await calculateTotalEarnings();
    double earnings1 = await calculateTotalEarnings1();
    double earnings2 = await adminCommission();
    totalWalletEarnings();
    setState(() {
      totalEarnings1 = earnings;
      totalEarnings2 = earnings1;
      totalEarnings3 = earnings + earnings1 - earnings2;
      log("dgdgd$totalEarnings3");
      totalEarnings = totalEarnings3 - totalWalletAmount;
      log("dgdfhdfh$totalEarnings");
    });
  }

  FirebaseService firebaseService = FirebaseService();
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  Future<void> withDrawMoney() async {
    OverlayEntry loader = Helper.overlayLoader(context);
    Overlay.of(context).insert(loader);
    try {
      await firebaseService
          .withDrawMoney(
        time: DateTime.now().millisecondsSinceEpoch,
        amount: addMoneyController.text.trim(),
        status: "Processing",
      )
          .then((value) {
        log(value.toString());
        Get.back();
        showToast("WithDraw Money Successfully");
        totalEarnings = totalEarnings - double.parse(addMoneyController.text.toString());
        setState(() {});
        addMoneyController.clear();
        Helper.hideLoader(loader);
      });
    } catch (e) {
      Helper.hideLoader(loader);
      showToast(e.toString());
      throw Exception(e.toString());
    }
  }

  List<WithdrawMoneyModel> withdrawModel = [];
  Stream<List<WithdrawMoneyModel>> getWithDrawData() {
    return FirebaseFirestore.instance
        .collection('withDrawMoney')
        .where("userId", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .orderBy("time", descending: true)
        .snapshots()
        .map((querySnapshot) {
      withdrawModel = [];
      try {
        for (var doc in querySnapshot.docs) {
          withdrawModel.add(WithdrawMoneyModel.fromJson(doc.data()));
        }
      } catch (e) {
        throw Exception(e.toString());
      }
      return withdrawModel;
    });
  }

  Future<double> calculateWallet() async {
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore.instance
        .collection('withDrawMoney')
        .where("userId", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get();
    for (QueryDocumentSnapshot<Map<String, dynamic>> documentSnapshot in querySnapshot.docs) {
      double orderAmount = double.parse(documentSnapshot.data()["amount"].toString());
      totalWalletAmount += orderAmount;
    }

    return totalWalletAmount;
  }

  Future<void> totalWalletEarnings() async {
    double earnings = await calculateWallet();
    setState(() {
      totalWalletAmount = earnings;
      log("teruyturtu$totalWalletAmount");
    });
  }

  @override
  Widget build(BuildContext context) {
    if (kDebugMode) {
      print(total);
    }
    return Scaffold(
      appBar: backAppBar(title: "Withdrawal Money".tr, context: context, dispose: widget.back),
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            children: [
              Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                      padding: const EdgeInsets.all(14),
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
                          const Spacer(),
                          Image.asset(
                            AppAssets.withdrawl,
                            height: 40,
                          )
                        ],
                      ))),
              Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
                      child: Column(
                        children: [
                          TextFormField(
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.center,
                              validator: (v) {
                                if (v == null || v.trim().isEmpty) {
                                  return "Please enter a valid amount";
                                }

                                double? parsedValue = double.tryParse(v);
                                if (parsedValue == null) {
                                  return "Please enter a valid amount";
                                }

                                if (parsedValue > totalEarnings) {
                                  return "You can withdraw more than $totalEarnings";
                                }

                                if (parsedValue <= 0) {
                                  return "Please enter a valid amount ";
                                }

                                return null;
                              },
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineSmall!
                                  .copyWith(color: AppTheme.blackcolor, fontWeight: FontWeight.w600, fontSize: AddSize.font24),
                              controller: addMoneyController,
                              cursorColor: AppTheme.primaryColor,
                              // validator: validateMoney,
                              decoration: const InputDecoration(
                                hintText: "+\$0.00",
                                hintStyle: TextStyle(color: Color(0xFF3A3A3A), fontWeight: FontWeight.w600, fontSize: 31),
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
                          const SizedBox(
                            height: 25,
                          ),
                          CommonButtonBlue(
                            title: "Withdrawal".tr,
                            onPressed: () {
                              if (formKey.currentState!.validate()) {
                                withDrawMoney();
                                // Get.toNamed(MyRouters.bankDetailsScreen);
                              }
                            },
                          )
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
                            "Amount".tr,
                            style: GoogleFonts.poppins(color: const Color(0xFF3B5998), fontWeight: FontWeight.w600, fontSize: 12),
                          ),
                          // const SizedBox(width: 0,),
                          Text(
                            "Date".tr,
                            style: GoogleFonts.poppins(color: const Color(0xFF3B5998), fontWeight: FontWeight.w600, fontSize: 12),
                          ),
                          Text(
                            "Status".tr,
                            style: GoogleFonts.poppins(color: const Color(0xFF3B5998), fontWeight: FontWeight.w600, fontSize: 12),
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
                      StreamBuilder<List<WithdrawMoneyModel>>(
                        stream: getWithDrawData(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            List<WithdrawMoneyModel> wallet = snapshot.data ?? []; //
                            return wallet.isNotEmpty
                                ? ListView.builder(
                                    padding: EdgeInsets.zero,
                                    physics: const BouncingScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: wallet.length,
                                    itemBuilder: (BuildContext context, int index) {
                                      var walletItem = wallet[index];
                                      return Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                "\$${walletItem.amount}",
                                                style: GoogleFonts.poppins(
                                                    color: const Color(0xFF454B5C), fontWeight: FontWeight.w600, fontSize: 14),
                                              ),
                                              Text(
                                                DateFormat("dd-mm-yy hh:mm a").format(DateTime.parse(
                                                    DateTime.fromMillisecondsSinceEpoch(walletItem.time).toLocal().toString())),
                                                style: GoogleFonts.poppins(
                                                    color: const Color(0xFF8C9BB2), fontWeight: FontWeight.w500, fontSize: 11),
                                              ),

                                              Text(
                                                walletItem.status.toString(),
                                                style: GoogleFonts.poppins(
                                                    color: walletItem.status == "Approve"
                                                        ? Colors.green
                                                        : walletItem.status == "Reject"
                                                            ? Colors.red
                                                            : const Color(0xFFFFB26B),
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 12),
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
                                : Column(
                                    children: [
                                      Container(
                                        margin: const EdgeInsets.only(
                                          top: 18,
                                        ),
                                        decoration: const BoxDecoration(
                                          color: Color(0xffFFFFFF),
                                        ),
                                        child: Column(
                                          // mainAxisAlignment: MainAxisAlignment.start,
                                          // crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              'You do not have any payment request',
                                              style: GoogleFonts.poppins(
                                                  fontSize: 15, fontWeight: FontWeight.w400, color: const Color(0xff747474)),
                                            ),
                                            const SizedBox(
                                              height: 40,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  );
                          }
                          return const SizedBox.shrink();
                        },
                      )
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
