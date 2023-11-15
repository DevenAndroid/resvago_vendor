import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pin_code_fields/flutter_pin_code_fields.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:resvago_vendor/routers/routers.dart';
import '../controllers/login_controller.dart';
import '../widget/appassets.dart';
import 'dashboard/dashboard_chart.dart';

class OtpScreen extends StatefulWidget {
  String verificationId;
  String code;
   OtpScreen({super.key, required this.verificationId, required this.code});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  TextEditingController otpController = TextEditingController();
  final loginController = Get.put(LoginController());
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String verificationId = "";
  reSend() async {
    try {
      final String phoneNumber = '+91${loginController.mobileController.text}'; // Include the country code
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
          Get.to(() => OtpScreen(verificationId: verificationId,code: widget.code,));
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          log("Auto Retrieval Timeout: $verificationId");
        },
      );
    } catch (e) {
      log("Error: $e");
    }
  }
  verifyOtp() async {
    try {
      PhoneAuthCredential phoneAuthCredential = PhoneAuthProvider.credential(
        verificationId: widget.verificationId,
        smsCode: otpController.text.trim(),
      );
      final UserCredential authResult = await _auth.signInWithCredential(phoneAuthCredential);
      final User? user = authResult.user;
      log('Successfully signed in with phone number: ${user!.phoneNumber}');
      Get.offAllNamed(MyRouters.bottomNavbar);
    } catch (e) {
      log("Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    log(loginController.mobileController.text);
    return Scaffold(
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
            child: Container(
                height: Get.height,
                width: Get.width,
                decoration: const BoxDecoration(
                    image: DecorationImage(
                        fit: BoxFit.fill, image: AssetImage(AppAssets.login))),
                child: SingleChildScrollView(
                    child: Padding(
                        padding: const EdgeInsets.only(left: 4.0, right: 4),
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
                                  'Sent OTP  to verify your number',
                                  style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 18,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 20),
                                child: PinCodeFields(
                                  length: 6,
                                  controller: otpController,
                                  fieldBorderStyle: FieldBorderStyle.square,
                                  responsive: true,
                                  fieldHeight: 50.0,
                                  fieldWidth: 60.0,
                                  borderWidth: 1.0,
                                  activeBorderColor: Colors.white,
                                  activeBackgroundColor:
                                      Colors.white.withOpacity(.10),
                                  borderRadius: BorderRadius.circular(10.0),
                                  keyboardType: TextInputType.number,
                                  autoHideKeyboard: true,
                                  fieldBackgroundColor:
                                      Colors.white.withOpacity(.10),
                                  borderColor: Colors.white,
                                  textStyle: GoogleFonts.poppins(
                                    fontSize: 25.0,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  onComplete: (output) {
                                    verifyOtp();
                                  },
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Align(
                                alignment: Alignment.center,
                                child: Text(
                                  'Enter the OTP Send to ${loginController.mobileController.text}',
                                  style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 18,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              InkWell(
                                onTap: () {
                                  reSend();
                                },
                                child: Center(
                                  child: Text(
                                    'RESEND OTP',
                                    style: GoogleFonts.poppins(
                                        color:  Colors.white,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              )
                            ]))))));
  }
}
