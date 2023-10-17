import 'dart:developer';
import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:resvago_vendor/widget/appassets.dart';
import 'package:resvago_vendor/widget/apptheme.dart';
import 'package:resvago_vendor/widget/custom_textfield.dart';
import '../Firebase_service/firebase_service.dart';
import '../controllers/Register_controller.dart';
import '../model/signup_model.dart';
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
  pickImage({required imageSource}) async {
    log(profileImage.path);
    final value = await ImagePicker().pickImage(source: imageSource, imageQuality: 45);
    if (value == null) return;
    profileImage = File(value.path);
    log(profileImage.path.toString());
    setState(() {});
  }

  File categoryFile = File("");
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  FirebaseService firebaseService = FirebaseService();
  // RegisterData? get registerData => widget.resturentData;
  // Future<void> addresturentToFirestore() async {
  //   if(!formKey.currentState!.validate())return;
  //   if(categoryFile.path.isEmpty){
  //     showToast("Please select category image");
  //     return;
  //   }
  //
  //   String imageUrl = categoryFile.path;
  //   if (!categoryFile.path.contains("https")) {
  //     if (resturentData != null) {
  //       Reference gg = FirebaseStorage.instance.refFromURL(categoryFile.path);
  //       await gg.delete();
  //     }
  //     UploadTask uploadTask = FirebaseStorage.instance
  //         .ref("categoryImages")
  //         .child(DateTime.now().millisecondsSinceEpoch.toString())
  //         .putFile(categoryFile);
  //
  //     TaskSnapshot snapshot = await uploadTask;
  //     imageUrl = await snapshot.ref.getDownloadURL();
  //   } else {
  //     if (resturentData != null) {
  //       Reference gg = FirebaseStorage.instance.refFromURL(categoryFile.path);
  //       await gg.delete();
  //     }
  //     UploadTask uploadTask = FirebaseStorage.instance
  //         .ref("categoryImages")
  //         .child(DateTime.now().millisecondsSinceEpoch.toString())
  //         .putFile(categoryFile);
  //
  //     TaskSnapshot snapshot = await uploadTask;
  //     imageUrl = await snapshot.ref.getDownloadURL();
  //   }
  //   if (resturentData != null) {
  //     await firebaseService.manageCategoryProduct(
  //       documentReference: widget.collectionReference.doc(resturentData!.docid),
  //       deactivate: resturentData!.deactivate,
  //       description: descriptionController.text.trim(),
  //       docid: resturentData!.docid,
  //       image: imageUrl,
  //       name: kk,
  //       searchName: arrangeNumbers,
  //     );
  //   }
  //   else {
  //     await firebaseService.manageCategoryProduct(
  //         documentReference: widget.collectionReference.doc(DateTime.now().millisecondsSinceEpoch.toString()),
  //         deactivate: null,
  //         description: descriptionController.text.trim(),
  //         docid: DateTime.now().millisecondsSinceEpoch,
  //         image: imageUrl,
  //         name: kk,
  //         searchName: arrangeNumbers,
  //         time: DateTime.now().millisecondsSinceEpoch
  //     );
  //   }
  //   Get.back();
  // }
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F6),
      appBar: backAppBar(title: "Restaurant Registration", context: context, backgroundColor: Colors.white),
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
                        style: GoogleFonts.poppins(color: AppTheme.registortext, fontWeight: FontWeight.w500, fontSize: 15),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      RegisterTextFieldWidget(
                        controller: registerController.restaurantController,
                        // length: 10,
                        validator: RequiredValidator(errorText: 'Please enter your Restaurant Name '),
                        // keyboardType: TextInputType.none,
                        // textInputAction: TextInputAction.next,
                        hint: 'Mac Restaurant',
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        "Category",
                        style: GoogleFonts.poppins(color: AppTheme.registortext, fontWeight: FontWeight.w500, fontSize: 15),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      RegisterTextFieldWidget(
                        controller: registerController.categoryController,
                        // length: 10,
                        validator: RequiredValidator(errorText: 'Please enter your Category '),
                        // keyboardType: TextInputType.number,
                        // textInputAction: TextInputAction.next,
                        hint: 'Veg Restaurant',
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        "Email",
                        style: GoogleFonts.poppins(color: AppTheme.registortext, fontWeight: FontWeight.w500, fontSize: 15),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      RegisterTextFieldWidget(
                        controller: registerController.emailController,
                        // length: 10,
                        validator: MultiValidator([
                          RequiredValidator(errorText: 'Please enter your email'),
                          EmailValidator(errorText: 'Enter a valid email address'),
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
                        style: GoogleFonts.poppins(color: AppTheme.registortext, fontWeight: FontWeight.w500, fontSize: 15),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      RegisterTextFieldWidget(
                        controller: registerController.mobileController,
                        length: 10,
                        validator: RequiredValidator(errorText: 'Please enter your Mobile Number '),
                        keyboardType: TextInputType.number,
                        // textInputAction: TextInputAction.next,
                        hint: '987-654-3210',
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        "Address",
                        style: GoogleFonts.poppins(color: AppTheme.registortext, fontWeight: FontWeight.w500, fontSize: 15),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      RegisterTextFieldWidget(
                        controller: registerController.addressController,
                        // length: 10,
                        validator: RequiredValidator(errorText: 'Please enter your Address '),
                        keyboardType: TextInputType.streetAddress,
                        // textInputAction: TextInputAction.next,
                        hint: 'Street, Zip Code, City',
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        "Password",
                        style: GoogleFonts.poppins(color: AppTheme.registortext, fontWeight: FontWeight.w500, fontSize: 15),
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
                                : const Icon(Icons.visibility, color: Color(0xFF8487A1))),
                        controller: registerController.passwordController,
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
                        "Confirm Password",
                        style: GoogleFonts.poppins(color: AppTheme.registortext, fontWeight: FontWeight.w500, fontSize: 15),
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
                                : const Icon(Icons.visibility, color: Color(0xFF8487A1))),
                        controller: registerController.confirmPassController,
                        // length: 10,
                        obscureText: obscureText3,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter your Confirm password';
                          }
                          if (value.toString() == registerController.passwordController.text) {
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
                        padding: const EdgeInsets.only(left: 40, right: 40, bottom: 10),
                        color: showValidationImg == false ? const Color(0xFFFAAF40) : Colors.red,
                        dashPattern: const [6],
                        strokeWidth: 1,
                        child: InkWell(
                          onTap: () {
                            showPickImageSheet();
                          },
                          child: profileImage.path != ""
                              ? Stack(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Colors.white,
                                        image: DecorationImage(image: FileImage(profileImage), fit: BoxFit.fill),
                                      ),
                                      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                                      width: double.maxFinite,
                                      height: 180,
                                      alignment: Alignment.center,
                                    ),
                                  ],
                                )
                              : Container(
                                  padding: const EdgeInsets.only(top: 10),
                                  margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
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
                                        style: TextStyle(fontSize: 16, color: Colors.black54),
                                        textAlign: TextAlign.center,
                                      ),
                                      const SizedBox(
                                        height: 15,
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
                                  unselectedWidgetColor: showValidation == false ? const Color(0xFF64646F) : Colors.red),
                              child: Checkbox(
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                  value: value,
                                  activeColor: const Color(0xFF355EB3),
                                  onChanged: (newValue) {
                                    setState(() {
                                      value = newValue!;
                                      checkboxColor.value = !newValue;
                                    });
                                  }),
                            ),
                          ),
                          const Text('I do not wish to receive via sms form This app',
                              style: TextStyle(fontWeight: FontWeight.w300, fontSize: 13, color: Color(0xFF64646F))),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      CommonButtonBlue(
                        onPressed: () {
                          if (_formKeySignup.currentState!.validate() && value == true && showValidationImg == true) {
                            Get.toNamed(MyRouters.thankYouScreen);
                          } else {
                            showValidation = true;
                            showValidationImg = true;
                            setState(() {});
                          }
                        },
                        title: 'APPLY',
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

  showPickImageSheet() {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        title: const Text(
          'Select Image',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: AppTheme.primaryColor),
        ),
        // message: const Text('Message'),
        cancelButton: CupertinoActionSheetAction(
          child: const Text('Cancel'),
          onPressed: () {
            Navigator.of(context, rootNavigator: true).pop("Cancel");
          },
        ),
        actions: <CupertinoActionSheetAction>[
          CupertinoActionSheetAction(
            child: const Text('Gallery'),
            onPressed: () {
              pickImage(imageSource: ImageSource.gallery);
              Navigator.pop(context);
            },
          ),
          CupertinoActionSheetAction(
            child: const Text('Camera'),
            onPressed: () {
              pickImage(imageSource: ImageSource.camera);
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
