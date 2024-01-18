import 'dart:developer';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:email_otp/email_otp.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
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
import 'package:shared_preferences/shared_preferences.dart';
import '../forget_password.dart';
import '../helper.dart';
import '../verify_otp.dart';
import '../widget/apptheme.dart';
import '../widget/custom_textfield.dart';
import '../widget/language_change.dart';
import 'otp_screen.dart';

enum LoginOption { Mobile, EmailPassword }

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final loginController = Get.put(LoginController());
  final FirebaseAuth _auth = FirebaseAuth.instance;
  static FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  TextEditingController emailController = TextEditingController();
  TextEditingController otpController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool showOtpField = false;
  EmailOTP myauth = EmailOTP();
  String verificationId = "";
  String code = "+353";
  LoginOption loginOption = LoginOption.EmailPassword;

  fetchingFcmToken() {
    FirebaseDatabase.instance.reference().child("users").child(FirebaseAuth.instance.currentUser!.uid.toString()).get();
  }

  bool passwordSecure = false;
  String otp = '';
  void generateOTP() {
    int otpLength = 6;
    Random random = Random();
    String otpCode = '';
    for (int i = 0; i < otpLength; i++) {
      otpCode += random.nextInt(10).toString();
    }
    setState(() {
      otp = otpCode;
    });
  }

  void checkEmailInFirestore() async {
    OverlayEntry loader = Helper.overlayLoader(context);
    Overlay.of(context).insert(loader);
    generateOTP();
    final QuerySnapshot result =
        await FirebaseFirestore.instance.collection('vendor_users').where('email', isEqualTo: emailController.text).get();
    if (result.docs.isNotEmpty) {
      print("gfdgdgh${result.docs.first}");
      Map kk = result.docs.first.data() as Map;
      if (kk["deactivate"] == false) {
        try {
          await FirebaseAuth.instance
              .signInWithEmailAndPassword(
            email: emailController.text.trim(),
            password: passwordController.text.trim(),
          )
              .then((value) async {
            Helper.hideLoader(loader);
            SharedPreferences pref = await SharedPreferences.getInstance();
            pref.setString("password", passwordController.text.trim());
            if (!kIsWeb) {
              if (kk["twoStepVerification"] == true) {
              } else {
                Fluttertoast.showToast(msg: 'Login successfully');
              }
            } else {
              if (kk["twoStepVerification"] == true) {
              } else {}
            }
            if (kk["twoStepVerification"] == true) {
              FirebaseFirestore.instance.collection("send_mail").add({
                "to": emailController.text.trim(),
                "message": {
                  "subject": "This is a otp email",
                  "html": "Your otp is $otp",
                  "text": "asdfgwefddfgwefwn",
                }
              }).then((value) {
                if (!kIsWeb) {
                  Fluttertoast.showToast(msg: 'Otp email sent to ${emailController.text.trim()}');
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text("Otp email sent to ${emailController.text.trim()}"),
                  ));
                }
                Get.to(() => TwoStepVerificationScreen(email: emailController.text, password: passwordController.text, otp: otp));
              });
            } else {
              FirebaseFirestore.instance.collection("send_mail").add({
                "to": emailController.text.trim(),
                "message": {
                  "subject": "This is a otp email",
                  "html": "You have logged in new device",
                  "text": "asdfgwefddfgwefwn",
                }
              });
              Get.offAllNamed(MyRouters.bottomNavbar);
            }
          });
          return;
        }
        catch (e) {
          Helper.hideLoader(loader);
          print(e.toString());
          if (!kIsWeb) {
            if (e.toString() ==
                "[firebase_auth/invalid-credential] The supplied auth credential is incorrect, malformed or has expired.") {
              Fluttertoast.showToast(msg: "credential is incorrect");
            } else {
              Fluttertoast.showToast(msg: e.toString());
            }
          } else {
            if (e.toString() ==
                "[firebase_auth/invalid-credential] The supplied auth credential is incorrect, malformed or has expired.") {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text("credential is incorrect"),
              ));
            } else {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(e.toString()),
              ));
            }
          }
        }
      } else {
        Helper.hideLoader(loader);
        if (!kIsWeb) {
          Fluttertoast.showToast(msg: 'Your account has been deactivated, Please contact administrator');
        } else {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Your account has been deactivated, Please contact administrator"),
          ));
        }
      }
    } else {
      Helper.hideLoader(loader);
      if (!kIsWeb) {
        Fluttertoast.showToast(msg: 'Email not register yet Please Signup');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Email not register yet Please Signup"),
        ));
      }
    }
  }

  void logError(String message) {
    FirebaseCrashlytics.instance.log(message);
  }

  var oldPasswordSecure = false;
  bool checkemail = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    generateOTP();
    checkLanguage();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
            child: Container(
                decoration: const BoxDecoration(
                    image: DecorationImage(fit: BoxFit.fill, image: AssetImage(kIsWeb ? AppAssets.webLogin : AppAssets.login))),
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
                          const SizedBox(width: 20),
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
                                        borderSide: const BorderSide(width: 1, color: Colors.white),
                                      ),
                                      disabledBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                                    ),
                                    onCountryChanged: (Country phone) {
                                      setState(() {
                                        code = "+${phone.dialCode}";
                                        if (kDebugMode) {
                                          print(code.toString());
                                        }
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
                                  TextFormField(
                                    controller: emailController,
                                    style: const TextStyle(color: Colors.white),
                                    validator: MultiValidator([
                                      RequiredValidator(errorText: 'Please enter your email'),
                                      EmailValidator(errorText: 'Enter a valid email address'),
                                    ]).call,
                                    decoration: InputDecoration(
                                      hintText: 'Enter Email'.tr,
                                      hintStyle: const TextStyle(color: Colors.white),
                                      // suffix: InkWell(
                                      //   onTap: () {
                                      //     if (_formKey.currentState!.validate()) {
                                      //       checkEmailInFirestore();
                                      //     }
                                      //   },
                                      //   child: const Text(
                                      //     'send',
                                      //     style: TextStyle(color: Colors.white),
                                      //   ),
                                      //
                                      // ),
                                      filled: true,
                                      fillColor: Colors.white.withOpacity(.10),
                                      // contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                                      // .copyWith(top: maxLines! > 4 ? AddSize.size18 : 0),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: const Color(0xFFffffff).withOpacity(.24)),
                                        borderRadius: BorderRadius.circular(6.0),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(color: const Color(0xFFffffff).withOpacity(.24)),
                                          borderRadius: const BorderRadius.all(Radius.circular(6.0))),
                                      border: OutlineInputBorder(
                                          borderSide: BorderSide(color: const Color(0xFFffffff).withOpacity(.24), width: 3.0),
                                          borderRadius: BorderRadius.circular(6.0)),
                                    ),
                                    keyboardType: TextInputType.emailAddress,
                                    // textInputAction: TextInputAction.next,
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  TextFormField(
                                    style: const TextStyle(color: Colors.white),
                                    controller: passwordController,
                                    keyboardType: TextInputType.text,
                                    obscureText: !oldPasswordSecure,
                                    decoration: InputDecoration(
                                      hintText: 'Enter Password'.tr,
                                      suffix: GestureDetector(
                                          onTap: () {
                                            oldPasswordSecure = !oldPasswordSecure;
                                            setState(() {});
                                          },
                                          child: Icon(
                                            oldPasswordSecure ? Icons.visibility : Icons.visibility_off,
                                            size: 20,
                                            color: Colors.white,
                                          )),
                                      hintStyle: const TextStyle(color: Colors.white),
                                      filled: true,
                                      fillColor: Colors.white.withOpacity(.10),
                                      contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 16),
                                      // .copyWith(top: maxLines! > 4 ? AddSize.size18 : 0),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: const Color(0xFFffffff).withOpacity(.24)),
                                        borderRadius: BorderRadius.circular(6.0),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(color: const Color(0xFFffffff).withOpacity(.24)),
                                          borderRadius: const BorderRadius.all(Radius.circular(6.0))),
                                      border: OutlineInputBorder(
                                          borderSide: BorderSide(color: const Color(0xFFffffff).withOpacity(.24), width: 3.0),
                                          borderRadius: BorderRadius.circular(6.0)),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Padding(
                              padding: const EdgeInsets.only(right: 15),
                              child: GestureDetector(
                                onTap: () {
                                  Get.to(() => ForgotPassword());
                                },
                                child: Text(
                                  'Forgot Password'.tr,
                                  style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w300,
                                    fontSize: 14,
                                    // fontFamily: 'poppins',
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                CommonButton(
                                  onPressed: () async {
                                    if (_formKey.currentState!.validate()) {
                                      checkEmailInFirestore();
                                    }
                                  },
                                  title: 'Login'.tr,
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                GestureDetector(
                                    onTap: () {
                                      showDialogLanguage(context);
                                    },
                                    child: Text(
                                      "Change Language".tr,
                                      style: const TextStyle(color: Color(0xFF1877F2), fontSize: 16, fontWeight: FontWeight.w600),
                                    )),
                                const SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Don't Have an Account?".tr,
                                      style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 14),
                                    ),
                                    const SizedBox(width: 5),
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
                                  height: 10,
                                ),
                                Text(
                                  'Signup as a customer'.tr,
                                  style: const TextStyle(color: Color(0xFF1877F2), fontSize: 16, fontWeight: FontWeight.w600),
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
                                Text(
                                  'Customer Booking?'.tr,
                                  style: GoogleFonts.poppins(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
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

  updateLanguage(String gg) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString("app_language", gg);
  }

  RxString selectedLAnguage = "English".obs;
  checkLanguage() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? appLanguage = sharedPreferences.getString("app_language");
    if (appLanguage == null || appLanguage == "English") {
      Get.updateLocale(const Locale('en', 'US'));
      selectedLAnguage.value = "English";
    } else if (appLanguage == "Spanish") {
      Get.updateLocale(const Locale('es', 'ES'));
      selectedLAnguage.value = "Spanish";
    } else if (appLanguage == "French") {
      Get.updateLocale(const Locale('fr', 'FR'));
      selectedLAnguage.value = "French";
    } else if (appLanguage == "Arabic") {
      Get.updateLocale(const Locale('ar', 'AE'));
      selectedLAnguage.value = "Arabic";
    }
  }

  showDialogLanguage(context) {
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return Dialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  RadioListTile(
                      value: "English",
                      groupValue: selectedLAnguage.value,
                      title: const Text(
                        "English",
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Color(0xff000000)),
                      ),
                      onChanged: (value) {
                        locale = const Locale('en', 'US');
                        Get.updateLocale(locale);
                        selectedLAnguage.value = value!;
                        updateLanguage("English");
                        setState(() {});
                        if (kDebugMode) {
                          print(selectedLAnguage);
                        }
                      }),
                  RadioListTile(
                      value: "Spanish",
                      groupValue: selectedLAnguage.value,
                      title: const Text(
                        "Spanish",
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Color(0xff000000)),
                      ),
                      onChanged: (value) {
                        locale = const Locale('es', 'ES');
                        Get.updateLocale(locale);
                        selectedLAnguage.value = value!;
                        updateLanguage("Spanish");
                        setState(() {});
                        if (kDebugMode) {
                          print(selectedLAnguage);
                        }
                      }),
                  RadioListTile(
                      value: "French",
                      groupValue: selectedLAnguage.value,
                      title: const Text(
                        "French",
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Color(0xff000000)),
                      ),
                      onChanged: (value) {
                        locale = const Locale('fr', 'FR');
                        Get.updateLocale(locale);
                        selectedLAnguage.value = value!;
                        updateLanguage("French");
                        setState(() {});
                        if (kDebugMode) {
                          print(selectedLAnguage);
                        }
                      }),
                  RadioListTile(
                      value: "Arabic",
                      groupValue: selectedLAnguage.value,
                      title: const Text(
                        "Arabic",
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Color(0xff000000)),
                      ),
                      onChanged: (value) {
                        locale = const Locale('ar', 'AE');
                        Get.updateLocale(locale);
                        selectedLAnguage.value = value!;
                        updateLanguage("Arabic");
                        setState(() {});
                        if (kDebugMode) {
                          print(selectedLAnguage);
                        }
                      }),
                  Align(
                    alignment: Alignment.center,
                    child: GestureDetector(
                      onTap: () {
                        Get.back();
                      },
                      child: Container(
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: AppTheme.primaryColor),
                          child: const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              "Update",
                              style: TextStyle(color: Colors.white),
                            ),
                          )),
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }
}
