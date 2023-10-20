import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:resvago_vendor/widget/apptheme.dart';
import 'package:resvago_vendor/widget/custom_textfield.dart';
import '../Firebase_service/firebase_service.dart';
import '../controllers/Register_controller.dart';
import '../helper.dart';
import '../widget/common_text_field.dart';

class CreatePromoCodeScreen extends StatefulWidget {
  const CreatePromoCodeScreen({super.key});

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
  DateTime? selectedStartDateTime;
  DateTime? selectedEndDateTIme;
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
    OverlayEntry loader = Helper.overlayLoader(context);
    Overlay.of(context).insert(loader);
    await firebaseService
        .manageCouponCode(
            promoCodeName: startDateController.text.trim(),
            code: promocodenameController.text.trim(),
            discount: codeController.text.trim(),
            startDate: discountController.text.trim(),
            endDate: endDateController.text.trim())
        .then((value) {
      Get.back();
      Helper.hideLoader(loader);
      Fluttertoast.showToast(msg: 'Code is created');
    });
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
                        hint: '10.00',
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
                          addCouponFirestore();
                        },
                        title: 'CREATE COUPON',
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
