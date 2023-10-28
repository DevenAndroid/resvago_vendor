// import 'dart:async';
// import 'dart:convert';
// import 'package:dirise/model/common_modal.dart';
// import 'package:dirise/repository/repository.dart';
// import 'package:dirise/utils/api_constant.dart';
// import 'package:dirise/utils/helper.dart';
// import 'package:dirise/widgets/common_colour.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:get/get.dart';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:resvago_vendor/utils/helper.dart';
// import '../../controller/vendor_controllers/vendor_store_timing.dart';
// import '../../controllers/set_time_controller.dart';
// import '../../helper.dart';
// import '../../widget/apptheme.dart';
//
// class SetTimeScreen extends StatefulWidget {
//   const SetTimeScreen({Key? key}) : super(key: key);
//   static var route = "/setTimeScreen";
//
//   @override
//   State<SetTimeScreen> createState() => _SetTimeScreenState();
// }
//
// class _SetTimeScreenState extends State<SetTimeScreen> {
//   final controller = Get.put(VendorStoreTimingController());
//
//   Timer? debounce;
//
//   makeDelay({required Function(bool gg) nowPerform}) {
//     if (debounce != null) {
//       debounce!.cancel();
//     }
//     debounce = Timer(const Duration(milliseconds: 600), () {
//       nowPerform(true);
//     });
//   }
//
//   updateTime() {
//     Map<String, dynamic> map = {};
//
//     List<String> start = [];
//     List<String> end = [];
//     List<String> status = [];
//
//     controller.modelStoreAvailability.map((item) {
//       start.add(item.startTime.toString().normalTime);
//       end.add(item.endTime.toString().normalTime);
//       status.add(item.status == true ? "1" : "0");
//     });
//     map["start_time"] = start;
//     map["end_time"] = end;
//     map["status"] = status;
//   }
//
//   void _showDialog(Widget child) {
//     showCupertinoModalPopup<void>(
//       context: context,
//       builder: (BuildContext context) => Container(
//         height: 216,
//         padding: const EdgeInsets.only(top: 6.0),
//         margin: EdgeInsets.only(
//           bottom: MediaQuery.of(context).viewInsets.bottom,
//         ),
//         color: CupertinoColors.systemBackground.resolveFrom(context),
//         child: SafeArea(
//           top: false,
//           child: child,
//         ),
//       ),
//     );
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     controller.getTime();
//   }
//
//   @override
//   void dispose() {
//     super.dispose();
//     if (debounce != null) {
//       debounce!.cancel();
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         surfaceTintColor: Colors.white,
//         title: Text('Set Store Time',
//             style: GoogleFonts.poppins(
//               fontSize: 17,
//               fontWeight: FontWeight.w600,
//               color: const Color(0xff423E5E),
//             )),
//         leading: GestureDetector(
//           onTap: () {
//             Get.back();
//             // _scaffoldKey.currentState!.openDrawer();
//           },
//           child: Padding(
//             padding: const EdgeInsets.all(15),
//             child: Image.asset(
//               'assets/icons/backicon.png',
//               height: 20,
//             ),
//           ),
//         ),
//       ),
//       body: Obx(() {
//         if(controller.refreshInt.value > 0){}
//         return controller.modelStoreAvailability.data != null
//             ? ListView(
//           shrinkWrap: true,
//           padding: const EdgeInsets.symmetric(horizontal: 16).copyWith(top: 10),
//           children: [
//             ...controller.modelStoreAvailability.data!
//                 .map((e) => Column(
//               children: [
//                 Container(
//                   decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(10),
//                       border: Border.all(color: AppTheme.primaryColor)),
//                   child: Row(
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     children: [
//                       Theme(
//                         data: ThemeData(
//                             checkboxTheme: CheckboxThemeData(
//                                 shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)))),
//                         child: Checkbox(
//                           activeColor: AppTheme.primaryColor,
//                           checkColor: Colors.white,
//                           value: e.status ?? false,
//                           onChanged: (value) {
//                             e.status = value;
//                             setState(() {});
//                           },
//                         ),
//                       ),
//                       Expanded(
//                         flex: 3,
//                         child: Text(
//                           e.weekDay.toString(),
//                           style: GoogleFonts.poppins(
//                               color: Colors.grey.shade900, fontSize: 14, fontWeight: FontWeight.w400),
//                         ),
//                       ),
//                       Expanded(
//                         flex: 2,
//                         child: GestureDetector(
//                           onTap: () {
//                             if ((e.status ?? false) == false) return;
//                             _showDialog(
//                               CupertinoTimerPicker(
//                                 mode: CupertinoTimerPickerMode.hm,
//                                 initialTimerDuration: e.startTime.toString().durationTime,
//                                 onTimerDurationChanged: (Duration newDuration) {
//                                   makeDelay(nowPerform: (bool v) {
//                                     String hour =
//                                         "${newDuration.inHours < 10 ? "0${newDuration.inHours}" : newDuration.inHours}";
//                                     int minute = newDuration.inMinutes % 60;
//                                     String inMinute = "${minute < 10 ? "0$minute" : minute}";
//                                     e.startTime = "$hour:$inMinute";
//                                     setState(() {});
//                                   });
//                                 },
//                               ),
//                             );
//                           },
//                           child: Row(
//                             children: [
//                               Text(
//                                 e.startTime.toString().normalTime,
//                                 style: GoogleFonts.poppins(
//                                     fontWeight: FontWeight.w500, fontSize: 15, color: Colors.grey.shade700),
//                               ),
//                               const Icon(Icons.keyboard_arrow_down_rounded)
//                             ],
//                           ),
//                         ),
//                       ),
//                       Expanded(
//                         child: Text(
//                           "To",
//                           style: GoogleFonts.poppins(
//                               color: Colors.grey.shade900, fontSize: 14, fontWeight: FontWeight.w400),
//                         ),
//                       ),
//                       Expanded(
//                         flex: 2,
//                         child: GestureDetector(
//                           onTap: () {
//                             if ((e.status ?? false) == false) return;
//                             _showDialog(
//                               CupertinoTimerPicker(
//                                 mode: CupertinoTimerPickerMode.hm,
//                                 initialTimerDuration: e.endTime.toString().durationTime,
//                                 onTimerDurationChanged: (Duration newDuration) {
//                                   makeDelay(nowPerform: (bool v) {
//                                     String hour =
//                                         "${newDuration.inHours < 10 ? "0${newDuration.inHours}" : newDuration.inHours}";
//                                     int minute = newDuration.inMinutes % 60;
//                                     String inMinute = "${minute < 10 ? "0$minute" : minute}";
//                                     e.endTime = "$hour:$inMinute";
//                                     setState(() {});
//                                   });
//                                 },
//                               ),
//                             );
//                           },
//                           child: Row(
//                             children: [
//                               Text(
//                                 e.endTime.toString().normalTime,
//                                 style: GoogleFonts.poppins(
//                                     fontWeight: FontWeight.w500, fontSize: 15, color: Colors.grey.shade700),
//                               ),
//                               const Icon(Icons.keyboard_arrow_down_rounded)
//                             ],
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 const SizedBox(height:15)
//               ],
//             ))
//                 .toList(),
//             ElevatedButton(
//                 onPressed: () {
//                   updateTime();
//                 },
//                 style: ElevatedButton.styleFrom(
//                     backgroundColor: AppTheme.primaryColor,
//                     surfaceTintColor: AppTheme.primaryColor,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12),
//                     )),
//                 child: Padding(
//                   padding: const EdgeInsets.all(14.0),
//                   child: Text(
//                     "Save",
//                     style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white),
//                   ),
//                 ))
//           ],
//         )
//             : const Center(child: CircularProgressIndicator(),);
//       }),
//     );
//   }
// }
