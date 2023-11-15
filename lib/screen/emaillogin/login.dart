import 'package:email_otp/email_otp.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:resvago_vendor/helper.dart';

import 'homepage.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController otpController = TextEditingController();
  bool showOtpField = false;
  EmailOTP myauth = EmailOTP();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TextFormField(
            controller: emailController,
            decoration: InputDecoration(
              suffix: GestureDetector(
                onTap: () async {
                  myauth.setConfig(
                      appEmail: "contact@hdevcoder.com",
                      appName: "Email OTP",
                      userEmail: emailController.text,
                      otpLength: 4,
                      otpType: OTPType.digitsOnly);
                  if (await myauth.sendOTP() == true) {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(const SnackBar(
                  content: Text("OTP has been sent"),
                  ));

                  } else {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(const SnackBar(
                  content: Text("Oops, OTP send failed"),
                  ));
                  }
                  setState(() {
                    showOtpField = true;
                  });
                },
                child: Text('send'),
              ),
            ),
          ),
          // Show either password or OTP field based on the state
          if (!showOtpField)
            TextFormField(
              controller: passwordController,
            )
          else
            TextFormField(
              controller: otpController,
              decoration: InputDecoration(
                labelText: 'Enter OTP',
              ),
            ),
          ElevatedButton(
            onPressed: () async {
              if (!showOtpField) {
                FirebaseAuth.instance
                    .signInWithEmailAndPassword(
                  email: emailController.text.trim(),
                  password: passwordController.text.trim(),
                )
                    .then((value) {
                  print(value);
                  Get.to(Homepgae());
                });
                showToast('login');
              } else {
                if (await myauth.verifyOTP(otp: otpController.text) == true) {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("OTP is verified"),
              ));
              Navigator.push(context,
              MaterialPageRoute(builder: (context) => const Homepgae()));
              } else {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("Invalid OTP"),
              ));
              }
              }
            },
            child: Text('login'),
          ),
        ],
      ),
    );
  }
}
