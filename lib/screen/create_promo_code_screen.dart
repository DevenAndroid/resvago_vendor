import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:resvago_vendor/screen/Promo_code_list.dart';
import 'package:resvago_vendor/widget/apptheme.dart';
import 'package:resvago_vendor/widget/custom_textfield.dart';
import '../Firebase_service/firebase_service.dart';
import '../controllers/Register_controller.dart';
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
  pickDate(
      {required Function(DateTime gg) onPick,
      DateTime? initialDate,
      DateTime? firstDate,
      DateTime? lastDate}) async {
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
        print('object');
        FirebaseFirestore.instance
            .collection('Coupon_data')
            .doc(widget.documentId)
            .update({
          "promoCodeName": promocodenameController.text,
          "code": codeController.text,
          "cmaxDiscountode": maxDiscountController.text,
          "discount": discountController.text,
          "startDate": startDateController.text,
          "endDate": endDateController.text,
        }).then((value) {
          Get.to(const PromoCodeList());

          Fluttertoast.showToast(msg: 'Code is Updated');
        });
      } else {
        firebaseService
            .manageCouponCode(
                promoCodeName: promocodenameController.text.trim(),
                code: codeController.text.trim(),
                maxDiscount: maxDiscountController.text.trim(),
                discount: discountController.text.trim(),
                startDate: startDateController.text.trim(),
                endDate: endDateController.text.trim())
            .then((value) {
          Get.to(const PromoCodeList());

          Fluttertoast.showToast(msg: 'Code is created');
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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
          title: "Create promo code",
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
                        "Promo Code Name",
                        style: GoogleFonts.poppins(
                            color: AppTheme.registortext,
                            fontWeight: FontWeight.w500,
                            fontSize: 15),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      RegisterTextFieldWidget(
                        controller: promocodenameController,
                        validator: RequiredValidator(
                            errorText: 'Please enter your Promo Code Name '),
                        hint: 'Sunday Code',
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        "Code",
                        style: GoogleFonts.poppins(
                            color: AppTheme.registortext,
                            fontWeight: FontWeight.w500,
                            fontSize: 15),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      RegisterTextFieldWidget(
                        controller: codeController,
                        validator: RequiredValidator(
                            errorText: 'Please enter your Code '),
                        hint: 'Happy sunday',
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        "Discount",
                        style: GoogleFonts.poppins(
                            color: AppTheme.registortext,
                            fontWeight: FontWeight.w500,
                            fontSize: 15),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      RegisterTextFieldWidget(
                        controller: discountController,
                        keyboardType: TextInputType.number,
                        validator: RequiredValidator(
                            errorText: 'Please enter your Discount '),
                        hint: '%',
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        "Max Discount",
                        style: GoogleFonts.poppins(
                            color: AppTheme.registortext,
                            fontWeight: FontWeight.w500,
                            fontSize: 15),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      RegisterTextFieldWidget(
                        controller: maxDiscountController,
                        keyboardType: TextInputType.number,
                        validator: RequiredValidator(
                            errorText: 'Please enter your Discount '),
                        hint: '100',
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        "Start Date",
                        style: GoogleFonts.poppins(
                            color: AppTheme.registortext,
                            fontWeight: FontWeight.w500,
                            fontSize: 15),
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
                                startDateController.text =
                                    selectedDateFormat.format(gg);
                                selectedStartDateTime = gg;
                              },
                              initialDate: selectedStartDateTime,
                              lastDate: selectedEndDateTIme);
                        },
                        validator: RequiredValidator(
                            errorText: 'Please enter start Date '),
                        hint: startDateController.text.isEmpty
                            ? 'Select Start Date'
                            : startDateController.text,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        "End Date",
                        style: GoogleFonts.poppins(
                            color: AppTheme.registortext,
                            fontWeight: FontWeight.w500,
                            fontSize: 15),
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
                                endDateController.text =
                                    selectedDateFormat.format(gg);
                                selectedEndDateTIme = gg;
                              },
                              initialDate:
                                  selectedEndDateTIme ?? selectedStartDateTime,
                              firstDate: selectedStartDateTime);
                        },
                        validator: RequiredValidator(
                            errorText: 'Please enter end Date '),
                        hint: endDateController.text.isEmpty
                            ? 'Select End Date'
                            : endDateController.text,
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
                        title: widget.isEditMode == true?"UPDATE COUPON":'CREATE COUPON',
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
}
