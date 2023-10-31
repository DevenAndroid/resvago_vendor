import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../Firebase_service/firebase_service.dart';

class AddProductController extends GetxController {
  RxInt refreshInt = 0.obs;
  List<File> galleryImages = [];
  List<File> menuGallery = [];
  bool showValidations = false;


  // String? documentId;
  // FirebaseService firebaseService = FirebaseService();
  // addSetStoreTime(mobileNumberController) async {
  //   CollectionReference collection = FirebaseFirestore.instance
  //       .collection('vendor_storeTime')
  //       .doc("+91${mobileNumberController}")
  //       .collection('store_time');
  //   var DocumentReference = collection.doc();
  //
  //    documentId = DocumentReference.id;
  //   for (int i = 0; i < 7; i++) {
  //     collection.add({
  //       'weekdays': 'Mon',
  //       'status': 'true',
  //       'startTime': '09:00',
  //       'endTime': '19:00',
  //     });
  //   }
  // }
}
