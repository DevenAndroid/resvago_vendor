import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:resvago_vendor/widget/appassets.dart';
import 'package:resvago_vendor/widget/common_text_field.dart';
import 'package:resvago_vendor/widget/custom_textfield.dart';

import '../../routers/routers.dart';
class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
     appBar: backAppBar(title: "Withdrawal Money", context: context),
       body: SingleChildScrollView(
         child: Column(
           children: [
    Padding(
    padding: const EdgeInsets.all(10.0),
    child: Container(
    padding: EdgeInsets.all(14),
    decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(10)

    ),
    child: Row(
      children: [
          Column(
            children: [
Text("My Balance",style: GoogleFonts.poppins(
    color: const Color(0xFF3A3A3A),
          fontWeight: FontWeight.w400,
          fontSize: 16),),
Text("\$2400",style: GoogleFonts.poppins(
    color: const Color(0xFF3A3A3A),
          fontWeight: FontWeight.w600,
          fontSize: 31),),
            ],
          ),
          Spacer(),
          Image.asset(AppAssets.withdrawl,height: 40,)
      ],
    ))),
    Padding(
    padding: const EdgeInsets.all(10.0),
    child: Container(
    padding: EdgeInsets.all(14),
    decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(10)

    ),
    child: Column(
      children: [
          Text("+\$100",style: GoogleFonts.poppins(
              color: const Color(0xFF3A3A3A),
              fontWeight: FontWeight.w600,
              fontSize: 31),),
          SizedBox(height: 6,),
          Divider(
            thickness: 1,color: Colors.grey.withOpacity(.3),
          ),
          SizedBox(height: 10,),
          Padding(
            padding: const EdgeInsets.only(left: 18.0,right: 18),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Color(0xFFBDC1C2))
                  ),
                  child: Text("+\$500 ",style: GoogleFonts.poppins(
                      color: const Color(0xFF262F33),
                      fontWeight: FontWeight.w500,
                      fontSize: 14),),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Color(0xFFBDC1C2))
                  ),
                  child: Text("+\$800 ",style: GoogleFonts.poppins(
                      color: const Color(0xFF262F33),
                      fontWeight: FontWeight.w500,
                      fontSize: 14),),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Color(0xFFBDC1C2))
                  ),
                  child: Text("+\$1000 ",style: GoogleFonts.poppins(
                      color: const Color(0xFF262F33),
                      fontWeight: FontWeight.w500,
                      fontSize: 14),),
                ),
              ],
            ),
          ),
   SizedBox(height: 25,),
   CommonButtonBlue(title: "Withdrawal",onPressed: (){Get.toNamed(MyRouters.bankDetailsScreen);},)
      ],
    ))),

      Padding(
        padding: const EdgeInsets.all(10.0),
        child: Container(
          padding: EdgeInsets.all(14),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10)

          ),child: Column(
                 children: [
                   Row(
                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                     children: [
                       Text("Amount", style: GoogleFonts.poppins(
                           color: const Color(0xFF3B5998),
                           fontWeight: FontWeight.w600,
                           fontSize: 12),),
                       // const SizedBox(width: 0,),
                       Text("Date", style: GoogleFonts.poppins(
                           color: const Color(0xFF3B5998),
                           fontWeight: FontWeight.w600,
                           fontSize: 12),),
                       Text("Status", style: GoogleFonts.poppins(
                           color: const Color(0xFF3B5998),
                           fontWeight: FontWeight.w600,
                           fontSize: 12),),
                     ],
                   ),
                   Divider(
                     thickness: 1,
                     color: Colors.black12.withOpacity(0.09),
                   ),
                   const SizedBox(height: 10,),
                    ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: 6,
                        itemBuilder: (context, index) {
                          return Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "#1234",
                                    style: GoogleFonts.poppins(
                                        color: const Color(0xFF454B5C),
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14),
                                  ),
                                  Text(
                                    "2 June, 2021 - 11:57PM",
                                    style: GoogleFonts.poppins(
                                        color: const Color(0xFF8C9BB2),
                                        fontWeight: FontWeight.w500,
                                        fontSize: 11),
                                  ),
                                  Text(
                                    "Processing",
                                    style: GoogleFonts.poppins(
                                        color: const Color(0xFFFFB26B),
                                        fontWeight: FontWeight.w600,
                                        fontSize: 12),
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
             ),),
             const SizedBox(height: 100,),
           ],
         ),
       ),
    );
  }
}
