import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:resvago_vendor/model/category_model.dart';
import 'package:resvago_vendor/model/menu_model.dart';
import 'package:resvago_vendor/widget/appassets.dart';
import 'package:resvago_vendor/widget/apptheme.dart';
import 'package:resvago_vendor/widget/custom_textfield.dart';
import '../../Firebase_service/firebase_service.dart';
import '../../helper.dart';
import '../../model/menu_item_modal.dart';
import '../../widget/addsize.dart';
import '../../widget/common_text_field.dart';

class AddMenuScreen extends StatefulWidget {
  const AddMenuScreen({super.key, required this.menuId, this.menuItemData});
  final String menuId;
  final MenuData? menuItemData;
  @override
  State<AddMenuScreen> createState() => _AddMenuScreenState();
}

class _AddMenuScreenState extends State<AddMenuScreen> {
  TextEditingController dishNameController = TextEditingController();
  TextEditingController categoryController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController discountNumberController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  String get menuId => widget.menuId;
  MenuData? get menuItemData => widget.menuItemData;
  String? categoryValue;
  File categoryFile = File("");
  bool delivery = false;
  bool dining = false;
  bool value = false;
  FirebaseService firebaseService = FirebaseService();
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  bool isDescendingOrder = true;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  File profileImage = File("");
  bool showValidation = false;
  bool showValidationImg = false;
  // final menuController = Get.put(MenuDataController());
  var obscureText5 = true;

  void checkMenuInFirestore() async {
    addMenuToFirestore();
  }

  Future<void> addMenuToFirestore() async {
    OverlayEntry loader = Helper.overlayLoader(context);
    Overlay.of(context).insert(loader);
    try {
      List<String> arrangeNumbers = [];
      String kk = dishNameController.text.trim();

      arrangeNumbers.clear();
      for (var i = 0; i < kk.length; i++) {
        arrangeNumbers.add(kk.substring(0, i + 1));
      }
      String imageUrl = categoryFile.path;
      if (!categoryFile.path.contains("https")) {
        if (menuItemData != null) {
          Reference gg = FirebaseStorage.instance.refFromURL(menuItemData!.image.toString());
          await gg.delete();
        }
        UploadTask uploadTask = FirebaseStorage.instance
            .ref("categoryImages")
            .child(DateTime.now().millisecondsSinceEpoch.toString())
            .putFile(categoryFile);

        TaskSnapshot snapshot = await uploadTask;
        imageUrl = await snapshot.ref.getDownloadURL();
      }
      await firebaseService
          .manageMenu(
        menuId: menuId,
        vendorId: FirebaseAuth.instance.currentUser!.uid,
        dishName: dishNameController.text.trim(),
        category: categoryValue,
        price: priceController.text.trim(),
        discount: discountNumberController.text.trim(),
        description: descriptionController.text,
        bookingForDining: dining,
        bookingForDelivery: delivery,
        image: imageUrl,
        time: DateTime.now().millisecondsSinceEpoch,
      )
          .then((value) {
        Get.back();
        Helper.hideLoader(loader);
      });
    } catch (e) {
      Helper.hideLoader(loader);
      showToast(e.toString());
      throw Exception(e.toString());
    }
  }

