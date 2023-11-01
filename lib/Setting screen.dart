import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:resvago_vendor/screen/thankyou_screen.dart';
import 'package:resvago_vendor/widget/apptheme.dart';
import 'package:resvago_vendor/widget/common_text_field.dart';
import 'package:resvago_vendor/widget/custom_textfield.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  TextEditingController preparationTimeController = TextEditingController();
  TextEditingController averageMealForMemberController =
      TextEditingController();
  bool state = false;
  bool state1 = false;
  bool state2 = false;

  Addsettingdatatofirebase() {
    FirebaseFirestore.instance
        .collection('Vendor_Setting')
        .doc(FirebaseAuth.instance.currentUser!.phoneNumber)
        .set({
      "preparationTime": preparationTimeController.text,
      "averageMealForMember": averageMealForMemberController.text,
      "setDelivery": state,
      "cancellation": state1,
      "menuSelection": state2,
      "time": DateTime.now(),
      "userID": FirebaseAuth.instance.currentUser!.phoneNumber,
    }).then((value) {
      Get.to(const ThankYouScreen());

      Fluttertoast.showToast(msg: 'Setting Updated');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: backAppBar(title: "Setting", context: context),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10)),
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Row(
                    children: [
                      Text(
                        "Set Delivery",
                        style: GoogleFonts.poppins(
                            color: const Color(0xFF292F45),
                            fontSize: 15,
                            fontWeight: FontWeight.w400),
                      ),
                      const Spacer(),
                      CupertinoSwitch(
                        value: state,
                        activeColor: const Color(0xffFAAF40),
                        onChanged: (value) {
                          state = value;
                          setState(() {});
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10)),
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Row(
                    children: [
                      Text(
                        "Cancellation",
                        style: GoogleFonts.poppins(
                            color: const Color(0xFF292F45),
                            fontSize: 15,
                            fontWeight: FontWeight.w400),
                      ),
                      const Spacer(),
                      CupertinoSwitch(
                        value: state1,
                        activeColor: const Color(0xffFAAF40),
                        onChanged: (value) {
                          state1 = value;
                          setState(() {});
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10)),
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Row(
                    children: [
                      Text(
                        "Menu selection",
                        style: GoogleFonts.poppins(
                            color: const Color(0xFF292F45),
                            fontSize: 15,
                            fontWeight: FontWeight.w400),
                      ),
                      const Spacer(),
                      CupertinoSwitch(
                        value: state2,
                        activeColor: const Color(0xffFAAF40),
                        onChanged: (value) {
                          state2 = value;
                          setState(() {});
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                "Preparation time",
                style: GoogleFonts.poppins(
                    color: AppTheme.registortext,
                    fontWeight: FontWeight.w500,
                    fontSize: 15),
              ),
              const SizedBox(
                height: 10,
              ),
              RegisterTextFieldWidget(
                controller: preparationTimeController,
                validator: MultiValidator([
                  RequiredValidator(
                      errorText: 'Please enter your preparation Time'),
                ]).call,
                keyboardType: TextInputType.number,
                hint: '20 Mint',
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                "Average meal for 1 Member",
                style: GoogleFonts.poppins(
                    color: AppTheme.registortext,
                    fontWeight: FontWeight.w500,
                    fontSize: 15),
              ),
              const SizedBox(
                height: 10,
              ),
              RegisterTextFieldWidget(
                controller: averageMealForMemberController,
                validator: MultiValidator([
                  RequiredValidator(
                      errorText: 'Please enter your average Meal For 1 Member'),
                ]).call,
                keyboardType: TextInputType.number,
                hint: '100',
              ),
              const SizedBox(
                height: 170,
              ),
              CommonButtonBlue(
                title: "Submit",
                onPressed: () {
                  Addsettingdatatofirebase();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
