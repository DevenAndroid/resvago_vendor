import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:resvago_vendor/utils/helper.dart';
import 'package:resvago_vendor/widget/appassets.dart';
import '../model/feedback_model.dart';
import '../widget/custom_textfield.dart';

class ReviewScreen extends StatefulWidget {
  const ReviewScreen({Key? key}) : super(key: key);

  @override
  State<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  double fullRating = 0;
  List<ReviewModel>? reviewModel;
  getReviewList() {
    FirebaseFirestore.instance
        .collection("Review")
        .where("vendorID", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((value) {
      for (var element in value.docs) {
        var gg = element.data();
        reviewModel ??= [];
        reviewModel!.add(ReviewModel.fromJson(gg));
      }
      setState(() {});
    });
  }

  @override
  void initState() {
    super.initState();
    getReviewList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: backAppBar(title: 'Feedback', context: context),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 10),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    '4.8',
                    style: TextStyle(
                      color: Color(0xFF1B233A),
                      fontSize: 48,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(
                    width: 26,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RatingBar.builder(
                        initialRating: 4,
                        minRating: 1,
                        unratedColor: const Color(0xFFECE3D0),
                        itemCount: 5,
                        itemSize: 16.0,
                        itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                        updateOnDrag: true,
                        itemBuilder: (context, index) => Image.asset(
                          AppAssets.star,
                          color: Colors.amber,
                        ),
                        onRatingUpdate: (ratingvalue) {
                          setState(() {
                            fullRating = ratingvalue;
                          });
                        },
                      ),
                      const SizedBox(
                        height: 3,
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 4.0),
                        child: Text(
                          'basad on 23 reviews',
                          style: TextStyle(
                            color: Color(0xFF969AA3),
                            fontSize: 13,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Excellent        ',
                        style: TextStyle(
                          color: Color(0xFF969AA3),
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
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
                  const SizedBox(
                    height: 10,
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Good               ',
                        style: TextStyle(
                          color: Color(0xFF969AA3),
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
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
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Average          ',
                        style: TextStyle(
                          color: Color(0xFF969AA3),
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
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
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Below Average',
                        style: TextStyle(
                          color: Color(0xFF969AA3),
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
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
              const SizedBox(
                height: 20,
              ),
              const Divider(
                height: 1,
                thickness: 1.5,
                color: Color(0xFFE8F2EC),
              ),
              const SizedBox(
                height: 20,
              ),
              if (reviewModel != null)
                Column(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(
                    "Review(${reviewModel!.length})",
                    style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w500, color: const Color(0xFF1E2538)),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Overall Rating",
                    style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w500, color: const Color(0xFF969AA3)),
                  ),
                  Padding(
                      padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 10),
                      child: Column(children: [
                        Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                          const Text(
                            '4.8',
                            style: TextStyle(
                              color: Color(0xFF1B233A),
                              fontSize: 48,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            RatingBar.builder(
                              initialRating: 4,
                              minRating: 1,
                              unratedColor: const Color(0xFF698EDE).withOpacity(.2),
                              itemCount: 5,
                              itemSize: 16.0,
                              itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                              updateOnDrag: true,
                              itemBuilder: (context, index) => Image.asset(
                                'assets/icons/star.png',
                                color: const Color(0xff3B5998),
                              ),
                              onRatingUpdate: (ratingvalue) {
                                null;
                              },
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 4.0),
                              child: Text(
                                'basad on 23 reviews',
                                style: TextStyle(
                                  color: Color(0xFF969AA3),
                                  fontSize: 13,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ]),
                        ]),
                      ])),
                  Column(children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Expanded(
                          child: Text(
                            'Excellent',
                            style: TextStyle(
                              color: Color(0xFF969AA3),
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: LinearPercentIndicator(
                            lineHeight: 6.0,
                            barRadius: const Radius.circular(16),
                            backgroundColor: const Color(0xFFE6F9ED),
                            animation: true,
                            progressColor: const Color(0xFF5DAF5E),
                            percent: 0.9,
                            animationDuration: 1200,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const Expanded(
                          child: Text(
                            'Good',
                            style: TextStyle(
                              color: Color(0xFF969AA3),
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: LinearPercentIndicator(
                            lineHeight: 6.0,
                            barRadius: const Radius.circular(16),
                            backgroundColor: const Color(0xFFF2FFCF),
                            animation: true,
                            progressColor: const Color(0xFFA4D131),
                            percent: 0.7,
                            animationDuration: 1200,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Expanded(
                          child: Text(
                            'Average',
                            style: TextStyle(
                              color: Color(0xFF969AA3),
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: LinearPercentIndicator(
                            lineHeight: 6.0,
                            barRadius: const Radius.circular(16),
                            backgroundColor: const Color(0xFFF5FFDB),
                            animation: true,
                            progressColor: const Color(0xFFF7E742),
                            percent: 0.6,
                            animationDuration: 1200,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Expanded(
                          child: Text(
                            'Below Average',
                            style: TextStyle(
                              color: Color(0xFF969AA3),
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: LinearPercentIndicator(
                            lineHeight: 6.0,
                            barRadius: const Radius.circular(16),
                            backgroundColor: const Color(0xFFFFF5E5),
                            animation: true,
                            progressColor: const Color(0xFFF8B859),
                            percent: 0.5,
                            animationDuration: 1200,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Expanded(
                          child: Text(
                            'Poor',
                            style: TextStyle(
                              color: Color(0xFF969AA3),
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: LinearPercentIndicator(
                            lineHeight: 6.0,
                            barRadius: const Radius.circular(16),
                            backgroundColor: const Color(0xFFFFE9E4),
                            animation: true,
                            progressColor: const Color(0xFFEE3D1C),
                            percent: 0.3,
                            animationDuration: 1200,
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                      ],
                    ),
                  ]),
                  const SizedBox(
                    height: 5,
                  ),
                  Divider(
                    color: const Color(0xFF698EDE).withOpacity(.1),
                    thickness: 2,
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  ListView.builder(
                      shrinkWrap: true,
                      itemCount: reviewModel!.length,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        var reviewList = reviewModel![index];
                        return Column(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: const SizedBox(
                                    height: 40,
                                    width: 40,
                                    child: Icon(Icons.person),
                                  ),
                                ),
                                const SizedBox(
                                  width: 20,
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 5.0),
                                        child: Text(
                                          reviewList.userName.toString(),
                                          style: GoogleFonts.poppins(
                                            color: const Color(0xFF1B233A),
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 6,
                                      ),
                                      RatingBar.builder(
                                        initialRating: reviewList.fullRating,
                                        minRating: 1,
                                        unratedColor: const Color(0xff3B5998).withOpacity(.2),
                                        itemCount: 5,
                                        itemSize: 16.0,
                                        itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                                        updateOnDrag: true,
                                        itemBuilder: (context, index) => Image.asset(
                                          'assets/icons/star.png',
                                          color: const Color(0xff3B5998),
                                        ),
                                        onRatingUpdate: (ratingvalue) {
                                          null;
                                        },
                                      ),
                                      const SizedBox(
                                        height: 8,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 5.0),
                                        child: RichText(
                                          text: TextSpan(children: [
                                            TextSpan(
                                                text: reviewList.about,
                                                style: GoogleFonts.poppins(
                                                  color: const Color(0xFF969AA3),
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w300,
                                                )),
                                            // TextSpan(
                                            //     text: 'read more',
                                            //     style: GoogleFonts.poppins(
                                            //         fontSize: 14,
                                            //         fontWeight: FontWeight.w400,
                                            //         color: const Color(0xFF567DF4)))
                                          ]),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                // const Spacer(),
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 3.0),
                                  child: Text(
                                    DateFormat.yMMMd().format(DateTime.parse(
                                        DateTime.fromMillisecondsSinceEpoch(int.parse(reviewList.time)).toString())),
                                    style: const TextStyle(
                                      color: Color(0xFF969AA3),
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            index != 2
                                ? Divider(
                                    color: const Color(0xFF698EDE).withOpacity(.1),
                                    thickness: 2,
                                  )
                                : const SizedBox(),
                            const SizedBox(
                              height: 12,
                            ),
                          ],
                        );
                      })
                ])
              else
                const Text("Feedback not available")
            ],
          ).appPaddingForScreen,
        ),
      ),
    );
  }
}
