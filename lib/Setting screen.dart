import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:resvago_vendor/screen/user_profile.dart';
import 'package:resvago_vendor/utils/helper.dart';
import 'package:resvago_vendor/widget/apptheme.dart';
import 'package:resvago_vendor/widget/common_text_field.dart';
import 'package:resvago_vendor/widget/custom_textfield.dart';
import 'Firebase_service/firebase_service.dart';
import 'controllers/add_product_controller.dart';
import 'helper.dart';
import 'model/profile_model.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  TextEditingController preparationTimeController = TextEditingController();
  TextEditingController averageMealForMemberController = TextEditingController();
  bool state = false;
  bool state1 = false;
  bool state2 = false;
  bool state3 = false;
  bool state4 = false;

  // addSetting() {
  //   FirebaseFirestore.instance.collection('Vendor_Setting').doc(FirebaseAuth.instance.currentUser!.uid).set({
  //     "preparationTime": preparationTimeController.text,
  //     "averageMealForMember": averageMealForMemberController.text,
  //     "setDelivery": state,
  //     "cancellation": state1,
  //     "menuSelection": state2,
  //     "time": DateTime.now(),
  //     "userID": FirebaseAuth.instance.currentUser!.uid,
  //   }).then((value) {
  //     Fluttertoast.showToast(msg: 'Setting Updated');
  //   });
  // }

  // Future<void> getData() async {
  //   final users = FirebaseFirestore.instance.collection('Vendor_Setting').doc(FirebaseAuth.instance.currentUser!.uid);
  //   await users.get().then((value) {
  //     if (value.exists) {
  //       SettingModel model = SettingModel.fromMap(value.data()!);
  //       log(model.setDelivery.toString());
  //       preparationTimeController.text = model.preparationTime ?? "";
  //       averageMealForMemberController.text = model.averageMealForMember ?? "";
  //       state = model.setDelivery!;
  //       state1 = model.cancellation!;
  //       state2 = model.menuSelection!;
  //       setState(() {});
  //     }
  //   });
  // }

  TextEditingController mobileController = TextEditingController();
  TextEditingController restaurantController = TextEditingController();
  TextEditingController categoryController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPassController = TextEditingController();
  TextEditingController oldPasswordController = TextEditingController();
  TextEditingController aboutUsController = TextEditingController();
  TextEditingController latController = TextEditingController();
  TextEditingController longController = TextEditingController();
  String? _address = "";
  Uint8List? pickedFile;
  String fileUrl = "";
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  FirebaseService firebaseService = FirebaseService();
  String googleApikey = "AIzaSyDDl-_JOy_bj4MyQhYbKbGkZ0sfpbTZDNU";
  File categoryFile = File("");
  bool deactivated = false;
  final controller = Get.put(AddProductController());
  Future<void> updateProfileToFirestore() async {
    OverlayEntry loader = Helper.overlayLoader(context);
    Overlay.of(context).insert(loader);
    try {
      List<String> imagesLink = [];
      List<String> menuPhotoLink = [];
      String? imageUrlProfile = kIsWeb ? null : controller.categoryFile.path;
      if (kIsWeb) {
        if (pickedFile != null) {
          UploadTask uploadTask = FirebaseStorage.instance
              .ref("profile_image/${FirebaseAuth.instance.currentUser!.uid}")
              .child("image")
              .putData(pickedFile!);
          TaskSnapshot snapshot = await uploadTask;
          imageUrlProfile = await snapshot.ref.getDownloadURL();
        } else {
          imageUrlProfile = fileUrl;
        }
      } else {
        // if (profileData.image.toString().isNotEmpty) {
        //   Reference gg = FirebaseStorage.instance.refFromURL(profileData.image.toString());
        //   await gg.delete();
        // }
        if (!controller.categoryFile.path.contains("http") && controller.categoryFile.path.isNotEmpty) {
          UploadTask uploadTask = FirebaseStorage.instance
              .ref("profileImage/${FirebaseAuth.instance.currentUser!.uid}")
              .child("image")
              .putFile(controller.categoryFile);
          TaskSnapshot snapshot = await uploadTask;
          imageUrlProfile = await snapshot.ref.getDownloadURL();
        }
      }
      if (!kIsWeb) {
        for (var element in controller.galleryImages.asMap().entries) {
          if (element.value.path.contains("http")) {
            imagesLink.add(element.value.path);
          } else {
            UploadTask uploadTask = FirebaseStorage.instance
                .ref("restaurant_images/${FirebaseAuth.instance.currentUser!.uid}")
                .child("${element.key}image")
                .putFile(element.value);
            TaskSnapshot snapshot = await uploadTask;
            String imageUrl = await snapshot.ref.getDownloadURL();
            imagesLink.add(imageUrl);
          }
        }
        for (var element in controller.menuGallery.asMap().entries) {
          if (element.value.path.contains("http")) {
            menuPhotoLink.add(element.value.path);
          } else {
            UploadTask uploadMenuImage = FirebaseStorage.instance
                .ref("menu_images/${FirebaseAuth.instance.currentUser!.uid}")
                .child("${element.key}image")
                .putFile(element.value);

            TaskSnapshot snapshot1 = await uploadMenuImage;
            String imageUrl1 = await snapshot1.ref.getDownloadURL();
            menuPhotoLink.add(imageUrl1);
          }
        }
      } else {
        for (var element in controller.galleryImagesList1.asMap().entries) {
          if (element.value.localImage != null) {
            UploadTask uploadTask = FirebaseStorage.instance
                .ref("restaurant_images/${FirebaseAuth.instance.currentUser!.uid}")
                .child("${element.key}image")
                .putData(element.value.localImage!);

            TaskSnapshot snapshot = await uploadTask;
            String imageUrl = await snapshot.ref.getDownloadURL();
            imagesLink.add(imageUrl);
          } else {
            imagesLink.add(element.value.imageUrl!);
          }
        }

        for (var element in controller.galleryImagesList2.asMap().entries) {
          if (element.value.localImage != null) {
            UploadTask uploadTask = FirebaseStorage.instance
                .ref("menu_images/${FirebaseAuth.instance.currentUser!.uid}")
                .child("${element.key}image")
                .putData(element.value.localImage!);

            TaskSnapshot snapshot = await uploadTask;
            String imageUrl = await snapshot.ref.getDownloadURL();
            menuPhotoLink.add(imageUrl);
          } else {
            menuPhotoLink.add(element.value.imageUrl!);
          }
        }
      }

      await FirebaseFirestore.instance.collection("vendor_users").doc(FirebaseAuth.instance.currentUser!.uid).update({
        "restaurantName": restaurantController.text.trim(),
        "address": _address,
        "latitude": latController.text,
        "longitude": longController.text,
        "email": emailController.text.trim(),
        "category": categoryController.text.trim(),
        "restaurantImage": imagesLink,
        "menuImage": menuPhotoLink,
        "image": imageUrlProfile,
        "aboutUs": aboutUsController.text.trim(),
        "mobileNumber": mobileController.text.trim(),
        "preparationTime": preparationTimeController.text.trim(),
        "averageMealForMember": averageMealForMemberController.text.trim(),
        "setDelivery": state,
        "cancellation": state1,
        "menuSelection": state2,
        "twoStepVerification": state3,
        "paymentEnabled": state4,
        "userID": FirebaseAuth.instance.currentUser!.uid,
      }).then((value) => showToast("Setting Updated"));
      // Get.back();
      Helpers.hideLoader(loader);
    } catch (e) {
      Helpers.hideLoader(loader);
      throw Exception(e);
    } finally {
      Helpers.hideLoader(loader);
    }
  }

  String code = '';
  ProfileData profileData = ProfileData();
  void fetchData() {
    FirebaseFirestore.instance.collection("vendor_users").doc(FirebaseAuth.instance.currentUser!.uid).get().then((value) {
      if (value.exists) {
        if (value.data() == null) return;
        profileData = ProfileData.fromJson(value.data()!);
        log(profileData.toJson().toString());
        if (!kIsWeb) {
          controller.categoryFile = File(profileData.image ?? "");
        } else {
          fileUrl = profileData.image ?? "";
        }
        mobileController.text = (profileData.mobileNumber ?? "").toString();
        code = (profileData.code ?? "").toString();
        restaurantController.text = profileData.restaurantName.toString();
        categoryController.text = profileData.category.toString();
        emailController.text = profileData.email.toString();
        _address = profileData.address.toString();
        latController.text = profileData.latitude.toString();
        longController.text = profileData.longitude.toString();
        preparationTimeController.text = (profileData.preparationTime ?? "").toString();
        averageMealForMemberController.text = (profileData.averageMealForMember ?? "").toString();
        aboutUsController.text = (profileData.aboutUs ?? "").toString();
        deactivated = profileData.deactivate;
        state = profileData.setDelivery ?? false;
        state1 = profileData.cancellation ?? false;
        state2 = profileData.menuSelection ?? false;
        state3 = profileData.twoStepVerification ?? false;
        state4 = profileData.paymentEnabled ?? false;
        log("aboutUs------${aboutUsController.text}");
        profileData.restaurantImage ??= [];
        controller.galleryImages.clear();
        if (!kIsWeb) {
          for (var element in profileData.restaurantImage!) {
            controller.galleryImages.add(File(element));
            controller.refreshInt.value = DateTime.now().millisecondsSinceEpoch;
          }
        } else {
          for (var element in profileData.restaurantImage!) {
            controller.galleryImagesList1.add(ManageWebImages(imageUrl: element.toString()));
            // controller.galleryFilesUrl1.add(element);
            // controller.refreshInt.value = DateTime.now().millisecondsSinceEpoch;
            // print("erfse${controller.galleryFiles1.length}");
          }
          controller.refreshInt.value = DateTime.now().millisecondsSinceEpoch;
          setState(() {});
        }
        profileData.menuGalleryImages ??= [];
        controller.menuGallery.clear();
        if (!kIsWeb) {
          for (var element in profileData.menuGalleryImages!) {
            controller.menuGallery.add(File(element));
            controller.refreshInt.value = DateTime.now().millisecondsSinceEpoch;
          }
        } else {
          for (var element in profileData.menuGalleryImages!) {
            controller.galleryImagesList2.add(ManageWebImages(imageUrl: element.toString()));
            // controller.galleryFilesUrl.add(element);
            // controller.refreshInt.value = DateTime.now().millisecondsSinceEpoch;
            // print("fuyguh${controller.galleryFiles.length}");
          }
          controller.refreshInt.value = DateTime.now().millisecondsSinceEpoch;
          setState(() {});
        }
        setState(() {});
      }
        setState(() {});
    });
  }

  @override
  void initState() {
    super.initState();
    // getData();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: backAppBar(title: "Setting", context: context),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Row(
                    children: [
                      Text(
                        "Set Delivery",
                        style: GoogleFonts.poppins(color: const Color(0xFF292F45), fontSize: 15, fontWeight: FontWeight.w400),
                      ),
                      const Spacer(),
                      CupertinoSwitch(
                        value: state,
                        activeColor: const Color(0xffFAAF40),
                        onChanged: (value) {
                          state = value;
                          setState(() {});
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Row(
                    children: [
                      Text(
                        "Cancellation",
                        style: GoogleFonts.poppins(color: const Color(0xFF292F45), fontSize: 15, fontWeight: FontWeight.w400),
                      ),
                      const Spacer(),
                      CupertinoSwitch(
                        value: state1,
                        activeColor: const Color(0xffFAAF40),
                        onChanged: (value) {
                          state1 = value;
                          setState(() {});
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Row(
                    children: [
                      Text(
                        "Menu selection",
                        style: GoogleFonts.poppins(color: const Color(0xFF292F45), fontSize: 15, fontWeight: FontWeight.w400),
                      ),
                      const Spacer(),
                      CupertinoSwitch(
                        value: state2,
                        activeColor: const Color(0xffFAAF40),
                        onChanged: (value) {
                          state2 = value;
                          if(state2 == false){
                            state4=false;
                          }
                          setState(() {});
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              if (state2 == true)
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Row(
                      children: [
                        Text(
                          "Payment enable",
                          style: GoogleFonts.poppins(color: const Color(0xFF292F45), fontSize: 15, fontWeight: FontWeight.w400),
                        ),
                        const Spacer(),
                        CupertinoSwitch(
                          value: state4,
                          activeColor: const Color(0xffFAAF40),
                          onChanged: (value) {
                            state4 = value;
                            setState(() {});
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              const SizedBox(
                height: 10,
              ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Row(
                    children: [
                      Text(
                        "Enable 2 step Verification",
                        style: GoogleFonts.poppins(color: const Color(0xFF292F45), fontSize: 15, fontWeight: FontWeight.w400),
                      ),
                      const Spacer(),
                      CupertinoSwitch(
                        value: state3,
                        activeColor: const Color(0xffFAAF40),
                        onChanged: (value) {
                          state3 = value;
                          setState(() {});
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                "Preparation time(min)",
                style: GoogleFonts.poppins(color: AppTheme.registortext, fontWeight: FontWeight.w500, fontSize: 15),
              ),
              const SizedBox(
                height: 10,
              ),
              RegisterTextFieldWidget(
                controller: preparationTimeController,
              // ),
              //   validator: MultiValidator([
              //     RequiredValidator(errorText: 'Please enter your preparation Time'),
              //   ]).call,
              //   keyboardType: TextInputType.number,
                hint: 'Preparation time',
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                "Average meal for 1 Member",
                style: GoogleFonts.poppins(color: AppTheme.registortext, fontWeight: FontWeight.w500, fontSize: 15),
              ),
              const SizedBox(
                height: 10,
              ),
              RegisterTextFieldWidget(
                controller: averageMealForMemberController,
                // validator: MultiValidator([
                //   RequiredValidator(errorText: 'Please enter your average Meal For 1 Member'),
                // ]).call,
                keyboardType: TextInputType.number,
                hint: '\$0.00',
              ),
              const SizedBox(
                height: 130,
              ),
              CommonButtonBlue(
                title: "Submit",
                onPressed: () {
                  updateProfileToFirestore();
                },
              ),
            ],
          ).appPaddingForScreen,
        ),
      ),
    );
  }
}
