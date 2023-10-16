
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future manageCategoryProduct({
    required DocumentReference documentReference,
    dynamic restaurantName,
    dynamic category,
    dynamic email,
    dynamic docid,
    dynamic mobileNumber,
    dynamic address,
    dynamic password,
    dynamic confirmPassword,
    dynamic image,
  }) async {
    try {
        await documentReference.set({
          "restaurantName": restaurantName,
          "category": category,
          "email": email,
          "docid": docid,
          "mobileNumber": mobileNumber,
          "address": address,
          "password": password,
          "confirmPassword": confirmPassword,
          "image": image,
        });
    } catch (e) {
      throw Exception(e);
    }
  }
}
