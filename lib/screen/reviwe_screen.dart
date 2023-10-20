import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:resvago_vendor/widget/appassets.dart';

import '../widget/addsize.dart';
import '../widget/custom_textfield.dart';

class ReviewScreen extends StatefulWidget {
  const ReviewScreen({Key? key}) : super(key: key);

  @override
  State<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  double fullRating = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: backAppBar(title: 'Feedback', context: context),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15.0,horizontal: 10),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text('4.8',style: TextStyle(
                    color: Color(0xFF1B233A),
                    fontSize: 48,
                    fontWeight: FontWeight.w600,
                  ),),
                  SizedBox(width: 26,),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RatingBar.builder(
                        initialRating: 4,
                        minRating: 1,
                        unratedColor: const Color(0xFFECE3D0),
                        itemCount: 5,
                        itemSize: 16.0,
                        itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                        updateOnDrag: true,
                        itemBuilder: (context, index) =>
                            Image.asset(AppAssets.star,
                              color: Colors.amber,
                            ),
                        onRatingUpdate: (ratingvalue) {
                          setState(() {
                            fullRating = ratingvalue;
                          });
                        },
                      ),
                      SizedBox(height: 3,),
                      const Padding(
                        padding:  EdgeInsets.symmetric(horizontal: 4.0),
                        child:  Text('basad on 23 reviews',style: TextStyle(
                          color: Color(0xFF969AA3),
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                        ),),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 20,),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Excellent        ',style: TextStyle(
                        color: Color(0xFF969AA3),
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      ),),
                      Expanded(
                        child: LinearPercentIndicator(
                          lineHeight: 6.0,
                          barRadius: const Radius.circular(16),
                          backgroundColor: const Color(0xFFFAE9E4),
                          animation: true,
                          progressColor: const Color(0xFF5DAF5E),
                          percent: 0.7,
                          animationDuration: 1200,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10,),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Good               ',style: TextStyle(
                        color: Color(0xFF969AA3),
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      ),),
                      Expanded(
                        child: LinearPercentIndicator(
                          lineHeight: 6.0,
                          barRadius: const Radius.circular(16),
                          backgroundColor: const Color(0xFFFAE9E4),
                          animation: true,
                          progressColor: const Color(0xFFA4D131),
                          percent: 0.5,
                          animationDuration: 1200,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Average          ',style: TextStyle(
                        color: Color(0xFF969AA3),
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      ),),
                      Expanded(
                        child: LinearPercentIndicator(
                          lineHeight: 6.0,
                          barRadius: const Radius.circular(16),
                          backgroundColor: const Color(0xFFFAE9E4),
                          // width: AddSize.screenWidth,
                          animation: true,
                          progressColor: const Color(0xFFF7E742),
                          percent: 0.3,
                          animationDuration: 1200,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Below Average',style: TextStyle(
                        color: Color(0xFF969AA3),
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      ),),
                      Expanded(
                        child: LinearPercentIndicator(
                          lineHeight: 6.0,
                          barRadius: const Radius.circular(16),
                          backgroundColor: const Color(0xFFFAE9E4),
                          animation: true,
                          progressColor: const Color(0xFFF8B859),
                          percent: 0.5,
                          animationDuration: 1200,
                        ),
                      ),
                    ],
                  ),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //   children: [
                  //     const Text('Delivery               ',style: TextStyle(
                  //       color: Color(0xFF969AA3),
                  //       fontSize: 12,
                  //       fontWeight: FontWeight.w400,
                  //     ),),
                  //     Expanded(
                  //       child: LinearPercentIndicator(
                  //         lineHeight: 6.0,
                  //         barRadius: const Radius.circular(16),
                  //         backgroundColor: const Color(0xFFFAE9E4),
                  //         animation: true,
                  //         progressColor: const Color(0xFFEE3D1C),
                  //         percent: 0.2,
                  //         animationDuration: 1200,
                  //       ),
                  //     ),
                  //   ],
                  // ),
                ],
              ),
              SizedBox(height: 20,),
              const Divider(
                height: 1,
                thickness: 1.5,
                color: Color(0xFFE8F2EC),
              ),
              SizedBox(height: 20,),
              ListView.builder(
                shrinkWrap: true,
                itemCount: 3,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Image.asset(AppAssets.picture,height: 50,),
                          SizedBox(width: 20,),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Padding(
                                  padding:  EdgeInsets.symmetric(horizontal: 5.0),
                                  child: Text('Abhishek Jangid',
                                    style: TextStyle(
                                      color: Color(0xFF1B233A),
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),),
                                ),
                                SizedBox(height: 10,),
                                RatingBar.builder(
                                  initialRating: 4,
                                  minRating: 1,
                                  unratedColor: const Color(0xFFECE3D0),
                                  itemCount: 5,
                                  itemSize: 16.0,
                                  itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                                  updateOnDrag: true,
                                  itemBuilder: (context, index) =>
                                      Image.asset(AppAssets.star,
                                        color: Colors.amber,
                                      ),
                                  onRatingUpdate: (ratingvalue) {
                                    setState(() {
                                      fullRating = ratingvalue;
                                    });
                                  },
                                ),
                                SizedBox(height: 7,),
                                Padding(
                                  padding: const  EdgeInsets.symmetric(horizontal: 5.0),
                                  child: RichText(
                                    text: const TextSpan(
                                        children: [
                                          TextSpan(
                                              text: 'It is a long established fact that a reader will be distracted by the readable content of a page when looking...',
                                              style: TextStyle(
                                                color: Color(0xFF969AA3),
                                                fontSize: 13,
                                                fontWeight: FontWeight.w300,

                                              )),
                                          TextSpan(
                                              text: 'read more',
                                              style: TextStyle(
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w400,
                                                  color: Color(0xFF567DF4)))
                                        ]),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // const Spacer(),
                          const Padding(
                            padding:  EdgeInsets.symmetric(vertical: 3.0),
                            child:  Text('Oct 23, 2022',style: TextStyle(
                              color: Color(0xFF969AA3),
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                            ),),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: AddSize.size5,
                      ),
                      index != 2
                          ? const Divider()
                          : const SizedBox(),
                      SizedBox(
                        height: AddSize.size5,
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
