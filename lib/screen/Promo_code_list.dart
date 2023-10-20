import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../widget/addsize.dart';
import '../widget/appassets.dart';
import '../widget/custom_textfield.dart';
class PromoCodeList extends StatefulWidget {
  const PromoCodeList({super.key});

  @override
  State<PromoCodeList> createState() => _PromoCodeListState();
}

class _PromoCodeListState extends State<PromoCodeList> {

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: backAppBar(title: "Promo code List", context: context),
      body: SingleChildScrollView(
      child: Column(
      children: [
      const SizedBox(height: 10,),
        ListView.builder(
            padding: EdgeInsets.zero,
            scrollDirection: Axis.vertical,
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: 4,
            itemBuilder: (BuildContext, int index) {
              return Stack(children: [
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Container(
                        width: AddSize.screenWidth,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.shade200,
                              blurRadius: 10,
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 28,top: 10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: [

                              Text("Welcome to New", style: GoogleFonts.poppins(
                                  color: const Color(0xFF304048),
                                  fontWeight: FontWeight.w400,
                                  fontSize: 16),),
                              const SizedBox(height: 4,),
                              Text("Happy SUNDAY", style: GoogleFonts.poppins(
                                  color: const Color(0xFFFAAF40),
                                  fontWeight: FontWeight.w300,
                                  fontSize: 14),),
                              const SizedBox(height: 30,),
                              Padding(
                                padding: const EdgeInsets.only(left: 2.0,right: 25),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("Discount", style: GoogleFonts.poppins(
                                        color: const Color(0xFF304048),
                                        fontWeight: FontWeight.w400,
                                        fontSize: 16),),
                                    Text("\$10.00", style: GoogleFonts.poppins(
                                        color:  Colors.grey,
                                        fontWeight: FontWeight.w300,
                                        fontSize: 14),),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 6,),
                              Padding(
                                padding: const EdgeInsets.only(left: 2.0,right: 25),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("20 Oct 2023", style: GoogleFonts.poppins(
                                        color:  Colors.grey,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 16),),
                                    Text("To", style: GoogleFonts.poppins(
                                        color:  Colors.grey,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 16),),
                                    Text("22 Oct 2023", style: GoogleFonts.poppins(
                                        color:  Colors.grey,
                                        fontWeight: FontWeight.w300,
                                        fontSize: 14),),
                                  ],
                                ),
                              ),


                              const SizedBox(
                                height: 20,
                              ),

                            ],
                          ),
                        ),
                      ),
                    ),

                  ],
                ),
                Positioned(
                    top: 62,
                    left: -10,
                    right: -10,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CircleAvatar(
                          radius: 15,
                          backgroundColor: Colors.grey[100],
                        ),
                        //Image.asset('assets/images/abc.png',height: 30,width: 30,),
                        Expanded(
                          child: FittedBox(
                            child: Row(
                              children: List.generate(
                                  25,
                                      (index) => Padding(
                                    padding: const EdgeInsets.only(left: 2, right: 2),
                                    child: Container(
                                      color: Colors.grey[200],
                                      height: 2,
                                      width: 10,
                                    ),
                                  )),
                            ),
                          ),
                        ),
                        CircleAvatar(
                          radius: 15,
                          backgroundColor: Colors.grey[100],
                        ),
                      ],
                    )),
              ]);
            }),


      ])));
  }
}
