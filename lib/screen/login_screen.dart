import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:resvago_vendor/controllers/login_controller.dart';
import 'package:resvago_vendor/routers/routers.dart';
import 'package:resvago_vendor/widget/appassets.dart';
import '../helper.dart';
import '../widget/custom_textfield.dart';
import 'otp_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final loginController = Get.put(LoginController());
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String verificationId = "";

  fetchingFcmToken() {
    FirebaseDatabase.instance.reference().child("users").child(FirebaseAuth.instance.currentUser!.phoneNumber.toString()).get();
  }

  void checkPhoneNumberInFirestore() async {
    final QuerySnapshot result = await FirebaseFirestore.instance
        .collection('vendor_users')
        .where('mobileNumber', isEqualTo: code + loginController.mobileController.text)
        .get();
    log(result.docs.toString());
    if (result.docs.isNotEmpty) {
      login();
    } else {
      Fluttertoast.showToast(msg: 'Phone Number not register yet Please Signup');
    }
  }

  login() async {
    OverlayEntry loader = Helper.overlayLoader(context);
    Overlay.of(context).insert(loader);
    try {
      final String phoneNumber = code + loginController.mobileController.text;
      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) {},
        verificationFailed: (FirebaseAuthException e) {
          log("Verification Failed: $e");
        },
        codeSent: (String verificationId, [int? resendToken]) {
          // Update the parameter to accept nullable int
          log("Code Sent: $verificationId");
          this.verificationId = verificationId;
          Get.to(() => OtpScreen(verificationId: verificationId));
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          log("Auto Retrieval Timeout: $verificationId");
        },
      );
      Helper.hideLoader(loader);
    } catch (e) {
      Helper.hideLoader(loader);
    }
  }

  String code = "+91";
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
            child: Container(
                decoration: const BoxDecoration(image: DecorationImage(fit: BoxFit.fill, image: AssetImage(AppAssets.login))),
                child: Padding(
                  padding: const EdgeInsets.only(left: 4.0, right: 4),
                  child: Form(
                    key: _formKey,
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: size.height * 0.32,
                          ),
                          Align(
                            alignment: Alignment.center,
                            child: Text(
                              'WELCOME ',
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 28,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Align(
                            alignment: Alignment.center,
                            child: Text(
                              'Login your account.',
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: 13,
                                // fontFamily: 'poppins',
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 38),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Enter Mobile Number',
                                  style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                IntlPhoneField(
                                  cursorColor: Colors.white,
                                  dropdownIcon: const Icon(
                                    Icons.arrow_drop_down_rounded,
                                    color: Colors.white,
                                  ),
                                  dropdownTextStyle: const TextStyle(color: Colors.white),
                                  style: const TextStyle(color: Colors.white),
                                  flagsButtonPadding: const EdgeInsets.all(8),
                                  dropdownIconPosition: IconPosition.trailing,
                                  controller: loginController.mobileController,
                                  decoration: const InputDecoration(
                                      hintStyle: TextStyle(color: Colors.white),
                                      labelText: 'Phone Number',
                                      labelStyle: TextStyle(color: Colors.white),
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide(),
                                      ),
                                      enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                                      focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white))),
                                  initialCountryCode: 'IN',
                                  onChanged: (phone) {
                                    code = phone.countryCode.toString();
                                    setState(() {});
                                  },
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                CommonButton(
                                  onPressed: () {
                                    if (_formKey.currentState!.validate()) {
                                      checkPhoneNumberInFirestore();
                                    }
                                  },
                                  title: 'Login',
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Text(
                                  'Customer Booking?',
                                  style: GoogleFonts.poppins(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  'Signup as a customer',
                                  style: GoogleFonts.poppins(
                                      color: const Color(0xFF1877F2), fontSize: 16, fontWeight: FontWeight.w600),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      height: 1,
                                      width: 120,
                                      color: const Color(0xFFD2D8DC),
                                    ),
                                    //SizedBox(width: 10,),
                                    const Text('Or Login with',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.white,
                                        )),
                                    //SizedBox(width: 10,),
                                    Container(
                                      height: 1,
                                      width: 120,
                                      color: const Color(0xFFD2D8DC),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      width: 152,
                                      height: 60,
                                      decoration: BoxDecoration(
                                          color: Colors.white.withOpacity(.10),
                                          borderRadius: BorderRadius.circular(10),
                                          border: Border.all(color: Colors.white.withOpacity(.35))),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Image.asset(
                                            AppAssets.facebook,
                                            height: 25,
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            'Facebook',
                                            style: GoogleFonts.poppins(
                                                fontSize: 15, fontWeight: FontWeight.w600, color: Colors.white),
                                          )
                                        ],
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {},
                                      child: Container(
                                        width: 152,
                                        height: 60,
                                        decoration: BoxDecoration(
                                            color: Colors.white.withOpacity(.10),
                                            borderRadius: BorderRadius.circular(10),
                                            border: Border.all(color: Colors.white.withOpacity(.35))),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Image.asset(
                                              AppAssets.google,
                                              height: 25,
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            Text(
                                              'Google',
                                              style: GoogleFonts.poppins(
                                                  fontSize: 15, fontWeight: FontWeight.w600, color: Colors.white),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Don't Have an Account?",
                                      style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 14),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        Get.toNamed(MyRouters.signUpScreen);
                                      },
                                      child: Text(
                                        ' Signup',
                                        style: GoogleFonts.poppins(
                                            color: const Color(0xFF1877F2), fontWeight: FontWeight.w600, fontSize: 14),
                                      ),
                                    )
                                  ],
                                )
                              ],
                            ),
                          )
                        ]),
                  ),
                ))));
  }
}
