import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:resvago_vendor/utils/helper.dart';
import 'package:resvago_vendor/widget/appassets.dart';
import 'package:resvago_vendor/widget/apptheme.dart';

import '../widget/addsize.dart';

class TotalEarningScreen extends StatefulWidget {
  const TotalEarningScreen({super.key});

  @override
  State<TotalEarningScreen> createState() => _TotalEarningScreenState();
}

class _TotalEarningScreenState extends State<TotalEarningScreen> {
  double total = 0;
  double total1 = 0;
  double combinedTotal = 0; // Variable to store the sum

  @override
  void initState() {
    super.initState();

    FirebaseFirestore.instance.collection("dining_order").get().then((value) {
      total = 0;
      for (var element in value.docs) {
        total += double.tryParse(element.get("total").toString()) ?? 0;
      }
      updateCombinedTotal();
    });

    FirebaseFirestore.instance.collection("order").get().then((value) {
      total1 = 0;
      for (var element in value.docs) {
        total1 += double.tryParse(element.get("total").toString()) ?? 0;
      }
      updateCombinedTotal();
    });
  }

  void updateCombinedTotal() {
    if (total != 0 && total1 != 0) {
      combinedTotal = total + total1;
      setState(() {});
      print('Combined Total: $combinedTotal');
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 273,
              child: Stack(children: [
                Container(
                  color: Colors.white,
                ),
                Container(
                  height: 260,
                  decoration: const BoxDecoration(
                      color: AppTheme.primaryColor,
                      borderRadius: BorderRadius.only(bottomLeft: Radius.circular(50), bottomRight: Radius.circular(50))),
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 20.0,
                      right: 20,
                      top: 10,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 30,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "TOTAL EARNING",
                              style: GoogleFonts.poppins(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w400),
                            ),
                            Image.asset(
                              AppAssets.filter,
                              height: 30,
                            ),
                          ],
                        ),
                        Text(
                          "\$ ${combinedTotal}",
                          style: GoogleFonts.poppins(color: Colors.white, fontSize: 45, fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(
                          height: 17,
                        ),
                        Center(
                          child: SizedBox(
                            width: AddSize.screenWidth,
                            height: 50,
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                    primary: const Color(0xFF355EB3),
                                    textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
                                onPressed: () {},
                                child: Text(
                                  "Withdrawal Amount",
                                  style: GoogleFonts.poppins(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w500),
                                )),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Positioned.fill(
                  top: 222,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 16.0, right: 16),
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10), boxShadow: [
                            BoxShadow(
                                color: Colors.grey.shade300,
                                // offset: Offset(2, 2),
                                blurRadius: 05)
                          ]),
                          child: TextField(
                            maxLines: 1,
                            style: const TextStyle(fontSize: 17),
                            textAlignVertical: TextAlignVertical.center,
                            textInputAction: TextInputAction.search,
                            onChanged: (value) => {setState(() {})},
                            decoration: InputDecoration(
                                filled: true,
                                suffixIcon: IconButton(
                                  onPressed: () {},
                                  icon: Icon(
                                    Icons.search_rounded,
                                    color: const Color(0xFF9DA4BB),
                                    size: AddSize.size25,
                                  ),
                                ),
                                border: const OutlineInputBorder(
                                    borderSide: BorderSide.none, borderRadius: BorderRadius.all(Radius.circular(10))),
                                fillColor: Colors.white,
                                contentPadding: EdgeInsets.symmetric(horizontal: AddSize.padding20, vertical: AddSize.padding10),
                                hintText: 'Search',
                                hintStyle: const TextStyle(fontSize: 14, color: Colors.black, fontWeight: FontWeight.w300)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ]),
            ),
            // ListView.builder(
            //     physics: const NeverScrollableScrollPhysics(),
            //     shrinkWrap: true,
            //     itemCount: 6,
            //     itemBuilder: (BuildContext context, int index) {
            //       return Padding(
            //           padding: const EdgeInsets.only(left: 16.0, right: 16),
            //           child: Column(
            //             children: [
            //               Container(
            //                   padding: const EdgeInsets.all(8),
            //                   decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10), boxShadow: [
            //                     BoxShadow(
            //                         color: Colors.grey.shade300,
            //                         // offset: Offset(2, 2),
            //                         blurRadius: 05)
            //                   ]),
            //                   child: Row(
            //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //                     crossAxisAlignment: CrossAxisAlignment.start,
            //                     children: [
            //                       Row(
            //                         mainAxisAlignment: MainAxisAlignment.start,
            //                         crossAxisAlignment: CrossAxisAlignment.start,
            //                         children: [
            //                           SvgPicture.asset(AppAssets.arrowDown),
            //                           const SizedBox(
            //                             width: 12,
            //                           ),
            //                           Column(
            //                             mainAxisAlignment: MainAxisAlignment.start,
            //                             crossAxisAlignment: CrossAxisAlignment.start,
            //                             children: [
            //                               Text(
            //                                 "Order ID:",
            //                                 style: GoogleFonts.poppins(
            //                                     color: const Color(0xFF21283D), fontSize: 12, fontWeight: FontWeight.w400),
            //                               ),
            //                               const SizedBox(
            //                                 height: 3,
            //                               ),
            //                               Text(
            //                                 "Amount:",
            //                                 style: GoogleFonts.poppins(
            //                                     color: const Color(0xFF21283D), fontSize: 12, fontWeight: FontWeight.w400),
            //                               ),
            //                               const SizedBox(
            //                                 height: 3,
            //                               ),
            //                               Text(
            //                                 "Admin Commission:",
            //                                 style: GoogleFonts.poppins(
            //                                     color: const Color(0xFF21283D), fontSize: 12, fontWeight: FontWeight.w400),
            //                               ),
            //                               const SizedBox(
            //                                 height: 3,
            //                               ),
            //                               Text(
            //                                 "Earning:",
            //                                 style: GoogleFonts.poppins(
            //                                     color: const Color(0xFF21283D), fontSize: 12, fontWeight: FontWeight.w400),
            //                               ),
            //                             ],
            //                           ),
            //                         ],
            //                       ),
            //                       Padding(
            //                         padding: const EdgeInsets.only(right: 8.0),
            //                         child: Column(
            //                           mainAxisAlignment: MainAxisAlignment.start,
            //                           crossAxisAlignment: CrossAxisAlignment.start,
            //                           children: [
            //                             Text(
            //                               "#1234",
            //                               style: GoogleFonts.poppins(
            //                                   color: const Color(0xFF424750), fontSize: 12, fontWeight: FontWeight.w300),
            //                             ),
            //                             const SizedBox(
            //                               height: 3,
            //                             ),
            //                             Text(
            //                               "\$100.00",
            //                               style: GoogleFonts.poppins(
            //                                   color: const Color(0xFF424750), fontSize: 12, fontWeight: FontWeight.w300),
            //                             ),
            //                             const SizedBox(
            //                               height: 3,
            //                             ),
            //                             Text(
            //                               "\$10.00",
            //                               style: GoogleFonts.poppins(
            //                                   color: const Color(0xFF424750), fontSize: 12, fontWeight: FontWeight.w300),
            //                             ),
            //                             const SizedBox(
            //                               height: 3,
            //                             ),
            //                             Text(
            //                               "\$90.00",
            //                               style: GoogleFonts.poppins(
            //                                   color: const Color(0xFF424750), fontSize: 12, fontWeight: FontWeight.w300),
            //                             ),
            //                           ],
            //                         ),
            //                       ),
            //                     ],
            //                   )),
            //               const SizedBox(
            //                 height: 10,
            //               )
            //             ],
            //           ));
            //     })
          ],
        ).appPaddingForScreen,
      ),
    );
  }
}
