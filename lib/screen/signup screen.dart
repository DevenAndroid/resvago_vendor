import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:resvago_vendor/widget/appassets.dart';
import 'package:resvago_vendor/widget/apptheme.dart';
import 'package:resvago_vendor/widget/custom_textfield.dart';
import '../Firebase_service/firebase_service.dart';
import '../controllers/Register_controller.dart';
import '../helper.dart';
import '../model/category_model.dart';
import '../routers/routers.dart';
import '../widget/addsize.dart';
import '../widget/common_text_field.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
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
  List<CategoryData>? categoryList;
  String? categoryValue;

  TextEditingController restaurantNameController = TextEditingController();
  TextEditingController categoryController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController mobileNumberController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  File categoryFile = File("");
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  FirebaseService firebaseService = FirebaseService();

  void checkEmailInFirestore() async {
    final QuerySnapshot result = await FirebaseFirestore.instance
        .collection('vendor_users')
        .where('email', isEqualTo: emailController.text)
        .where('mobileNumber', isEqualTo: mobileNumberController.text)
        .get();

    if (result.docs.isNotEmpty) {
      Fluttertoast.showToast(msg: 'Email already exits');
    } else {
      addUserToFirestore();
    }
  }

  Future<void> addUserToFirestore() async {
    OverlayEntry loader = Helper.overlayLoader(context);
    Overlay.of(context).insert(loader);
    String imageUrl = categoryFile.path;
    UploadTask uploadTask = FirebaseStorage.instance
        .ref("categoryImages")
        .child(DateTime.now().millisecondsSinceEpoch.toString())
        .putFile(categoryFile);

    TaskSnapshot snapshot = await uploadTask;
    imageUrl = await snapshot.ref.getDownloadURL();
    await firebaseService
        .manageRegisterUsers(
      restaurantName: restaurantNameController.text.trim(),
      category: categoryController.text.trim(),
      email: emailController.text.trim(),
      mobileNumber: mobileNumberController.text.trim(),
      address: addressController.text.trim(),
      password: passwordController.text.trim(),
      confirmPassword: confirmPasswordController.text.trim(),
      image: imageUrl,
    )
        .then((value) {
      Get.back();
      Helper.hideLoader(loader);
    });
    Get.toNamed(MyRouters.thankYouScreen);
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F6),
      appBar: backAppBar(
          title: "Restaurant Registration",
          context: context,
          backgroundColor: Colors.white),
      body: SingleChildScrollView(
        child: Form(
          key: _formKeySignup,
          child: Column(
            children: [
              const SizedBox(
                height: 8,
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                  padding: const EdgeInsets.all(15),
                  width: size.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Restaurant Name",
                        style: GoogleFonts.poppins(
                            color: AppTheme.registortext,
                            fontWeight: FontWeight.w500,
                            fontSize: 15),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      RegisterTextFieldWidget(
                        controller: restaurantNameController,
                        // length: 10,
                        validator: RequiredValidator(
                            errorText: 'Please enter your Restaurant Name '),
                        // keyboardType: TextInputType.none,
                        // textInputAction: TextInputAction.next,
                        hint: 'Mac Restaurant',
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        "Category",
                        style: GoogleFonts.poppins(
                            color: AppTheme.registortext,
                            fontWeight: FontWeight.w500,
                            fontSize: 15),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      if (categoryList != null)
                        DropdownButtonFormField<dynamic>(
                          focusColor: Colors.white,
                          isExpanded: true,
                          iconEnabledColor: const Color(0xff97949A),
                          icon: const Icon(Icons.keyboard_arrow_down_rounded),
                          borderRadius: BorderRadius.circular(10),
                          hint: Text(
                            "Select category".tr,
                            style: const TextStyle(
                                color: Color(0xff2A3B40),
                                fontSize: 13,
                                fontWeight: FontWeight.w300),
                            textAlign: TextAlign.justify,
                          ),
                          decoration: InputDecoration(
                            focusColor: const Color(0xFF384953),
                            hintStyle: GoogleFonts.poppins(
                              color: const Color(0xFF384953),
                              textStyle: GoogleFonts.poppins(
                                color: const Color(0xFF384953),
                                fontSize: 14,
                                fontWeight: FontWeight.w300,
                              ),
                              fontSize: 14,
                              // fontFamily: 'poppins',
                              fontWeight: FontWeight.w300,
                            ),
                            filled: true,
                            fillColor: Colors.white.withOpacity(.10),
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 15, vertical: 15),
                            // .copyWith(top: maxLines! > 4 ? AddSize.size18 : 0),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color:
                                      const Color(0xFF384953).withOpacity(.24)),
                              borderRadius: BorderRadius.circular(6.0),
                            ),
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: const Color(0xFF384953)
                                        .withOpacity(.24)),
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(6.0))),
                            errorBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.red.shade800),
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(6.0))),
                            border: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: const Color(0xFF384953)
                                        .withOpacity(.24),
                                    width: 3.0),
                                borderRadius: BorderRadius.circular(6.0)),
                          ),
                          value: categoryValue,
                          items: categoryList!.map((items) {
                            return DropdownMenuItem(
                              value: items.name.toString(),
                              child: Text(
                                items.name.toString(),
                                style: TextStyle(
                                    color: AppTheme.userText,
                                    fontSize: AddSize.font14),
                              ),
                            );
                          }).toList(),
                          onChanged: (newValue) {
                            categoryValue = newValue.toString();
                            log(categoryValue.toString());
                            setState(() {});
                          },
                          validator: (value) {
                            if (categoryValue == null) {
                              return 'Please select category';
                            }
                            return null;
                          },
                        )
                      else
                        const Center(
                          child: Text("No Category Available"),
                        ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        "Email",
                        style: GoogleFonts.poppins(
                            color: AppTheme.registortext,
                            fontWeight: FontWeight.w500,
                            fontSize: 15),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      RegisterTextFieldWidget(
                        controller: emailController,
                        // length: 10,
                        validator: MultiValidator([
                          RequiredValidator(
                              errorText: 'Please enter your email'),
                          EmailValidator(
                              errorText: 'Enter a valid email address'),
                        ]),
                        keyboardType: TextInputType.emailAddress,
                        // textInputAction: TextInputAction.next,
                        hint: 'MacRestaurant@gmail.com',
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        "Mobile Number",
                        style: GoogleFonts.poppins(
                            color: AppTheme.registortext,
                            fontWeight: FontWeight.w500,
                            fontSize: 15),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      RegisterTextFieldWidget(
                        controller: mobileNumberController,
                        length: 10,
                        validator: RequiredValidator(
                            errorText: 'Please enter your Mobile Number '),
                        keyboardType: TextInputType.number,
                        // textInputAction: TextInputAction.next,
                        hint: '987-654-3210',
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        "Address",
                        style: GoogleFonts.poppins(
                            color: AppTheme.registortext,
                            fontWeight: FontWeight.w500,
                            fontSize: 15),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      RegisterTextFieldWidget(
                        controller: addressController,
                        // length: 10,
                        validator: RequiredValidator(
                            errorText: 'Please enter your Address '),
                        keyboardType: TextInputType.streetAddress,
                        // textInputAction: TextInputAction.next,
                        hint: 'Street, Zip Code, City',
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        "Password",
                        style: GoogleFonts.poppins(
                            color: AppTheme.registortext,
                            fontWeight: FontWeight.w500,
                            fontSize: 15),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      RegisterTextFieldWidget(
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
                                : const Icon(Icons.visibility,
                                    color: Color(0xFF8487A1))),
                        controller: passwordController,
                        obscureText: obscureText4,
                        // length: 10,
                        validator: MultiValidator([
                          RequiredValidator(
                              errorText: 'Please enter your password'),
                          MinLengthValidator(8,
                              errorText:
                                  'Password must be at least 8 characters, with 1 special character & 1 numerical'),
                          PatternValidator(
                              r"(?=.*\W)(?=.*?[#?!@$%^&*-])(?=.*[0-9])",
                              errorText:
                                  "Password must be at least with 1 special character & 1 numerical"),
                        ]),
                        hint: '************',
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        "Confirm Password",
                        style: GoogleFonts.poppins(
                            color: AppTheme.registortext,
                            fontWeight: FontWeight.w500,
                            fontSize: 15),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      RegisterTextFieldWidget(
                        suffix: GestureDetector(
                            onTap: () {
                              setState(() {
                                obscureText3 = !obscureText3;
                              });
                            },
                            child: obscureText3
                                ? const Icon(
                                    Icons.visibility_off,
                                    color: Color(0xFF8487A1),
                                  )
                                : const Icon(Icons.visibility,
                                    color: Color(0xFF8487A1))),
                        controller: confirmPasswordController,
                        // length: 10,
                        obscureText: obscureText3,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter your Confirm password';
                          }
                          if (value.toString() == passwordController.text) {
                            return null;
                          }
                          return "Confirm password not matching with password";
                        },
                        hint: '************',
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      DottedBorder(
                        borderType: BorderType.RRect,
                        radius: const Radius.circular(20),
                        padding: const EdgeInsets.only(
                            left: 40, right: 40, bottom: 10),
                        color: showValidationImg == false
                            ? const Color(0xFFFAAF40)
                            : Colors.red,
                        dashPattern: const [6],
                        strokeWidth: 1,
                        child: InkWell(
                          onTap: () {
                            showActionSheet(context);
                          },
                          child: categoryFile.path != ""
                              ? Stack(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Colors.white,
                                        image: DecorationImage(
                                            image: FileImage(profileImage),
                                            fit: BoxFit.fill),
                                      ),
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 10, horizontal: 10),
                                      width: double.maxFinite,
                                      height: 180,
                                      alignment: Alignment.center,
                                      child: Image.file(categoryFile,
                                          errorBuilder: (_, __, ___) =>
                                              Image.network(categoryFile.path,
                                                  errorBuilder: (_, __, ___) =>
                                                      SizedBox())),
                                    ),
                                  ],
                                )
                              : Container(
                                  padding: const EdgeInsets.only(top: 8),
                                  margin: const EdgeInsets.symmetric(
                                      vertical: 8, horizontal: 8),
                                  width: double.maxFinite,
                                  height: 130,
                                  alignment: Alignment.center,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.asset(
                                        AppAssets.gallery,
                                        height: 60,
                                        width: 50,
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      const Text(
                                        'Accepted file types: JPEG, Doc, PDF, PNG',
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.black54),
                                        textAlign: TextAlign.center,
                                      ),
                                      const SizedBox(
                                        height: 11,
                                      ),
                                    ],
                                  ),
                                ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          Transform.scale(
                            scale: 1.1,
                            child: Theme(
                              data: ThemeData(
                                  unselectedWidgetColor: showValidation == false
                                      ? const Color(0xFF64646F)
                                      : Colors.red),
                              child: Checkbox(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(4)),
                                  materialTapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                  value: value,
                                  activeColor: const Color(0xFF355EB3),
                                  onChanged: (newValue) {
                                    setState(() {
                                      value = newValue!;
                                      setState(() {});
                                    });
                                  }),
                            ),
                          ),
                          const Text(
                              'I do not wish to receive via sms form This app',
                              style: TextStyle(
                                  fontWeight: FontWeight.w300,
                                  fontSize: 13,
                                  color: Color(0xFF64646F))),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      CommonButtonBlue(
                        onPressed: () {
                          if (_formKeySignup.currentState!.validate() &&
                              categoryFile.path != "" &&
                              value == true) {
                            checkEmailInFirestore();
                          } else {
                            showValidationImg = true;
                            showValidation = true;
                            setState(() {});
                          }
                        },
                        title: 'Save',
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
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
          style: TextStyle(
              color: Colors.black, fontSize: 18, fontWeight: FontWeight.w600),
        ),
        actions: <CupertinoActionSheetAction>[
          CupertinoActionSheetAction(
            onPressed: () {
              Helper.addImagePicker(
                      imageSource: ImageSource.camera, imageQuality: 75)
                  .then((value) async {
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
                  categoryFile = File(croppedFile.path);
                  setState(() {});
                }

                Get.back();
              });
            },
            child: const Text("Camera"),
          ),
          CupertinoActionSheetAction(
            onPressed: () {
              Helper.addImagePicker(
                      imageSource: ImageSource.gallery, imageQuality: 75)
                  .then((value) async {
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
                  categoryFile = File(croppedFile.path);
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
