import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_otp/email_otp.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl_phone_field/countries.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:resvago_vendor/controllers/login_controller.dart';
import 'package:resvago_vendor/routers/routers.dart';
import 'package:resvago_vendor/utils/helper.dart';
import 'package:resvago_vendor/widget/appassets.dart';
import '../helper.dart';
import '../widget/custom_textfield.dart';
import 'otp_screen.dart';

enum LoginOption { Mobile, EmailPassword }

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final loginController = Get.put(LoginController());
  final FirebaseAuth _auth = FirebaseAuth.instance;
  TextEditingController emailController = TextEditingController();
  TextEditingController otpController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool showOtpField = false;
  EmailOTP myauth = EmailOTP();
  String verificationId = "";
  String code = "+353";
  LoginOption loginOption = LoginOption.Mobile;

  fetchingFcmToken() {
    FirebaseDatabase.instance.reference().child("users").child(FirebaseAuth.instance.currentUser!.uid.toString()).get();
  }

  void checkEmailInFirestore() async {
    final QuerySnapshot result =
        await FirebaseFirestore.instance.collection('vendor_users').where('email', isEqualTo: emailController.text).get();
    if (result.docs.isNotEmpty) {
      print(result.docs.first.data());
      Map kk = result.docs.first.data() as Map;
      print(kk["email"]);
      if (kk["deactivate"] == false) {
        myauth.setConfig(
            appEmail: "contact@hdevcoder.com",
            appName: "Email OTP",
            userEmail: emailController.text,
            otpLength: 6,
            otpType: OTPType.digitsOnly);
        if (await myauth.sendOTP() == true) {
          showToast("OTP has been sent");
        } else {
          showToast("Oops, OTP send failed");
        }
        setState(() {
          showOtpField = true;
        });
        return;
      } else {
        Fluttertoast.showToast(msg: 'Your account has been deactivated, Please contact administrator');
      }
    } else {
      Fluttertoast.showToast(msg: 'Email not register yet Please Signup');
    }
  }

  void checkPhoneNumberInFirestore() async {
    if (loginController.mobileController.text.isEmpty) {
      Fluttertoast.showToast(msg: 'Please enter phone number');
      return;
    }
    final QuerySnapshot result = await FirebaseFirestore.instance
        .collection('vendor_users')
        .where('mobileNumber', isEqualTo: code + loginController.mobileController.text)
        .get();
    log(result.docs.toString());
    if (result.docs.isNotEmpty) {
      Map kk = result.docs.first.data() as Map;
      if (kk["deactivate"] == true) {
        Fluttertoast.showToast(msg: 'Your account has been deactivated, Please contact administrator');
      } else {
        login(kk["email"].toString());
      }
    } else {
      Fluttertoast.showToast(msg: '${code + loginController.mobileController.text}Phone Number not register yet Please Signup');
    }
  }

  login(String email) async {
    OverlayEntry loader = Helper.overlayLoader(context);
    Overlay.of(context).insert(loader);
    try {
      final String phoneNumber = code + loginController.mobileController.text;
      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) {
          log("Verification credential: $credential");
          showToast("$credential");
        },
        verificationFailed: (FirebaseAuthException e) {
          log("Verification Failed: $e");
          showToast("$e");
        },
        codeSent: (String verificationId, [int? resendToken]) {
          log("Code Sent: $verificationId");
          showToast(verificationId);
          verificationId = verificationId;
          Get.to(() => OtpScreen(
                verificationId: verificationId,
                code: code,
                email: email,
              ));
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          log("Auto Retrieval Timeout: $verificationId");
          showToast(verificationId);
        },
      );
      Helper.hideLoader(loader);
    } catch (e) {
      Helper.hideLoader(loader);
      showToast(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
            child: Container(
                decoration: const BoxDecoration(image: DecorationImage(fit: BoxFit.fill,
                    image: AssetImage(kIsWeb ?AppAssets.webLogin :AppAssets.login))),
                child: Padding(
                  padding: const EdgeInsets.only(left: 4.0, right: 4),
                  child: Form(
                    key: _formKey,
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: size.height * 0.34,
                          ),
                          Align(
                            alignment: Alignment.center,
                            child: Text(
                              'WELCOME'.tr,
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
                              'Login your account.'.tr,
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: 13,
                                // fontFamily: 'poppins',
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              Radio(
                                value: LoginOption.Mobile,
                                groupValue: loginOption,
                                onChanged: (LoginOption? value) {
                                  setState(() {
                                    loginOption = value!;
                                  });
                                },
                              ),
                               Text(
                                "Login With Mobile Number".tr,
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                          const SizedBox(width: 20),
                          Row(
                            children: [
                              Radio(
                                value: LoginOption.EmailPassword,
                                groupValue: loginOption,
                                onChanged: (LoginOption? value) {
                                  setState(() {
                                    loginOption = value!;
                                  });
                                },
                              ),
                               Text("Login With Email Address".tr, style: TextStyle(color: Colors.white)),
                            ],
                          ),
                          if (loginOption == LoginOption.Mobile)
                            Padding(
                              padding: const EdgeInsets.all(12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Enter Mobile Number'.tr,
                                    style: GoogleFonts.poppins(
                                      color: Colors.white,
                                      fontSize: 14,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  IntlPhoneField(
                                    dropdownIcon: const Icon(Icons.arrow_drop_down_rounded, color: Colors.white),
                                    flagsButtonPadding: const EdgeInsets.all(8),
                                    dropdownIconPosition: IconPosition.trailing,
                                    controller: loginController.mobileController,
                                    style: const TextStyle(color: Colors.white),
                                    validator: MultiValidator([
                                      RequiredValidator(errorText: 'Please enter your phone number'.tr),
                                    ]).call,
                                    dropdownTextStyle: const TextStyle(color: Colors.white),
                                    decoration: InputDecoration(
                                      hintText: 'Enter your Mobile number'.tr,
                                      hintStyle: const TextStyle(color: Colors.white),
                                      filled: true,
                                      enabled: true,
                                      enabledBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                                      focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                                      iconColor: Colors.white,
                                      errorBorder: const OutlineInputBorder(borderSide: BorderSide(width: 1)),
                                      fillColor: const Color(0x63ffffff).withOpacity(.2),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(5),
                                        borderSide: const BorderSide(width: 1, color: Color(0x63ffffff)),
                                      ),
                                    ),
                                    onCountryChanged: (Country phone) {
                                      setState(() {
                                        code = "+${phone.dialCode}";
                                        log(code.toString());
                                      });
                                    },
                                    initialCountryCode: 'IE',
                                    cursorColor: Colors.white,
                                    keyboardType: TextInputType.number,
                                  ),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                ],
                              ),
                            ),
                          if (loginOption == LoginOption.EmailPassword)
                            Padding(
                              padding: const EdgeInsets.all(12),
                              child: Column(
                                children: [
                                  CommonTextFieldWidget(
                                    controller: emailController,
                                    hint: 'Enter Email'.tr,
                                  ),
                                  SizedBox(height: 20,),
                                  CommonTextFieldWidget(
                                    controller: passwordController,
                                    hint: 'Enter Password'.tr,
                                  ),

                                  // TextFormField(
                                  //   controller: emailController,
                                  //   style: const TextStyle(color: Colors.white),
                                  //   validator: MultiValidator([
                                  //     RequiredValidator(errorText: 'Please enter your email'),
                                  //     EmailValidator(errorText: 'Enter a valid email address'),
                                  //   ]).call,
                                  //   decoration: InputDecoration(
                                  //     hintText: 'Enter Email',
                                  //     hintStyle: const TextStyle(color: Colors.white),
                                  //     suffix: InkWell(
                                  //       onTap: () {
                                  //         checkEmailInFirestore();
                                  //       },
                                  //       child: const Text(
                                  //         'send',
                                  //         style: TextStyle(color: Colors.white),
                                  //       ),
                                  //     ),
                                  //     filled: true,
                                  //     fillColor: Colors.white.withOpacity(.10),
                                  //     // contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                                  //     // .copyWith(top: maxLines! > 4 ? AddSize.size18 : 0),
                                  //     focusedBorder: OutlineInputBorder(
                                  //       borderSide: BorderSide(color: const Color(0xFFffffff).withOpacity(.24)),
                                  //       borderRadius: BorderRadius.circular(6.0),
                                  //     ),
                                  //     enabledBorder: OutlineInputBorder(
                                  //         borderSide: BorderSide(color: const Color(0xFFffffff).withOpacity(.24)),
                                  //         borderRadius: const BorderRadius.all(Radius.circular(6.0))),
                                  //     border: OutlineInputBorder(
                                  //         borderSide: BorderSide(color: const Color(0xFFffffff).withOpacity(.24), width: 3.0),
                                  //         borderRadius: BorderRadius.circular(6.0)),
                                  //   ),
                                  //   keyboardType: TextInputType.emailAddress,
                                  //   // textInputAction: TextInputAction.next,
                                  // ),
                                  // const SizedBox(
                                  //   height: 20,
                                  // ),
                                  // if (!showOtpField)
                                  //   TextFormField(
                                  //     style: const TextStyle(color: Colors.white),
                                  //     controller: passwordController,
                                  //     decoration: InputDecoration(
                                  //       filled: true,
                                  //       hintText: 'Enter Otp',
                                  //       hintStyle: const TextStyle(color: Colors.white),
                                  //       fillColor: Colors.white.withOpacity(.10),
                                  //       contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 16),
                                  //       // .copyWith(top: maxLines! > 4 ? AddSize.size18 : 0),
                                  //       focusedBorder: OutlineInputBorder(
                                  //         borderSide: BorderSide(color: const Color(0xFFffffff).withOpacity(.24)),
                                  //         borderRadius: BorderRadius.circular(6.0),
                                  //       ),
                                  //       enabledBorder: OutlineInputBorder(
                                  //           borderSide: BorderSide(color: const Color(0xFFffffff).withOpacity(.24)),
                                  //           borderRadius: const BorderRadius.all(Radius.circular(6.0))),
                                  //       border: OutlineInputBorder(
                                  //           borderSide: BorderSide(color: const Color(0xFFffffff).withOpacity(.24), width: 3.0),
                                  //           borderRadius: BorderRadius.circular(6.0)),
                                  //     ),
                                  //   )
                                  // else
                                  //   TextFormField(
                                  //     style: const TextStyle(color: Colors.white),
                                  //     controller: otpController,
                                  //     keyboardType: TextInputType.number,
                                  //     decoration: InputDecoration(
                                  //       hintText: 'Enter Otp',
                                  //       hintStyle: const TextStyle(color: Colors.white),
                                  //       filled: true,
                                  //       fillColor: Colors.white.withOpacity(.10),
                                  //       contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 16),
                                  //       // .copyWith(top: maxLines! > 4 ? AddSize.size18 : 0),
                                  //       focusedBorder: OutlineInputBorder(
                                  //         borderSide: BorderSide(color: const Color(0xFFffffff).withOpacity(.24)),
                                  //         borderRadius: BorderRadius.circular(6.0),
                                  //       ),
                                  //       enabledBorder: OutlineInputBorder(
                                  //           borderSide: BorderSide(color: const Color(0xFFffffff).withOpacity(.24)),
                                  //           borderRadius: const BorderRadius.all(Radius.circular(6.0))),
                                  //       border: OutlineInputBorder(
                                  //           borderSide: BorderSide(color: const Color(0xFFffffff).withOpacity(.24), width: 3.0),
                                  //           borderRadius: BorderRadius.circular(6.0)),
                                  //     ),
                                  //   ),
                                ],
                              ),
                            ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                loginOption == LoginOption.EmailPassword
                                    ? CommonButton(
                                        onPressed: () async {
                                          if (_formKey.currentState!.validate()) {
                                            // if (await myauth.verifyOTP(otp: otpController.text) == true) {
                                            //   showToast("OTP is verified");
                                            //   FirebaseAuth.instance
                                            //       .signInWithEmailAndPassword(
                                            //     email: emailController.text.trim(),
                                            //     password: "123456",
                                            //   )
                                            //       .then((value) {
                                            //     Get.offAllNamed(MyRouters.bottomNavbar);
                                            //   });
                                            // } else {
                                            //   showToast("Invalid OTP");
                                            // }
                                            FirebaseAuth.instance
                                                  .signInWithEmailAndPassword(
                                                email: emailController.text.trim(),
                                                password: passwordController.text.trim(),
                                              )
                                                  .then((value) {
                                                Get.offAllNamed(MyRouters.bottomNavbar);
                                              });
                                          }
                                        },
                                        title: 'Login'.tr,
                                      )
                                    : CommonButton(
                                        onPressed: () async {
                                          if (_formKey.currentState!.validate()) {
                                            checkPhoneNumberInFirestore();
                                          }
                                        },
                                        title: 'Login'.tr,
                                      ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Text(
                                  'Customer Booking?'.tr,
                                  style: GoogleFonts.poppins(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  'Signup as a customer'.tr,
                                  style: GoogleFonts.poppins(
                                      color: const Color(0xFF1877F2), fontSize: 16, fontWeight: FontWeight.w600),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Container(
                                        height: 1,
                                        width: 120,
                                        color: const Color(0xFFD2D8DC),
                                      ),
                                    ),
                                    //SizedBox(width: 10,),
                                     Text('Or Login with'.tr,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.white,
                                        )),
                                    //SizedBox(width: 10,),
                                    Expanded(
                                      child: Container(
                                        height: 1,
                                        width: 120,
                                        color: const Color(0xFFD2D8DC),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Container(
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
                                              'Facebook'.tr,
                                              style: GoogleFonts.poppins(
                                                  fontSize: 15, fontWeight: FontWeight.w600, color: Colors.white),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 20,
                                    ),
                                    Expanded(
                                      child: GestureDetector(
                                        onTap: () {},
                                        child: Container(
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
                                                'Google'.tr,
                                                style: GoogleFonts.poppins(
                                                    fontSize: 15, fontWeight: FontWeight.w600, color: Colors.white),
                                              )
                                            ],
                                          ),
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
                                      "Don't Have an Account?".tr,
                                      style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 14),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        Get.toNamed(MyRouters.signUpScreen);
                                      },
                                      child: Text(
                                        'Signup'.tr,
                                        style: GoogleFonts.poppins(
                                            color: const Color(0xFF1877F2), fontWeight: FontWeight.w600, fontSize: 14),
                                      ),
                                    )
                                  ],
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                              ],
                            ),
                          )
                        ]),
                  ),
                )).appPaddingForScreen));
  }
}
