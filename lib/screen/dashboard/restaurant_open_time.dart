import 'dart:convert';
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../model/set_store_time_model.dart';
import '../../widget/apptheme.dart';
import '../set_store_time/set_store_time.dart';

class RestaurantTimingScreen extends StatefulWidget {
  const RestaurantTimingScreen({super.key, required this.docId});
  final String docId;

  @override
  State<RestaurantTimingScreen> createState() => _RestaurantTimingScreenState();
}

class _RestaurantTimingScreenState extends State<RestaurantTimingScreen> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection("week_schedules").doc(FirebaseAuth.instance.currentUser!.uid).snapshots(),
      builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
        if(snapshot.hasData && snapshot.data!.data() != null){
          ModelStoreTime modelStoreTime = ModelStoreTime.fromJson(snapshot.data!.data()!);
          Schedule? schedule;
          int index = modelStoreTime.schedule!.indexWhere((element) => element.day.toString() == DateFormat("EEE").format(DateTime.now()));
          if(index != -1){
            schedule = modelStoreTime.schedule![index];
            return InkWell(
              onTap: (){
                Get.to(()=>const SetTimeScreen());
              },
              child: Text(
                schedule.status == true ? "Open (${schedule.startTime} to ${schedule.endTime})" : "Closed",
                style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w400, color: AppTheme.primaryColor,),
              ),
            );
          }
        }
        return Text(
          "Closed",
          style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w400, color: AppTheme.primaryColor,),
        );
      },
    );
  }
}
