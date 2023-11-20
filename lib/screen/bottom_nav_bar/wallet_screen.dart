import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:resvago_vendor/widget/app_strings_file.dart';
import 'package:resvago_vendor/widget/appassets.dart';
import 'package:resvago_vendor/widget/common_text_field.dart';
import 'package:resvago_vendor/widget/custom_textfield.dart';

import '../../routers/routers.dart';
import '../../widget/addsize.dart';
import '../../widget/apptheme.dart';

class WalletScreen extends StatefulWidget {
  String back;
  WalletScreen({super.key, required this.back});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  final List<String> moneyList = ["500", "800", "1000"];
  final TextEditingController addMoneyController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: backAppBar(title: AppStrings.withdrawalMoney.tr, context: context,dispose: widget.back),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                    padding: EdgeInsets.all(14),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
                    child: Row(
                      children: [
                        Column(
                          children: [
                            Text(
                              AppStrings.myBalance.tr,
                              style:
                                  GoogleFonts.poppins(color: const Color(0xFF3A3A3A), fontWeight: FontWeight.w400, fontSize: 16),
                            ),
                            Text(
                              "\$2400",
                              style:
                                  GoogleFonts.poppins(color: const Color(0xFF3A3A3A), fontWeight: FontWeight.w600, fontSize: 31),
                            ),
                          ],
                        ),
                        Spacer(),
                        Image.asset(
                          AppAssets.withdrawl,
                          height: 40,
                        )
                      ],
                    ))),
            Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                    padding: EdgeInsets.all(14),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
                    child: Column(
                      children: [
                        TextFormField(
                            keyboardType: TextInputType.number,
                            textAlign: TextAlign.center,
                            style: Theme.of(context)
                                .textTheme
                                .headline5!
                                .copyWith(color: AppTheme.blackcolor, fontWeight: FontWeight.w600, fontSize: AddSize.font24),
                            controller: addMoneyController,
                            cursorColor: AppTheme.primaryColor,
                            // validator: validateMoney,
                            decoration: const InputDecoration(
                              hintText: "+\$100",
                              hintStyle: TextStyle(color: const Color(0xFF3A3A3A), fontWeight: FontWeight.w600, fontSize: 31),
                            )),
                        SizedBox(
                          height: AddSize.size15,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: List.generate(
                            moneyList.length,
                            (index) => chipList(moneyList[index]),
                          ),
                        ),
                        SizedBox(
                          height: 25,
                        ),
                        CommonButtonBlue(
                          title: AppStrings.withdrawal.tr,
                          onPressed: () {
                            Get.toNamed(MyRouters.bankDetailsScreen);
                          },
                        )
                      ],
                    ))),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                padding: EdgeInsets.all(14),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          AppStrings.amount.tr,
                          style: GoogleFonts.poppins(color: const Color(0xFF3B5998), fontWeight: FontWeight.w600, fontSize: 12),
                        ),
                        // const SizedBox(width: 0,),
                        Text(
                          AppStrings.date.tr,
                          style: GoogleFonts.poppins(color: const Color(0xFF3B5998), fontWeight: FontWeight.w600, fontSize: 12),
                        ),
                        Text(
                          AppStrings.status.tr,
                          style: GoogleFonts.poppins(color: const Color(0xFF3B5998), fontWeight: FontWeight.w600, fontSize: 12),
                        ),
                      ],
                    ),
                    Divider(
                      thickness: 1,
                      color: Colors.black12.withOpacity(0.09),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: 6,
                        itemBuilder: (context, index) {
                          return Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "#1234",
                                    style: GoogleFonts.poppins(
                                        color: const Color(0xFF454B5C), fontWeight: FontWeight.w600, fontSize: 14),
                                  ),
                                  Text(
                                    "2 June, 2021 - 11:57PM",
                                    style: GoogleFonts.poppins(
                                        color: const Color(0xFF8C9BB2), fontWeight: FontWeight.w500, fontSize: 11),
                                  ),
                                  Text(
                                    "Processing",
                                    style: GoogleFonts.poppins(
                                        color: const Color(0xFFFFB26B), fontWeight: FontWeight.w600, fontSize: 12),
                                  ),
                                ],
                              ),
                              Divider(
                                thickness: 1,
                                color: Colors.black12.withOpacity(0.09),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                            ],
                          );
                        })
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 50,
            ),
          ],
        ),
      ),
    );
  }

  chipList(title) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return ChoiceChip(
      padding: EdgeInsets.symmetric(horizontal: width * .005, vertical: height * .005),
      backgroundColor: AppTheme.backgroundcolor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30), side: BorderSide(color: Colors.grey.shade300)),
      label: Text("+\$${title}", style: TextStyle(color: Colors.grey.shade600, fontSize: 14, fontWeight: FontWeight.w500)),
      selected: false,
      onSelected: (value) {
        setState(() {
          addMoneyController.text = title;
          FocusManager.instance.primaryFocus!.unfocus();
        });
      },
    );
  }
}
