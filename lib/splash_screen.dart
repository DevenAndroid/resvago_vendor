import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:resvago_vendor/routers/routers.dart';
import 'package:resvago_vendor/widget/appassets.dart';
import 'Firebase_service/firebase_service.dart';
import 'model/signup_model.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  FirebaseService service = FirebaseService();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  checkLogin()  {
    Get.offAllNamed(MyRouters.onBoardingScreen);
    // User? currentUser = _auth.currentUser;
    // if (currentUser != null) {
    //   RegisterData? thisUserModel = await service.getUserInfo(uid: currentUser.uid);
    //   if (thisUserModel != null) {
    //     Get.offAllNamed(MyRouters.vendorDashboard, arguments: [thisUserModel, currentUser]);
    //   } else {
    //     Get.offAllNamed(MyRouters.onBoardingScreen);
    //   }
    // }
  }

  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 2), () async {
      checkLogin();
    });
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return  Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(child: Image(image: const AssetImage(AppAssets.Resvago),width: width * 2,height: height,)),
    );
  }
}
