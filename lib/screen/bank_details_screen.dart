import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import 'package:resvago_vendor/helper.dart';
import 'package:resvago_vendor/utils/helper.dart';
import 'package:resvago_vendor/widget/custom_textfield.dart';

import '../model/bankdetails_model.dart';
import '../widget/addsize.dart';
import '../widget/appassets.dart';
import '../widget/apptheme.dart';
import '../widget/common_text_field.dart';

class BankDetailsScreen extends StatefulWidget {
  const BankDetailsScreen({super.key});

  @override
  State<BankDetailsScreen> createState() => _BankDetailsScreenState();
}

class _BankDetailsScreenState extends State<BankDetailsScreen> {
  final TextEditingController bankAccountNumber = TextEditingController();
  final TextEditingController accountHolderName = TextEditingController();
  final TextEditingController iFSCCode = TextEditingController();
  final TextEditingController bankName = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  addbankToFirebase() {
    FirebaseFirestore.instance
        .collection('BankDetails')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .set({
      "bankName": bankName.text,
      "bankAccountNumber": bankAccountNumber.text,
      "accountHolderName": accountHolderName.text,
      "ifscCode": iFSCCode.text,
      "userID" : FirebaseAuth.instance.currentUser!.uid
    }).then((value) {
      showToast("Bnak details Added");
    });
  }

  Future<void> getBankData() async {
    final users = FirebaseFirestore.instance.collection('BankDetails').doc(FirebaseAuth.instance.currentUser!.uid);
    await users.get().then((value) {
      if(value.exists){
        BankData model = BankData.fromMap(value.data()!);
        bankAccountNumber.text = model.bankAccountNumber ?? "";
        bankName.text = model.bankName ?? "";
        accountHolderName.text = model.accountHolderName ?? "";
        iFSCCode.text = model.ifscCode ?? "";

        setState(() {

        });
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getBankData();
  }
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: backAppBar(title: "Bank Details".tr, context: context),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: AddSize.size45,
              ),
              Image(
                height: AddSize.size150,
                width: AddSize.screenWidth,
                image: AssetImage(AppAssets.bankDetails),
              ),
              SizedBox(
                height: AddSize.size45,
              ),
              Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: AppTheme.backgroundcolor),
                  child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: AddSize.padding10,
                          vertical: AddSize.padding10),
                      child: Column(
                        children: [
                          RegisterTextFieldWidget(
                            controller: bankAccountNumber,
                            hint: "HDFC Bank".tr,
                            validator: MultiValidator([
                              RequiredValidator(
                                  errorText: "Please enter bank account Name".tr)
                            ]).call,
                          ),
                          SizedBox(
                            height: AddSize.size10,
                          ),
                          RegisterTextFieldWidget(
                            controller: bankName,
                            keyboardType: TextInputType.number,
                            hint: "Bank Account Number".tr,
                            validator: MultiValidator([
                              RequiredValidator(
                                  errorText: "Please enter bank account number".tr)
                            ]).call,
                          ),
                          SizedBox(
                            height: AddSize.size10,
                          ),
                          RegisterTextFieldWidget(
                            controller: accountHolderName,
                            hint: "Account Holder Name".tr,
                            validator: MultiValidator([
                              RequiredValidator(
                                  errorText: "Please enter account holder name".tr)
                            ]).call,
                          ),
                          SizedBox(
                            height: AddSize.size10,
                          ),
                          RegisterTextFieldWidget(
                            controller: iFSCCode,
                            hint: "IFSC Code".tr,
                            validator: MultiValidator([
                              RequiredValidator(
                                  errorText: "Please enter IFSC code".tr)
                            ]).call,
                          ),
                          SizedBox(
                            height: AddSize.size20,
                          ),
                          CommonButtonBlue(
                              title: "ADD ACCOUNT".tr,
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  addbankToFirebase();
                                }
                              }),
                        ],
                      )))
            ],
          ).appPaddingForScreen,
        ),
      ),
    );
  }
}
