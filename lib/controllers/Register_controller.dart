import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:resvago_vendor/model/signup_model.dart';

class RegisterController extends GetxController {

  TextEditingController mobileController = TextEditingController();
  TextEditingController restaurantController = TextEditingController();
  TextEditingController categoryController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPassController = TextEditingController();

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  bool isDescendingOrder = true;
  Stream<List<RegisterData>> getUserData() {
    return FirebaseFirestore.instance.collection("vendor_users").orderBy('time', descending: isDescendingOrder).snapshots().map((querySnapshot) {
      List<RegisterData> userData = [];
      try {
        for (var doc in querySnapshot.docs) {
          var getData = doc.data();
          userData.add(RegisterData(
            docid: doc.id,
            restaurantName: getData['restaurantName'],
            address: getData['address'],
            confirmPassword: getData['confirmPassword'],
            category: getData['category'],
            password: getData['password'],
            email: getData['email'],
            image: getData['image'],
            mobileNumber: getData['mobileNumber'],
          ));
        }
      } catch (e) {
        throw Exception(e.toString());
      }
      return userData;
    });
  }
}