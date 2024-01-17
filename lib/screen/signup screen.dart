import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:resvago_vendor/screen/verify_otp_screen.dart';
import 'package:resvago_vendor/utils/helper.dart';
import 'package:resvago_vendor/widget/apptheme.dart';
import 'package:resvago_vendor/widget/custom_textfield.dart';
import '../Firebase_service/firebase_service.dart';
import '../controllers/Register_controller.dart';
import '../helper.dart';
import '../model/category_model.dart';
import '../model/google_places_model.dart';
import '../routers/routers.dart';
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
  final registerController = Get.put(RegisterController());
  var obscureText4 = true;
  var obscureText3 = true;
  RxBool checkboxColor = false.obs;
  bool value = false;
  var obscureText5 = true;
  Rx<File> image = File("").obs;
  List<CategoryData>? categoryList;
  String? categoryValue;
  String? _address = "";
  dynamic latitude = "";
  dynamic longitude = "";
  RxBool showValidation1 = false.obs;
  String code = "+353";

  bool checkValidation(bool bool1, bool2) {
    if (bool1 == true && bool2 == true) {
      return true;
    } else {
      return false;
    }
  }

  TextEditingController restaurantNameController = TextEditingController();
  TextEditingController categoryController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController mobileNumberController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController location = TextEditingController();
  String googleApikey = "AIzaSyDDl-_JOy_bj4MyQhYbKbGkZ0sfpbTZDNU";
  Rx<File> categoryFile = File("").obs;
  Uint8List? pickedFile;

  // File categoryFile = File("");
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  FirebaseService firebaseService = FirebaseService();
  String otp = '';
  void generateOTP() {
    int otpLength = 6;
    Random random = Random();
    String otpCode = '';
    for (int i = 0; i < otpLength; i++) {
      otpCode += random.nextInt(10).toString();
    }
    setState(() {
      otp = otpCode;
      print("gjfkyhgfkfgh" + otp);
    });
  }

  void checkEmailInFirestore() async {
    final QuerySnapshot result =
        await FirebaseFirestore.instance.collection('vendor_users').where('email', isEqualTo: emailController.text).get();
    if (result.docs.isNotEmpty) {
      Fluttertoast.showToast(msg: 'Email already exits');
      return;
    }
    addUserToFirestore();
  }

  Geoflutterfire? geo;

  Future<void> addUserToFirestore() async {
    OverlayEntry loader = Helper.overlayLoader(context);
    Overlay.of(context).insert(loader);
    generateOTP();
    String? fcm = "fcm";
    if (!kIsWeb) {
      fcm = await FirebaseMessaging.instance.getToken();
    }
    try {
      geo = Geoflutterfire();
      GeoFirePoint geoFirePoint =
          geo!.point(latitude: double.tryParse(latitude.toString()) ?? 0, longitude: double.tryParse(longitude.toString()) ?? 0);
      // String? imageUrl;
      // if (kIsWeb) {
      //   UploadTask uploadTask = FirebaseStorage.instance.ref("profileImage}").child("profile_image").putData(pickedFile!);
      //   TaskSnapshot snapshot = await uploadTask;
      //   imageUrl = await snapshot.ref.getDownloadURL();
      // } else {
      //   UploadTask uploadTask = FirebaseStorage.instance
      //       .ref("categoryImages")
      //       .child(DateTime.now().millisecondsSinceEpoch.toString())
      //       .putFile(categoryFile.value);
      //   TaskSnapshot snapshot = await uploadTask;
      //   imageUrl = await snapshot.ref.getDownloadURL();
      // }
      // if (kDebugMode) {
      //   print("got image url.........    $imageUrl");
      // }
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: emailController.text.trim(), password: passwordController.text);
      if (FirebaseAuth.instance.currentUser != null) {
        await firebaseService
            .manageRegisterUsers(
                restaurantName: restaurantNameController.text.trim(),
                // category: categoryController.text.trim(),
                email: emailController.text.trim(),
                // mobileNumber: code + mobileNumberController.text.trim(),
                address: _searchController.text.trim(),
                latitude: selectedPlace!.geometry!.location!.lat.toString(),
                longitude: selectedPlace!.geometry!.location!.lng.toString(),
                password: passwordController.text.trim(),
                confirmPassword: confirmPasswordController.text.trim(),
                // image: imageUrl,
                restaurant_position: geoFirePoint.data.toString(),
                fcm: fcm)
            .then((value) async {
          Helper.hideLoader(loader);
          FirebaseFirestore.instance.collection("send_mail").add({
            "to": emailController.text.trim(),
            "message": {
              "subject": "This is a otp email",
              "html": "Your otp is $otp",
              "text": "asdfgwefddfgwefwn",
            }
          }).then((value) {
            if (!kIsWeb) {
              Fluttertoast.showToast(msg: 'Otp email sent to ${emailController.text.trim()}');
            } else {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text("Otp email sent to ${emailController.text.trim()}"),
              ));
            }
            Get.to(() => OtpVerifyScreen(email: emailController.text, otp: otp));
          });
        }).catchError((e) async {
          showToast(e);
        });
      }
    } catch (e) {
      showToast(e);
      Helper.hideLoader(loader);
      throw Exception(e);
    } finally {
      Helper.hideLoader(loader);
    }
  }

  bool passwordSecure = true;
  bool confirmPasswordSecure = true;
  getVendorCategories() {
    FirebaseFirestore.instance.collection("resturent").where("deactivate", isEqualTo: false).get().then((value) {
      for (var element in value.docs) {
        var gg = element.data();
        categoryList ??= [];
        categoryList!.add(CategoryData.fromMap(gg));
      }
      setState(() {});
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      getVendorCategories();
    });
  }

  final TextEditingController _searchController = TextEditingController();
  GooglePlacesModel? googlePlacesModel;
  Places? selectedPlace;

  Future<void> _searchPlaces(String query) async {
    const cloudFunctionUrl = 'https://us-central1-resvago-ire.cloudfunctions.net/searchPlaces';
    FirebaseFunctions.instance.httpsCallableFromUri(Uri.parse('$cloudFunctionUrl?query=$query')).call().then((value) {
      List<Places> places = [];
      if (value.data != null && value.data['places'] != null) {
        List<dynamic> data = List.from(value.data['places']);
        for (var v in data) {
          places.add(Places.fromJson(v));
        }
      }
      googlePlacesModel = GooglePlacesModel(places: places);
      setState(() {});
    });
  }

  Timer? timer;
  makeDelay({
    required Function() delay,
  }) {
    if (timer != null) timer!.cancel();
    timer = Timer(const Duration(milliseconds: 300), delay);
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F6),
      appBar: backAppBar(title: "Restaurant Registration".tr, context: context, backgroundColor: Colors.white),
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
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
                        "Restaurant Name".tr,
                        style: const TextStyle(color: AppTheme.registortext, fontWeight: FontWeight.w500, fontSize: 15),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      RegisterTextFieldWidget(
                        controller: restaurantNameController,
                        // length: 10,
                        validator: RequiredValidator(errorText: 'Please enter your Restaurant Name'.tr).call,
                        // keyboardType: TextInputType.none,
                        // textInputAction: TextInputAction.next,
                        hint: 'Mac Restaurant',
                      ),
                      // const SizedBox(
                      //   height: 20,
                      // ),
                      // Text(
                      //   "Category".tr,
                      //   style: const TextStyle(color: AppTheme.registortext, fontWeight: FontWeight.w500, fontSize: 15),
                      // ),
                      // const SizedBox(
                      //   height: 10,
                      // ),
                      // if (categoryList != null)
                      //   RegisterTextFieldWidget(
                      //     readOnly: true,
                      //     controller: categoryController,
                      //     length: 10,
                      //     validator: MultiValidator([
                      //       RequiredValidator(errorText: 'Please enter your category'.tr),
                      //     ]).call,
                      //     keyboardType: TextInputType.emailAddress,
                      //     hint: 'Select category',
                      //     onTap: () {
                      //       showDialog(
                      //         context: context,
                      //         builder: (ctx) => AlertDialog(
                      //           content: SizedBox(
                      //             height: 400,
                      //             width: double.maxFinite,
                      //             child: ListView.builder(
                      //               physics: const AlwaysScrollableScrollPhysics(),
                      //               itemCount: categoryList!.length,
                      //               shrinkWrap: true,
                      //               itemBuilder: (BuildContext context, int index) {
                      //                 return InkWell(
                      //                     onTap: () {
                      //                       categoryController.text = categoryList![index].name;
                      //                       Get.back();
                      //                       setState(() {});
                      //                     },
                      //                     child: Padding(
                      //                       padding: const EdgeInsets.symmetric(vertical: 10.0),
                      //                       child: Text(categoryList![index].name),
                      //                     ));
                      //               },
                      //             ),
                      //           ),
                      //         ),
                      //       );
                      //     },
                      //   )
                      // else
                      //   Center(
                      //     child: Text("No Category Available".tr),
                      //   ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        "Address".tr,
                        style: const TextStyle(color: AppTheme.registortext, fontWeight: FontWeight.w500, fontSize: 15),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      RegisterTextFieldWidget(
                        controller: _searchController,
                        validator: MultiValidator([
                          RequiredValidator(errorText: 'Please enter your location'.tr),
                        ]).call,
                        keyboardType: TextInputType.emailAddress,
                        hint: 'Search your location',
                        onChanged: (value) {
                          makeDelay(delay: () {
                            _searchPlaces(value);
                          });
                        },
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      googlePlacesModel != null
                          ? Container(
                              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
                              child: ListView.builder(
                                physics: const AlwaysScrollableScrollPhysics(),
                                itemCount: googlePlacesModel!.places!.length,
                                shrinkWrap: true,
                                itemBuilder: (BuildContext context, int index) {
                                  final item = googlePlacesModel!.places![index];
                                  return InkWell(
                                      onTap: () {
                                        _searchController.text = item.name ?? "";
                                        selectedPlace = item;
                                        googlePlacesModel = null;
                                        setState(() {});
                                        // places = [];
                                        // setState(() {});
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                                        child: Text(item.name ?? ""),
                                      ));
                                },
                              ),
                            )
                          : const SizedBox.shrink(),

                      Text(
                        "Email".tr,
                        style: const TextStyle(color: AppTheme.registortext, fontWeight: FontWeight.w500, fontSize: 15),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      RegisterTextFieldWidget(
                        controller: emailController,
                        // length: 10,
                        validator: MultiValidator([
                          RequiredValidator(errorText: 'Please enter your email'.tr),
                          EmailValidator(errorText: 'Enter a valid email address'.tr),
                        ]).call,
                        keyboardType: TextInputType.emailAddress,
                        // textInputAction: TextInputAction.next,
                        hint: 'Enter your email',
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Password".tr,
                        style: const TextStyle(color: AppTheme.registortext, fontWeight: FontWeight.w500, fontSize: 15),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      RegisterTextFieldWidget(
                        controller: passwordController,
                        // length: 10,
                        obscureText: passwordSecure,
                        suffix: GestureDetector(
                            onTap: () {
                              passwordSecure = !passwordSecure;
                              setState(() {});
                            },
                            child: Icon(
                              passwordSecure ? Icons.visibility_off : Icons.visibility,
                              size: 20,
                              color: Colors.black,
                            )),
                        validator: MultiValidator([
                          RequiredValidator(errorText: 'Please enter your password'),
                          MinLengthValidator(8,
                              errorText: 'Password must be at least 8 characters, with 1 special character & 1 numerical'),
                          PatternValidator(r"(?=.*\W)(?=.*?[#?!@$%^&*-])(?=.*[0-9])",
                              errorText: "Password must be at least with 1 special character & 1 numerical"),
                        ]).call,
                        keyboardType: TextInputType.emailAddress,
                        // textInputAction: TextInputAction.next,
                        hint: 'Enter your password',
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Confirm Password".tr,
                        style: const TextStyle(color: AppTheme.registortext, fontWeight: FontWeight.w500, fontSize: 15),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      RegisterTextFieldWidget(
                        controller: confirmPasswordController,
                        // length: 10,
                        obscureText: confirmPasswordSecure,
                        suffix: GestureDetector(
                            onTap: () {
                              confirmPasswordSecure = !confirmPasswordSecure;
                              setState(() {});
                            },
                            child: Icon(
                              confirmPasswordSecure ? Icons.visibility_off : Icons.visibility,
                              size: 20,
                              color: Colors.black,
                            )),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter your confirm password';
                          }
                          if (value.toString() == passwordController.text) {
                            return null;
                          }
                          return "Confirm password not matching with password";
                        },
                        keyboardType: TextInputType.emailAddress,
                        // textInputAction: TextInputAction.next,
                        hint: 'Enter your confirm password',
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      // IntlPhoneField(
                      //   cursorColor: Colors.black,
                      //   dropdownIcon: const Icon(
                      //     Icons.arrow_drop_down_rounded,
                      //     color: Colors.black,
                      //   ),
                      //   validator: MultiValidator([
                      //     RequiredValidator(errorText: 'Please enter your phone number'.tr),
                      //   ]).call,
                      //   dropdownTextStyle: const TextStyle(color: Colors.black),
                      //   style: const TextStyle(color: Colors.black),
                      //   flagsButtonPadding: const EdgeInsets.all(8),
                      //   dropdownIconPosition: IconPosition.trailing,
                      //   controller: mobileNumberController,
                      //   decoration: InputDecoration(
                      //       hintStyle: const TextStyle(
                      //         color: Color(0xFF384953),
                      //         fontSize: 14,
                      //         // fontFamily: 'poppins',
                      //         fontWeight: FontWeight.w300,
                      //       ),
                      //       hintText: 'Phone Number'.tr,
                      //       // labelStyle: TextStyle(color: Colors.black),
                      //       border: const OutlineInputBorder(
                      //         borderSide: BorderSide(),
                      //       ),
                      //       enabledBorder: const OutlineInputBorder(borderSide: BorderSide(color: Color(0xFF384953))),
                      //       focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: Color(0xFF384953)))),
                      //   initialCountryCode: 'IE',
                      //   keyboardType: TextInputType.number,
                      //   onCountryChanged: (phone) {
                      //     setState(() {
                      //       code = "+${phone.dialCode}";
                      //       log(phone.code.toString());
                      //     });
                      //   },
                      // ),
                      // const SizedBox(
                      //   height: 5,
                      // ),
                      // Text(
                      //   "Address".tr,
                      //   style: TextStyle(color: AppTheme.registortext, fontWeight: FontWeight.w500, fontSize: 15),
                      // ),
                      // const SizedBox(
                      //   height: 10,
                      // ),
                      // // if (kIsWeb)
                      // //   RegisterTextFieldWidget(
                      // //     controller: location,
                      // //     // length: 10,
                      // //     validator: MultiValidator([
                      // //       RequiredValidator(errorText: 'Please enter your address'.tr),
                      // //     ]).call,
                      // //     keyboardType: TextInputType.emailAddress,
                      // //     // textInputAction: TextInputAction.next,
                      // //     hint: 'Enter your address',
                      // //   ),
                      // InkWell(
                      //     onTap: () async {
                      //       var place = await PlacesAutocomplete.show(
                      //           hint: "Location".tr,
                      //           context: context,
                      //           apiKey: googleApikey,
                      //           mode: Mode.overlay,
                      //           types: [],
                      //           strictbounds: false,
                      //           onError: (err) {
                      //             log("error.....   ${err.errorMessage}");
                      //           });
                      //       if (place != null) {
                      //         setState(() {
                      //           _address = (place.description ?? "Location").toString();
                      //         });
                      //         final plist = GoogleMapsPlaces(
                      //           apiKey: googleApikey,
                      //           apiHeaders: await const GoogleApiHeaders().getHeaders(),
                      //         );
                      //         if (kDebugMode) {
                      //           print(plist);
                      //         }
                      //         String placeid = place.placeId ?? "0";
                      //         final detail = await plist.getDetailsByPlaceId(placeid);
                      //         final geometry = detail.result.geometry!;
                      //         final lat = geometry.location.lat;
                      //         final lang = geometry.location.lng;
                      //         setState(() {
                      //           _address = (place.description ?? "Location").toString();
                      //           latitude = lat;
                      //           longitude = lang;
                      //           if (kDebugMode) {
                      //             print("Address iss...$_address");
                      //           }
                      //         });
                      //       }
                      //     },
                      //     child: Column(
                      //       crossAxisAlignment: CrossAxisAlignment.start,
                      //       children: [
                      //         Container(
                      //             height: 55,
                      //             decoration: BoxDecoration(
                      //                 border: Border.all(
                      //                     color: !checkValidation(showValidation1.value, _address == "")
                      //                         ? Colors.grey.shade300
                      //                         : Colors.red),
                      //                 borderRadius: BorderRadius.circular(5.0),
                      //                 color: Colors.white),
                      //             // width: MediaQuery.of(context).size.width - 40,
                      //             child: ListTile(
                      //               leading: const Icon(Icons.location_on),
                      //               title: Text(
                      //                 _address ?? "Location".toString(),
                      //                 style: TextStyle(fontSize: AddSize.font14),
                      //               ),
                      //               trailing: const Icon(Icons.search),
                      //               dense: true,
                      //             )),
                      //         checkValidation(showValidation1.value, _address == "")
                      //             ? Padding(
                      //                 padding: EdgeInsets.only(top: AddSize.size5),
                      //                 child: Text(
                      //                   "Location is required".tr,
                      //                   style: TextStyle(color: Colors.red.shade700, fontSize: AddSize.font12),
                      //                 ),
                      //               )
                      //             : const SizedBox()
                      //       ],
                      //     )),
                      //
                      // const SizedBox(
                      //   height: 20,
                      // ),
                      // kIsWeb
                      //     ? DottedBorder(
                      //         borderType: BorderType.RRect,
                      //         radius: const Radius.circular(20),
                      //         padding: const EdgeInsets.only(left: 40, right: 40, bottom: 10),
                      //         color: showValidationImg == false ? const Color(0xFFFAAF40) : Colors.red,
                      //         dashPattern: const [6],
                      //         strokeWidth: 1,
                      //         child: InkWell(
                      //           onTap: () {
                      //             // showActionSheet(context);
                      //             Helper.addFilePicker().then((value) {
                      //               if (kIsWeb) {
                      //                 pickedFile = value;
                      //                 setState(() {});
                      //                 return;
                      //               }
                      //               setState(() {});
                      //               categoryFile.value = value;
                      //               if (kDebugMode) {
                      //                 print("Image----${categoryFile.value}");
                      //               }
                      //             });
                      //           },
                      //           child: pickedFile != null
                      //               ? Stack(
                      //                   children: [
                      //                     Container(
                      //                       decoration: BoxDecoration(
                      //                         borderRadius: BorderRadius.circular(10),
                      //                         color: Colors.white,
                      //                       ),
                      //                       margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                      //                       width: double.maxFinite,
                      //                       height: 180,
                      //                       alignment: Alignment.center,
                      //                       child: kIsWeb
                      //                           ? pickedFile != null
                      //                               ? Image.memory(pickedFile!)
                      //                               : Image.asset(
                      //                                   AppAssets.gallery,
                      //                                   height: 60,
                      //                                   width: 50,
                      //                                 )
                      //                           : Image.memory(pickedFile!,
                      //                               errorBuilder: (_, __, ___) => Image.network(categoryFile.value.path,
                      //                                   errorBuilder: (_, __, ___) => const SizedBox())),
                      //                     ),
                      //                   ],
                      //                 )
                      //               : Container(
                      //                   padding: const EdgeInsets.only(top: 8),
                      //                   margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                      //                   width: double.maxFinite,
                      //                   height: 130,
                      //                   alignment: Alignment.center,
                      //                   child: Column(
                      //                     mainAxisAlignment: MainAxisAlignment.center,
                      //                     children: [
                      //                       Image.asset(
                      //                         AppAssets.gallery,
                      //                         height: 60,
                      //                         width: 50,
                      //                       ),
                      //                       const SizedBox(
                      //                         height: 5,
                      //                       ),
                      //                       Text(
                      //                         'Accepted file types: JPEG, Doc, PDF, PNG'.tr,
                      //                         style: const TextStyle(fontSize: 16, color: Colors.black54),
                      //                         textAlign: TextAlign.center,
                      //                       ),
                      //                       const SizedBox(
                      //                         height: 11,
                      //                       ),
                      //                     ],
                      //                   ),
                      //                 ),
                      //         ),
                      //       )
                      //     : DottedBorder(
                      //         borderType: BorderType.RRect,
                      //         radius: const Radius.circular(20),
                      //         padding: const EdgeInsets.only(left: 40, right: 40, bottom: 10),
                      //         color: showValidationImg == false ? const Color(0xFFFAAF40) : Colors.red,
                      //         dashPattern: const [6],
                      //         strokeWidth: 1,
                      //         child: InkWell(
                      //           onTap: () {
                      //             showActionSheet(context);
                      //             // Helper.addFilePicker().then((value) {
                      //             //   categoryFile.value = value;
                      //             //   print("Image----${categoryFile.value}");
                      //             // });
                      //           },
                      //           child: categoryFile.value.path != ""
                      //               ? Obx(() {
                      //                   return Stack(
                      //                     children: [
                      //                       Container(
                      //                         decoration: BoxDecoration(
                      //                           borderRadius: BorderRadius.circular(10),
                      //                           color: Colors.white,
                      //                         ),
                      //                         margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                      //                         width: double.maxFinite,
                      //                         height: 180,
                      //                         alignment: Alignment.center,
                      //                         child: Image.file(categoryFile.value,
                      //                             errorBuilder: (_, __, ___) => Image.network(categoryFile.value.path,
                      //                                 errorBuilder: (_, __, ___) => const SizedBox())),
                      //                       ),
                      //                     ],
                      //                   );
                      //                 })
                      //               : Container(
                      //                   padding: const EdgeInsets.only(top: 8),
                      //                   margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                      //                   width: double.maxFinite,
                      //                   height: 130,
                      //                   alignment: Alignment.center,
                      //                   child: Column(
                      //                     mainAxisAlignment: MainAxisAlignment.center,
                      //                     children: [
                      //                       Image.asset(
                      //                         AppAssets.gallery,
                      //                         height: 60,
                      //                         width: 50,
                      //                       ),
                      //                       const SizedBox(
                      //                         height: 5,
                      //                       ),
                      //                       Text(
                      //                         'Accepted file types: JPEG, Doc, PDF, PNG'.tr,
                      //                         style: const TextStyle(fontSize: 16, color: Colors.black54),
                      //                         textAlign: TextAlign.center,
                      //                       ),
                      //                       const SizedBox(
                      //                         height: 11,
                      //                       ),
                      //                     ],
                      //                   ),
                      //                 ),
                      //         ),
                      //       ),
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
                                      setState(() {});
                                    });
                                  }),
                            ),
                          ),
                          Expanded(
                              child: RichText(
                            overflow: TextOverflow.clip,
                            textAlign: TextAlign.end,
                            textDirection: TextDirection.rtl,
                            softWrap: true,
                            text: TextSpan(
                              text: 'Yes I understand and agree to the'.tr,
                              style: const TextStyle(color: Colors.black),
                              children: <TextSpan>[
                                TextSpan(
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            // Return the dialog box widget
                                            return AlertDialog(
                                              title: Text('Terms And Conditions'.tr),
                                              content: Text(
                                                  'Terms and conditions are part of a contract that ensure parties understand their contractual rights and obligations. Parties draft them into a legal contract, also called a legal agreement, in accordance with local, state, and federal contract laws. They set important boundaries that all contract principals must uphold.'
                                                  'Several contract types utilize terms and conditions. When there is a formal agreement to create with another individual or entity, consider how you would like to structure your deal and negotiate the terms and conditions with the other side before finalizing anything. This strategy will help foster a sense of importance and inclusion on all sides.'.tr),
                                              actions: const <Widget>[],
                                            );
                                          },
                                        );
                                      },
                                    text: ' Terms And Conditions'.tr,
                                    style: const TextStyle(fontWeight: FontWeight.normal, color: Colors.red)),
                              ],
                            ),
                          )),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      CommonButtonBlue(
                        onPressed: () async {
                          if (formKey.currentState!.validate() && value) {
                            checkEmailInFirestore();
                            await FirebaseAuth.instance.signOut();
                          } else {
                            showToast('Please accept terms and condition');
                            showValidationImg = true;
                            showValidation = true;
                            setState(() {});
                          }
                        },
                        title: 'Signup'.tr,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Already Have an Account?".tr,
                            style: GoogleFonts.poppins(color: Colors.black, fontWeight: FontWeight.w600, fontSize: 15),
                          ),
                          SizedBox(width: 5,),
                          InkWell(
                            onTap: () {
                              Get.back();
                            },
                            child: Text(
                              'Login'.tr,
                              style:
                                  GoogleFonts.poppins(color: AppTheme.primaryColor, fontWeight: FontWeight.w600, fontSize: 15),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              )
            ],
          ).appPaddingForScreen,
        ),
      ),
    );
  }



  void showActionSheet(BuildContext context) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        title: Text(
          'Select Picture from'.tr,
          style: const TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w600),
        ),
        actions: <CupertinoActionSheetAction>[
          CupertinoActionSheetAction(
            onPressed: () {
              Helper.addImagePicker(imageSource: ImageSource.camera, imageQuality: 30).then((value) async {
                // CroppedFile? croppedFile = await ImageCropper().cropImage(
                //   sourcePath: value.path,
                //   aspectRatioPresets: [
                //     CropAspectRatioPreset.square,
                //     CropAspectRatioPreset.ratio3x2,
                //     CropAspectRatioPreset.original,
                //     CropAspectRatioPreset.ratio4x3,
                //     CropAspectRatioPreset.ratio16x9
                //   ],
                //   uiSettings: [
                //     AndroidUiSettings(
                //         toolbarTitle: 'Cropper',
                //         toolbarColor: Colors.deepOrange,
                //         toolbarWidgetColor: Colors.white,
                //         initAspectRatio: CropAspectRatioPreset.original,
                //         lockAspectRatio: false),
                //     IOSUiSettings(
                //       title: 'Cropper',
                //     ),
                //     WebUiSettings(
                //       context: context,
                //     ),
                //   ],
                // );
                if (value != null) {
                  categoryFile.value = File(value.path);
                  setState(() {});
                }
                Get.back();
              });
            },
            child: Text("Camera".tr),
          ),
          CupertinoActionSheetAction(
            onPressed: () {
              Helper.addImagePicker(imageSource: ImageSource.gallery, imageQuality: 30).then((value) async {
                // CroppedFile? croppedFile = await ImageCropper().cropImage(
                //   sourcePath: value.path,
                //   aspectRatioPresets: [
                //     CropAspectRatioPreset.square,
                //     CropAspectRatioPreset.ratio3x2,
                //     CropAspectRatioPreset.original,
                //     CropAspectRatioPreset.ratio4x3,
                //     CropAspectRatioPreset.ratio16x9
                //   ],
                //   uiSettings: [
                //     AndroidUiSettings(
                //         toolbarTitle: 'Cropper',
                //         toolbarColor: Colors.deepOrange,
                //         toolbarWidgetColor: Colors.white,
                //         initAspectRatio: CropAspectRatioPreset.original,
                //         lockAspectRatio: false),
                //     IOSUiSettings(
                //       title: 'Cropper',
                //     ),
                //     WebUiSettings(
                //       context: context,
                //     ),
                //   ],
                // );
                if (value != null) {
                  categoryFile.value = File(value.path);
                  setState(() {});
                }
                Get.back();
              });
            },
            child: Text('Gallery'.tr),
          ),
          CupertinoActionSheetAction(
            isDestructiveAction: true,
            onPressed: () {
              Get.back();
            },
            child: Text('Cancel'.tr),
          ),
        ],
      ),
    );
  }
}
