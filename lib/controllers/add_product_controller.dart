import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../Firebase_service/firebase_service.dart';

class AddProductController extends GetxController {
  RxInt refreshInt = 0.obs;
  List<File> galleryImages = [];
  List<File> menuGallery = [];
  bool showValidations = false;
  File categoryFile = File("");

}
