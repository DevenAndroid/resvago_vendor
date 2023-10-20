import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:resvago_vendor/routers/routers.dart';
import 'package:resvago_vendor/screen/bottom_nav_bar/bottomnav_bar.dart';
import 'package:resvago_vendor/screen/dashboard/dashboard_screen.dart';
import 'package:resvago_vendor/screen/login_screen.dart';
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
  Future<void> checkUserAuth() async {
    FirebaseAuth _auth = FirebaseAuth.instance;
    User? user = _auth.currentUser;
    if (user != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => BottomNavbar()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 2), () async {
      checkUserAuth();
    });
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return  Scaffold(
      backgroundColor: Colors.transparent,
      body: Image(image: const AssetImage(AppAssets.Resvago),width: double.maxFinite,height: height,),
    );
  }
}
