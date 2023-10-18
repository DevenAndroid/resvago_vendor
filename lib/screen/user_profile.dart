import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:resvago_vendor/model/profile_model.dart';
import 'package:resvago_vendor/widget/apptheme.dart';
import '../Firebase_service/firebase_service.dart';
import '../controllers/Register_controller.dart';
import '../helper.dart';
import '../widget/addsize.dart';
import '../widget/common_text_field.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  File profileImage = File("");
  bool showValidation = false;
  bool showValidationImg = false;
  final _formKeySignup = GlobalKey<FormState>();
  final registerController = Get.put(RegisterController());
  var obscureText4 = true;
  var obscureText3 = true;
  RxBool checkboxColor = false.obs;
  bool value = false;
  var obscureText5 = true;
  Rx<File> image = File("").obs;

  TextEditingController mobileController = TextEditingController();
  TextEditingController restaurantController = TextEditingController();
  TextEditingController categoryController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPassController = TextEditingController();
  TextEditingController oldPasswordController = TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  FirebaseService firebaseService = FirebaseService();

  void showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  "Old Password",
                  style: GoogleFonts.poppins(color: AppTheme.registortext, fontWeight: FontWeight.w500, fontSize: 15),
                ),
                const SizedBox(
                  height: 10,
                ),
                RegisterTextFieldWidget(
                  controller: oldPasswordController,
                  suffix: GestureDetector(
                      onTap: () {
                        setState(() {
                          obscureText4 = !obscureText4;
                        });
                      },
                      child: obscureText4
                          ? const Icon(
                              Icons.visibility_off,
                              color: Color(0xFF8487A1),
                            )
                          : const Icon(Icons.visibility, color: Color(0xFF8487A1))),
                  obscureText: obscureText4,
                  // length: 10,
                  validator: MultiValidator([
                    RequiredValidator(errorText: 'Please enter your password'),
                    MinLengthValidator(8,
                        errorText: 'Password must be at least 8 characters, with 1 special character & 1 numerical'),
                    PatternValidator(r"(?=.*\W)(?=.*?[#?!@$%^&*-])(?=.*[0-9])",
                        errorText: "Password must be at least with 1 special character & 1 numerical"),
                  ]),
                  hint: '************',
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  "New Password",
                  style: GoogleFonts.poppins(color: AppTheme.registortext, fontWeight: FontWeight.w500, fontSize: 15),
                ),
                const SizedBox(
                  height: 10,
                ),
                RegisterTextFieldWidget(
                  controller: passwordController,
                  suffix: GestureDetector(
                      onTap: () {
                        setState(() {
                          obscureText4 = !obscureText4;
                        });
                      },
                      child: obscureText4
                          ? const Icon(
                              Icons.visibility_off,
                              color: Color(0xFF8487A1),
                            )
                          : const Icon(Icons.visibility, color: Color(0xFF8487A1))),
                  obscureText: obscureText4,
                  // length: 10,
                  validator: MultiValidator([
                    RequiredValidator(errorText: 'Please enter your password'),
                    MinLengthValidator(8,
                        errorText: 'Password must be at least 8 characters, with 1 special character & 1 numerical'),
                    PatternValidator(r"(?=.*\W)(?=.*?[#?!@$%^&*-])(?=.*[0-9])",
                        errorText: "Password must be at least with 1 special character & 1 numerical"),
                  ]),
                  hint: '************',
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  "Confirm New Password",
                  style: GoogleFonts.poppins(color: AppTheme.registortext, fontWeight: FontWeight.w500, fontSize: 15),
                ),
                const SizedBox(
                  height: 10,
                ),
                RegisterTextFieldWidget(
                  controller: confirmPassController,
                  suffix: GestureDetector(
                      onTap: () {
                        setState(() {
                          obscureText4 = !obscureText4;
                        });
                      },
                      child: obscureText4
                          ? const Icon(
                              Icons.visibility_off,
                              color: Color(0xFF8487A1),
                            )
                          : const Icon(Icons.visibility, color: Color(0xFF8487A1))),
                  obscureText: obscureText4,
                  // length: 10,
                  validator: MultiValidator([
                    RequiredValidator(errorText: 'Please enter your password'),
                    MinLengthValidator(8,
                        errorText: 'Password must be at least 8 characters, with 1 special character & 1 numerical'),
                    PatternValidator(r"(?=.*\W)(?=.*?[#?!@$%^&*-])(?=.*[0-9])",
                        errorText: "Password must be at least with 1 special character & 1 numerical"),
                  ]),
                  hint: '************',
                ),
                const SizedBox(
                  height: 20,
                ),
                CommonButtonBlue(
                  onPressed: () {
                    updateProfileToFirestore();
                  },
                  title: 'Save',
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void updateProfileToFirestore() {
    FirebaseFirestore.instance.collection("vendor_users").doc(FirebaseAuth.instance.currentUser!.phoneNumber).update({
      "restaurantName": restaurantController.text.trim(),
      "address": addressController.text.trim(),
      "password": passwordController.text.trim(),
      "email": emailController.text.trim(),
      "category": categoryController.text.trim(),
      "image": profileImage.toString(),
      "mobileNumber": mobileController.text.trim(),
      "confirmPassword": confirmPassController.text.trim()
    }).then((value) => Fluttertoast.showToast(msg: "Profile Updated"));
  }

  ProfileData profileData = ProfileData();
  void fetchdata() {
    FirebaseFirestore.instance
        .collection("vendor_users")
        .doc(FirebaseAuth.instance.currentUser!.phoneNumber)
        .get()
        .then((value) {
      if (value.exists) {
        if (value.data() == null) return;
        profileData = ProfileData.fromJson(value.data()!);
        mobileController.text = profileData.mobileNumber.toString();
        restaurantController.text = profileData.restaurantName.toString();
        categoryController.text = profileData.category.toString();
        emailController.text = profileData.email.toString();
        addressController.text = profileData.address.toString();

        setState(() {});
      }
    });
  }

  @override
  void initState() {
    super.initState();
    fetchdata();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F6),
      body: SingleChildScrollView(
        child: Form(
          key: _formKeySignup,
          child: Column(
            children: [
              Container(
                // padding: const EdgeInsets.all(15),
                width: size.width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      children: [
                        Container(
                            padding: const EdgeInsets.only(bottom: 50),
                            clipBehavior: Clip.antiAlias,
                            decoration: BoxDecoration(border: Border.all(color: Colors.white)),
                            child: Image.asset('assets/images/Group.png')),
                        Positioned(
                          top: 90,
                          left: 0,
                          right: 0,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10000),
                                child: Container(
                                  height: 100,
                                  width: 100,
                                  clipBehavior: Clip.antiAlias,
                                  decoration: BoxDecoration(
                                    color: const Color(0xffFAAF40),
                                    border: Border.all(color: const Color(0xff3B5998), width: 6),
                                    borderRadius: BorderRadius.circular(5000),
                                    // color: Colors.brown
                                  ),
                                  child: CachedNetworkImage(
                                    fit: BoxFit.cover,
                                    imageUrl: profileData.image == null ? "image" : profileData.image.toString(),
                                    height: AddSize.size30,
                                    width: AddSize.size30,
                                    errorWidget: (_, __, ___) => const Icon(
                                      Icons.person,
                                      size: 60,
                                    ),
                                    placeholder: (_, __) => const SizedBox(),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          top: 150,
                          left: 210,
                          right: 122,
                          child: Container(
                            height: 30,
                            width: 30,
                            clipBehavior: Clip.antiAlias,
                            decoration: BoxDecoration(
                              color: const Color(0xff04666E),
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: const Icon(
                              Icons.camera_alt,
                              color: Colors.white,
                              size: 15,
                            ),
                          ),
                        )
                      ],
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        profileData.restaurantName == null ? "email" : profileData.restaurantName.toString(),
                        style: GoogleFonts.poppins(color: AppTheme.registortext, fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        profileData.category == null ? "email" : profileData.category.toString(),
                        style: GoogleFonts.poppins(color: Colors.grey, fontWeight: FontWeight.normal, fontSize: 12),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Restaurant Name',
                            style: GoogleFonts.poppins(color: AppTheme.registortext, fontWeight: FontWeight.w500, fontSize: 15),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          RegisterTextFieldWidget(
                            controller: restaurantController,
                            validator: RequiredValidator(errorText: 'Please enter your Restaurant Name '),
                            hint: profileData.restaurantName == null ? "email" : profileData.restaurantName.toString(),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Text(
                            "Category",
                            style:
                                GoogleFonts.poppins(color: AppTheme.registortext, fontWeight: FontWeight.w500, fontSize: 15),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          RegisterTextFieldWidget(
                            controller: categoryController,
                            validator: RequiredValidator(errorText: 'Please enter your Category '),
                            // keyboardType: TextInputType.number,
                            // textInputAction: TextInputAction.next,
                            hint: profileData.category == null ? "email" : profileData.category.toString(),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Text(
                            "Email",
                            style:
                                GoogleFonts.poppins(color: AppTheme.registortext, fontWeight: FontWeight.w500, fontSize: 15),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          RegisterTextFieldWidget(
                            controller: emailController,
                            validator: MultiValidator([
                              RequiredValidator(errorText: 'Please enter your email'),
                              EmailValidator(errorText: 'Enter a valid email address'),
                            ]),
                            keyboardType: TextInputType.emailAddress,
                            // textInputAction: TextInputAction.next,
                            hint: profileData.email == null ? "email" : profileData.email.toString(),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Text(
                            "Mobile Number",
                            style:
                                GoogleFonts.poppins(color: AppTheme.registortext, fontWeight: FontWeight.w500, fontSize: 15),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          RegisterTextFieldWidget(
                            controller: mobileController,
                            length: 10,
                            validator: RequiredValidator(errorText: 'Please enter your Mobile Number '),
                            keyboardType: TextInputType.number,
                            // textInputAction: TextInputAction.next,
                            hint: profileData.mobileNumber == null ? "email" : profileData.mobileNumber.toString(),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Text(
                            "Address",
                            style:
                                GoogleFonts.poppins(color: AppTheme.registortext, fontWeight: FontWeight.w500, fontSize: 15),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          RegisterTextFieldWidget(
                            controller: addressController,
                            validator: RequiredValidator(errorText: 'Please enter your Address '),
                            keyboardType: TextInputType.streetAddress,
                            // textInputAction: TextInputAction.next,
                            hint: profileData.address == null ? "email" : profileData.address.toString(),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          CommonButtonBlue(
                            onPressed: () {
                              updateProfileToFirestore();
                            },
                            title: 'Save',
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void showActionSheet(BuildContext context) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        title: const Text(
          'Select Picture from',
          style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w600),
        ),
        actions: <CupertinoActionSheetAction>[
          CupertinoActionSheetAction(
            onPressed: () {
              Helper.addImagePicker(imageSource: ImageSource.camera, imageQuality: 75).then((value) async {
                CroppedFile? croppedFile = await ImageCropper().cropImage(
                  sourcePath: value.path,
                  aspectRatioPresets: [
                    CropAspectRatioPreset.square,
                    CropAspectRatioPreset.ratio3x2,
                    CropAspectRatioPreset.original,
                    CropAspectRatioPreset.ratio4x3,
                    CropAspectRatioPreset.ratio16x9
                  ],
                  uiSettings: [
                    AndroidUiSettings(
                        toolbarTitle: 'Cropper',
                        toolbarColor: Colors.deepOrange,
                        toolbarWidgetColor: Colors.white,
                        initAspectRatio: CropAspectRatioPreset.original,
                        lockAspectRatio: false),
                    IOSUiSettings(
                      title: 'Cropper',
                    ),
                    WebUiSettings(
                      context: context,
                    ),
                  ],
                );
                if (croppedFile != null) {
                  profileImage = File(croppedFile.path);
                  setState(() {});
                }

                Get.back();
              });
            },
            child: const Text("Camera"),
          ),
          CupertinoActionSheetAction(
            onPressed: () {
              Helper.addImagePicker(imageSource: ImageSource.gallery, imageQuality: 75).then((value) async {
                CroppedFile? croppedFile = await ImageCropper().cropImage(
                  sourcePath: value.path,
                  aspectRatioPresets: [
                    CropAspectRatioPreset.square,
                    CropAspectRatioPreset.ratio3x2,
                    CropAspectRatioPreset.original,
                    CropAspectRatioPreset.ratio4x3,
                    CropAspectRatioPreset.ratio16x9
                  ],
                  uiSettings: [
                    AndroidUiSettings(
                        toolbarTitle: 'Cropper',
                        toolbarColor: Colors.deepOrange,
                        toolbarWidgetColor: Colors.white,
                        initAspectRatio: CropAspectRatioPreset.original,
                        lockAspectRatio: false),
                    IOSUiSettings(
                      title: 'Cropper',
                    ),
                    WebUiSettings(
                      context: context,
                    ),
                  ],
                );
                if (croppedFile != null) {
                  profileImage = File(croppedFile.path);
                  setState(() {});
                }

                Get.back();
              });
            },
            child: const Text('Gallery'),
          ),
          CupertinoActionSheetAction(
            isDestructiveAction: true,
            onPressed: () {
              Get.back();
            },
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }
}
