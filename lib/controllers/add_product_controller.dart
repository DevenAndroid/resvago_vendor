import 'dart:io';
import 'package:get/get.dart';

class AddProductController extends GetxController {
  RxInt refreshInt = 0.obs;
  List<File> galleryImages = [];
  List<File> menuImages = [];
  bool showValidations = false;
}
