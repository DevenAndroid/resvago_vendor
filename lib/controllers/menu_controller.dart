import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../model/category_model.dart';

class MenuDataController extends GetxController {

  TextEditingController mobileController = TextEditingController();
  TextEditingController restaurantController = TextEditingController();
  TextEditingController categoryController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPassController = TextEditingController();


  FirebaseFirestore firestore = FirebaseFirestore.instance;
  bool isDescendingOrder = true;
  Stream<List<CategoryData>> getCategory() {
    return FirebaseFirestore.instance.collection("resturent").orderBy('time', descending: isDescendingOrder).snapshots().map((querySnapshot) {
      List<CategoryData> resturent = [];
      try {
        for (var doc in querySnapshot.docs) {
          var gg = doc.data();
          resturent.add(CategoryData(
            name: gg['name'],
            description: gg['description'],
            image: gg['image'],
            deactivate: gg['deactivate'] ?? false,
            docid: doc.id,
          ));
        }
      } catch (e) {
        throw Exception(e.toString());
      }
      return resturent;
    });
  }
}