  List<MenuItemData> menuItemList = [];
  getVendorCategories() {
    FirebaseFirestore.instance.collection("menuItemsList").get().then((value) {
      menuItemList.clear();
      for (var element in value.docs) {
        var gg = element.data();

        menuItemList.add(MenuItemData.fromMap(gg));
      }
      print(value.docs);

      setState(() {});
    });
  }

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      getVendorCategories();
    });
    if (widget.menuItemData == null) return;
    dishNameController.text = widget.menuItemData!.dishName ?? "";
    priceController.text = widget.menuItemData!.price ?? "";
    discountNumberController.text = widget.menuItemData!.discount ?? "";
    descriptionController.text = widget.menuItemData!.description ?? "";
    categoryFile = File(widget.menuItemData!.image ?? "");
    categoryValue = widget.menuItemData!.category ?? "";
    delivery = widget.menuItemData!.bookingForDelivery;
    dining = widget.menuItemData!.bookingForDining;
    log("rhgfhf"+widget.menuItemData!.category);
    log("rhgfhf"+categoryValue.toString());
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F6),
      appBar: backAppBar(title: "Add Menu", context: context, backgroundColor: Colors.white),
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
                        "Dish Name",
                        style: GoogleFonts.poppins(color: AppTheme.registortext, fontWeight: FontWeight.w500, fontSize: 15),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      RegisterTextFieldWidget(
                        controller: dishNameController,
                        validator: RequiredValidator(errorText: 'Please enter your menu name ').call,
                        hint: 'Meat Pasta',
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
                      DropdownButtonFormField<dynamic>(
                        focusColor: Colors.white,
                        isExpanded: true,
                        iconEnabledColor: const Color(0xff97949A),
                        icon: const Icon(Icons.keyboard_arrow_down_rounded),
                        borderRadius: BorderRadius.circular(10),
                        hint: Text(
                          "Select category".tr,
                          style: const TextStyle(color: Color(0xff2A3B40), fontSize: 13, fontWeight: FontWeight.w300),
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
                          contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                          // .copyWith(top: maxLines! > 4 ? AddSize.size18 : 0),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: const Color(0xFF384953).withOpacity(.24)),
                            borderRadius: BorderRadius.circular(6.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: const Color(0xFF384953).withOpacity(.24)),
                              borderRadius: const BorderRadius.all(Radius.circular(6.0))),
                          errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.red.shade800),
                              borderRadius: const BorderRadius.all(Radius.circular(6.0))),
                          border: OutlineInputBorder(
                              borderSide: BorderSide(color: const Color(0xFF384953).withOpacity(.24), width: 3.0),
                              borderRadius: BorderRadius.circular(6.0)),
                        ),
                        value: categoryValue,
                        items: menuItemList.map((items) {
                          return DropdownMenuItem(
                            value: items.name.toString(),
                            child: Text(
                              items.name.toString(),
                              style: TextStyle(color: AppTheme.userText, fontSize: AddSize.font14),
                            ),
                          );
                        }).toList(),
                        onChanged: (newValue) {
                          setState(() {
                            categoryValue = newValue.toString();
                          });
                        },
                        validator: (value) {
                          if (categoryValue == null) {
                            return 'Please select category';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Price",
                        style: GoogleFonts.poppins(color: AppTheme.registortext, fontWeight: FontWeight.w500, fontSize: 15),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      RegisterTextFieldWidget(
                        controller: priceController,
                        validator: MultiValidator([
                          RequiredValidator(errorText: 'Please enter price'),
                        ]).call,
                        keyboardType: TextInputType.number,
                        hint: '\$0.00',
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        "Discount",
                        style: GoogleFonts.poppins(color: AppTheme.registortext, fontWeight: FontWeight.w500, fontSize: 15),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      RegisterTextFieldWidget(
                        controller: discountNumberController,
                        length: 10,
                        // validator: RequiredValidator(errorText: 'Please enter discount value').call,
                        keyboardType: TextInputType.number,
                        hint: '%',
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        "Menu Description",
                        style: GoogleFonts.poppins(color: AppTheme.registortext, fontWeight: FontWeight.w500, fontSize: 15),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      RegisterTextFieldWidget(
                        controller: descriptionController,
                        validator: RequiredValidator(errorText: 'Please enter menu description ').call,
                        keyboardType: TextInputType.streetAddress,
                        hint: 'Menu Description',
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        "Upload images",
                        style: GoogleFonts.poppins(color: AppTheme.registortext, fontWeight: FontWeight.w500, fontSize: 15),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      DottedBorder(
                        borderType: BorderType.RRect,
                        radius: const Radius.circular(4),
                        padding: const EdgeInsets.only(left: 40, right: 40, bottom: 10),
                        color: showValidationImg == false ? const Color(0xFFFAAF40) : Colors.red,
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
                                        image: DecorationImage(image: FileImage(profileImage), fit: BoxFit.fill),
                                      ),
                                      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                                      width: double.maxFinite,
                                      height: 180,
                                      alignment: Alignment.center,
                                      child: Image.file(categoryFile,
                                          errorBuilder: (_, __, ___) =>
                                              Image.network(categoryFile.path, errorBuilder: (_, __, ___) => const SizedBox())),
                                    ),
                                  ],
                                )
                              : Container(
                                  padding: const EdgeInsets.only(top: 8),
                                  margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                                  width: double.maxFinite,
                                  height: 130,
                                  alignment: Alignment.center,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.asset(
                                        AppAssets.gallery,
                                        height: 50,
                                        width: 40,
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      const Text(
                                        'Accepted file types: JPEG, Doc, PDF, PNG',
                                        style: TextStyle(fontSize: 14, color: Color(0xff141C21), fontWeight: FontWeight.w300),
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
                        height: 10,
                      ),
                      Row(
                        children: [
                          Transform.scale(
                            scale: 1,
                            child: Theme(
                              data: ThemeData(
                                  unselectedWidgetColor: showValidation == false ? const Color(0xFF64646F) : Colors.red),
                              child: Checkbox(
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                  value: delivery,
                                  activeColor: const Color(0xFF355EB3),
                                  onChanged: (newValue) {
                                    setState(() {
                                      delivery = !delivery;
                                      log(delivery.toString());
                                      setState(() {});
                                    });
                                  }),
                            ),
                          ),
                          const Text('Delivery',
                              style: TextStyle(fontWeight: FontWeight.w400, fontSize: 14, color: Colors.black)),
                        ],
                      ),
                      Row(
                        children: [
                          Transform.scale(
                            scale: 1,
                            child: Theme(
                              data: ThemeData(
                                  unselectedWidgetColor: showValidation == false ? const Color(0xFF64646F) : Colors.red),
                              child: Checkbox(
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                  value: dining,
                                  activeColor: const Color(0xFF355EB3),
                                  onChanged: (newValue) {
                                    setState(() {
                                      dining = newValue!;
                                      log(dining.toString());
                                      setState(() {});
                                    });
                                  }),
                            ),
                          ),
                          const Text('Dining', style: TextStyle(fontWeight: FontWeight.w400, fontSize: 14, color: Colors.black)),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      CommonButtonBlue(
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            if (delivery == true || dining == true) {
                              if (categoryFile.path != "") {
                                checkMenuInFirestore();
                              } else {
                                Fluttertoast.showToast(msg: 'Please select image');
                              }
                            } else {
                              Fluttertoast.showToast(msg: 'Please select booking type');
                            }
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
