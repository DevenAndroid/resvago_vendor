import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:resvago_vendor/screen/Promo_code_list.dart';
import 'package:resvago_vendor/utils/helper.dart';
import 'package:resvago_vendor/widget/apptheme.dart';
import 'package:resvago_vendor/widget/custom_textfield.dart';
import '../Firebase_service/firebase_service.dart';
import '../controllers/Register_controller.dart';
import '../model/profile_model.dart';
import '../widget/common_text_field.dart';

class CreatePromoCodeScreen extends StatefulWidget {
  final bool isEditMode;
  final String? promoCodeName;
  final String? code;
  final String? discount;
  final String? startDate;
  final String? endDate;
  final String? maxDiscount;
  final String? documentId;

  const CreatePromoCodeScreen({
    super.key,
    required this.isEditMode,
    this.promoCodeName,
    this.code,
    this.discount,
    this.maxDiscount,
    this.startDate,
    this.endDate,
    this.documentId,
  });

  @override
  State<CreatePromoCodeScreen> createState() => _CreatePromoCodeScreenState();
}

class _CreatePromoCodeScreenState extends State<CreatePromoCodeScreen> {
  final _formKeySignup = GlobalKey<FormState>();
  final registerController = Get.put(RegisterController());
  TextEditingController startDateController = TextEditingController();
  TextEditingController endDateController = TextEditingController();
  TextEditingController promocodenameController = TextEditingController();
  TextEditingController codeController = TextEditingController();
  TextEditingController discountController = TextEditingController();
  TextEditingController maxDiscountController = TextEditingController();
  DateTime? selectedStartDateTime;
  DateTime? selectedEndDateTIme;
  bool showValidation = false;
  bool showValidationImg = false;
  final DateFormat selectedDateFormat = DateFormat("dd-MMM-yyyy");
  pickDate({required Function(DateTime gg) onPick, DateTime? initialDate, DateTime? firstDate, DateTime? lastDate}) async {
    DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: initialDate ?? DateTime.now(),
        firstDate: firstDate ?? DateTime.now(),
        lastDate: lastDate ?? DateTime(2101),
        initialEntryMode: DatePickerEntryMode.calendarOnly);
    if (pickedDate == null) return;
    onPick(pickedDate);
    // updateValues();
  }

  FirebaseService firebaseService = FirebaseService();

  Future<void> addCouponFirestore() async {
    try {
      if (widget.isEditMode) {
        FirebaseFirestore.instance.collection('Coupon_data').doc(widget.documentId).update({
          "promoCodeName": promocodenameController.text,
          "code": codeController.text,
          "maxDiscount": int.parse(maxDiscountController.text.trim()),
          "discount": discountController.text,
          "startDate": startDateController.text,
          "endDate": endDateController.text,
        }).then((value) {
          Get.back();
          Fluttertoast.showToast(msg: 'Code is Updated');
        });
      } else {
        firebaseService
            .manageCouponCode(
          promoCodeName: promocodenameController.text.trim(),
          code: codeController.text.trim(),
          maxDiscount: int.parse(maxDiscountController.text.trim()),
          discount: discountController.text.trim(),
          startDate: startDateController.text.trim(),
          endDate: endDateController.text.trim(),
          userName: profileData!.restaurantName,
        )
            .then((value) {
          Get.back();
          Fluttertoast.showToast(msg: 'Code is created');
        });
      }
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
  }

  ProfileData? profileData;
  getVendorUsers() {
    FirebaseFirestore.instance.collection("vendor_users").doc(FirebaseAuth.instance.currentUser!.uid).get().then((value) {
      if (value.exists) {
        var data = value.data();
        if (data != null) {
          profileData = ProfileData.fromJson(data);
          setState(() {});
        }
      }

      setState(() {});
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getVendorUsers();
    promocodenameController.text = widget.promoCodeName ?? "";
    codeController.text = widget.code ?? "";
    discountController.text = widget.discount ?? "";
    startDateController.text = widget.startDate ?? "";
    endDateController.text = widget.endDate ?? "";
    maxDiscountController.text = widget.maxDiscount ?? "";
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F6),
      appBar: backAppBar(
          title: widget.isEditMode == true ? "Update promo code".tr : "Create promo code".tr,
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
                        "Promo Code Name".tr,
                        style: GoogleFonts.poppins(color: AppTheme.registortext, fontWeight: FontWeight.w500, fontSize: 15),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      RegisterTextFieldWidget(
                        controller: promocodenameController,
                        validator: RequiredValidator(errorText: 'Please enter your Promo Code Name'.tr).call,
                        hint: 'Sunday Code'.tr,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        "Code".tr,
                        style: GoogleFonts.poppins(color: AppTheme.registortext, fontWeight: FontWeight.w500, fontSize: 15),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      RegisterTextFieldWidget(
                        controller: codeController,
                        validator: RequiredValidator(errorText: 'Please enter your Code'.tr).call,
                        hint: 'Happy sunday'.tr,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        "Discount %".tr,
                        style: GoogleFonts.poppins(color: AppTheme.registortext, fontWeight: FontWeight.w500, fontSize: 15),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      RegisterTextFieldWidget(
                        digitValue: FilteringTextInputFormatter.allow(RegExp('[0-9.]')),
                        controller: discountController,
                        keyboardType: TextInputType.number,
                        hint: '%',
                        validator: (v) {
                          if (v != null && v.trim().isNotEmpty && (double.tryParse(v.toString()) ?? 0) > 100) {
                            return "Discount should be less than or equal to 100";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        "Max Discount".tr,
                        style: GoogleFonts.poppins(color: AppTheme.registortext, fontWeight: FontWeight.w500, fontSize: 15),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      RegisterTextFieldWidget(
                        digitValue: FilteringTextInputFormatter.allow(RegExp('[0-9.]')),
                        controller: maxDiscountController,
                        keyboardType: TextInputType.number,
                        validator: RequiredValidator(errorText: 'Please enter your Discount'.tr).call,
                        hint: '\$0.00',
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        "Start Date".tr,
                        style: GoogleFonts.poppins(color: AppTheme.registortext, fontWeight: FontWeight.w500, fontSize: 15),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      RegisterTextFieldWidget(
                        readOnly: true,
                        controller: startDateController,
                        onTap: () {
                          pickDate(
                              onPick: (DateTime gg) {
                                startDateController.text = selectedDateFormat.format(gg);
                                selectedStartDateTime = gg;
                              },
                              initialDate: selectedStartDateTime,
                              lastDate: selectedEndDateTIme);
                        },
                        validator: RequiredValidator(errorText: 'Please enter start Date'.tr).call,
                        hint: startDateController.text.isEmpty ? 'Select Start Date'.tr : startDateController.text,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        "End Date".tr,
                        style: GoogleFonts.poppins(color: AppTheme.registortext, fontWeight: FontWeight.w500, fontSize: 15),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      RegisterTextFieldWidget(
                        readOnly: true,
                        controller: endDateController,
                        onTap: () {
                          pickDate(
                              onPick: (DateTime gg) {
                                endDateController.text = selectedDateFormat.format(gg);
                                selectedEndDateTIme = gg;
                              },
                              initialDate: selectedEndDateTIme ?? selectedStartDateTime,
                              firstDate: selectedStartDateTime);
                        },
                        validator: RequiredValidator(errorText: 'Please enter end Date'.tr).call,
                        hint: endDateController.text.isEmpty ? 'Select End Date'.tr : endDateController.text,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      CommonButtonBlue(
                        onPressed: () {
                          if (_formKeySignup.currentState!.validate()) {
                            addCouponFirestore();
                          } else {
                            showValidationImg = true;
                            showValidation = true;
                            setState(() {});
                          }
                        },
                        title: widget.isEditMode == true ? "UPDATE COUPON".tr : 'CREATE COUPON'.tr,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
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
}
