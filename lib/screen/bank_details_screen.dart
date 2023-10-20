import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import 'package:resvago_vendor/screen/reviwe_screen.dart';
import 'package:resvago_vendor/widget/custom_textfield.dart';

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
  RxString selectedCAt = "".obs;
  RxString dropDownValue2 = ''.obs;
  final TextEditingController bankAccountNumber = TextEditingController();
  final TextEditingController accountHolderName = TextEditingController();
  final TextEditingController iFSCCode = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: backAppBar(title: "Bank Details", context: context),
    body:  SingleChildScrollView(
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
              image:  AssetImage(AppAssets.bankDetails),
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
                  child: Obx(() {
                    return Column(
                      children: [

                        SizedBox(
                          height: 50,
                          width: size.width ,
                          child: PopupMenuButton<int>(
                            constraints: const BoxConstraints(maxHeight: 300),
                            position: PopupMenuPosition.under,
                            offset: Offset.fromDirection(1, 1),
                            onSelected: (value) {
                              setState(() {});
                            },
                            // icon: Icon(Icons.keyboard_arrow_down),
                            itemBuilder: (context) => [
                              PopupMenuItem(
                                  child: Column(
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          dropDownValue2.value = 'Kotak Bank';
                                          Get.back();
                                        },
                                        child: const Text('Kotak Bank',
                                            style: TextStyle(
                                                fontSize: 15,
                                                color: Color(0xFF384953),
                                                fontWeight: FontWeight.w300)),
                                      ),
                                    ],
                                  )),
                              PopupMenuItem(
                                  child: Column(
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          setState(() {
                                            dropDownValue2.value = 'SBI Bank';
                                            Get.back();
                                          });
                                        },
                                        child: const Text('SBI Bank',
                                            style: TextStyle(
                                                fontSize: 15,
                                                color: Color(0xFF384953),
                                                fontWeight: FontWeight.w500)),
                                      ),
                                    ],
                                  )),
                            ],
                            child: Container(
                              padding: const EdgeInsets.all(9),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                 color:  Color(0xFF384953).withOpacity(.24)),
                                color: Colors.white
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Center(
                                    child: Text(
                                      dropDownValue2.value.toString().isEmpty
                                          ? "HDFC Bank"
                                          : dropDownValue2.value.toString(),
                                      style: const TextStyle(
                                          fontSize: 15,
                                          color: Color(0xFF384953),
                                          fontWeight: FontWeight.w300),
                                    ),
                                  ),
                                ],
                              ),
                                  // Obx(() {
                                  //   return
                                  // }),
                                  const Spacer(),
                                  const Icon(
                                    Icons.keyboard_arrow_down,
                                    color: Colors.grey,
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        // DropdownButtonFormField(
                        //   decoration: InputDecoration(
                        //     fillColor: Colors.grey.shade50,
                        //     contentPadding:
                        //     const EdgeInsets.symmetric(
                        //         horizontal: 20, vertical: 15),
                        //     // .copyWith(top: maxLines! > 4 ? AddSize.size18 : 0),
                        //     focusedBorder: OutlineInputBorder(
                        //       borderSide: BorderSide(
                        //           color: Colors.grey.shade300),
                        //       borderRadius:
                        //       BorderRadius.circular(10.0),
                        //     ),
                        //     enabledBorder: OutlineInputBorder(
                        //         borderSide: BorderSide(
                        //             color: Colors.grey.shade300),
                        //         borderRadius: const BorderRadius.all(
                        //             Radius.circular(10.0))),
                        //     border: OutlineInputBorder(
                        //         borderSide: BorderSide(
                        //             color: Colors.grey.shade300,
                        //             width: 3.0),
                        //         borderRadius:
                        //         BorderRadius.circular(15.0)),
                        //     enabled: true,
                        //   ),
                        //   isExpanded: true,
                        //   hint: Text(
                        //     'Select account',
                        //     style: TextStyle(
                        //         color: AppTheme.userText,
                        //         fontSize: AddSize.font14),
                        //   ),
                        //   value: selectedCAt.value == ""
                        //       ? null
                        //       : selectedCAt.value,
                        //   items:
                        //       bankListModel.value.data!.banks!
                        //       .toList()
                        //       .map((value) {
                        //     return DropdownMenuItem(
                        //       value: value.id.toString(),
                        //       child: Text(
                        //         value.name.toString(),
                        //         style: const TextStyle(fontSize: 16),
                        //       ),
                        //     );
                        //   }).toList(),
                        //   onChanged: (newValue) {
                        //     setState(() {
                        //       selectedCAt.value = newValue.toString();
                        //     });
                        //     print(selectedCAt.value);
                        //   },
                        // ),
                        SizedBox(
                          height: AddSize.size10,
                        ),
                        RegisterTextFieldWidget(
                          controller:
                              bankAccountNumber,
                          hint: "Bank Account Number",
                          validator: MultiValidator([
                            RequiredValidator(
                                errorText:
                                "Please enter bank account number")
                          ]),
                        ),
                        SizedBox(
                          height: AddSize.size10,
                        ),
                        RegisterTextFieldWidget(
                          controller:
                              accountHolderName,
                          hint: "Account Holder Name",
                          validator: MultiValidator([
                            RequiredValidator(
                                errorText:
                                "Please enter account holder name")
                          ]),
                        ),
                        SizedBox(
                          height: AddSize.size10,
                        ),
                        RegisterTextFieldWidget(
                          controller:
                          iFSCCode,
                          hint: "IFSC Code",
                          validator: MultiValidator([
                            RequiredValidator(
                                errorText: "Please enter IFSC code")
                          ]),
                        ),
                        SizedBox(
                          height: AddSize.size20,
                        ),
                        CommonButtonBlue(title: "ADD ACCOUNT",onPressed: (){
    if (_formKey.currentState!.validate()) {
      Get.to(ReviewScreen());
    }
                        }),

                      ],
                    );
                  }),
                ))
          ],
        ),
      ),
    ),

    );

  }
}
