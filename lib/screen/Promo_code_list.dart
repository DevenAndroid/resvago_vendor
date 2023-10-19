import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

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
      appBar: backAppBar(title: "Slot List", context: context),
      body: SingleChildScrollView(
      child: Column(
      children: [
      SizedBox(height: 10,),
        ListView.builder(
            padding: EdgeInsets.zero,
            scrollDirection: Axis.vertical,
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: 4,
            itemBuilder: (BuildContext, int index) {
              return Stack(children: [
                Column(
                  children: [
                    Container(
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
                        padding: const EdgeInsets.all(8),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                SizedBox(
                                  height: 45,
                                  width: 45,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(30),
                                    child: CachedNetworkImage(
                                      imageUrl:  AppAssets.shopping,
                                      errorWidget: (_, __, ___) => const SizedBox(),
                                      placeholder: (_, __) => Image.asset(
                                        AppAssets.shopping,
                                        color: Colors.grey.shade200,
                                      ),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  // width: width * .01,
                                ),
                                // Column(
                                //   crossAxisAlignment: CrossAxisAlignment.start,
                                //   children: [
                                //     Text(
                                //       couponController.model.value.data![index].title.toString(),
                                //       style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                                //     ),
                                //     Row(
                                //       children: [
                                //         couponController.model.value.data![index].discountType == "P"
                                //             ? Text(
                                //           "${couponController.model.value.data![index].amount.toString()}%",
                                //           style:
                                //           TextStyle(fontSize: 14, fontWeight: FontWeight.w300),
                                //         )
                                //             : SizedBox(),
                                //         SizedBox(
                                //           width: 5,
                                //         ),
                                //         Container(
                                //           decoration: BoxDecoration(
                                //               border: Border.all(color: Color(0xFFD73D95)),
                                //               shape: BoxShape.circle),
                                //           child: CircleAvatar(
                                //             backgroundColor: Colors.transparent,
                                //             radius: 10,
                                //             child: Text(
                                //               'i'.tr,
                                //               style: TextStyle(color: Color(0xFFD73D95), fontSize: 12),
                                //             ),
                                //           ),
                                //         ),
                                //         SizedBox(
                                //           width: 5,
                                //         ),
                                //         Text(
                                //           couponController.model.value.data![index].couponCode
                                //               .toString(),
                                //           style: TextStyle(fontSize: 14, fontWeight: FontWeight.w300),
                                //         ),
                                //       ],
                                //     ),
                                //   ],
                                // ),
                              ],
                            ),
                            SizedBox(
                              height: height * .06,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(width: width * .005),
                                // Container(
                                //   height: height * .04,
                                //   width: width * .55,
                                //   decoration: BoxDecoration(
                                //       color: Colors.white,
                                //       borderRadius: BorderRadius.circular(20),
                                //       border: Border.all(color: Color(0xFFFF0000))),
                                //   child: FittedBox(
                                //     child: Padding(
                                //       padding: const EdgeInsets.symmetric(horizontal: 8),
                                //       child: Row(
                                //         mainAxisAlignment: MainAxisAlignment.center,
                                //         children: [
                                //           Text(
                                //             'Min Order \$ ${(couponController.model.value.data![index].customerBuyPurchaseAmount ?? "").toString()} '
                                //                 .tr,
                                //             style: TextStyle(
                                //                 fontWeight: FontWeight.w400,
                                //                 fontSize: 12,
                                //                 color: Color(0xFFFF0000)),
                                //           ),
                                //           Text(
                                //             'Use by ${couponController.model.value.data![index].validTo.toString()}'
                                //                 .tr,
                                //             style: TextStyle(
                                //                 fontWeight: FontWeight.w400,
                                //                 fontSize: 12,
                                //                 color: Color(0xFFFF0000)),
                                //           ),
                                //         ],
                                //       ),
                                //     ),
                                //   ),
                                // ),
                                SizedBox(width: 20),
                                // GestureDetector(
                                //   onTap: () {
                                //     applyCoupons(
                                //         couponCode: couponController
                                //             .model.value.data![index].couponCode
                                //             .toString(),
                                //         context: context)
                                //         .then((value) {
                                //       showToast(value.message);
                                //       if (value.status == true) {
                                //         showToast(value.message);
                                //         myCartController.getAddToCartList1();
                                //         Get.back();
                                //       }
                                //       // else if(value.status==false)
                                //       //   showToast(value.message);
                                //     });
                                //   },
                                //   child: Container(
                                //     width: width * .20,
                                //     height: height * .04,
                                //     decoration: BoxDecoration(
                                //       color: Color(0xFFD1FFD1),
                                //       borderRadius: BorderRadius.circular(20),
                                //     ),
                                //     child: Center(
                                //       child: Text(
                                //         'USE'.tr,
                                //         style: TextStyle(
                                //             fontWeight: FontWeight.w500,
                                //             fontSize: 16,
                                //             color: Color(0xFF07C71B)),
                                //       ),
                                //     ),
                                //   ),
                                // )
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),

                            SizedBox(
                              height: 5,
                            ),

                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    )
                  ],
                ),
                Positioned(
                    top: 30,
                    left: -10,
                    right: -10,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CircleAvatar(
                          radius: 10,
                          backgroundColor: Colors.grey[200],
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
                          radius: 10,
                          backgroundColor: Colors.grey[200],
                        ),
                      ],
                    )),
              ]);
            }),


      ])));
  }
}
