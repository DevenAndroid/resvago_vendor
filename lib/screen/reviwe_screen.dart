import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
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
      averageRating = calculateAverageRating();
      categoryPercentages = calculatePercentageByCategory();
      setState(() {});
    });
  }

  double calculateAverageRating() {
    if (reviewModel == null || reviewModel!.isEmpty) {
      return 0.0;
    }
    double totalRating = 0;
    for (var review in reviewModel!) {
      totalRating += review.fullRating;
    }

    return totalRating / reviewModel!.length;
  }

  double averageRating = 0.0;

  Map<String, double> calculatePercentageByCategory() {
    if (reviewModel == null || reviewModel!.isEmpty) {
      return {
        'Excellent': 0.0,
        'Good': 0.0,
        'Average': 0.0,
        'Below Average': 0.0,
        'Poor': 0.0,
      };
    }
    int excellentCount = 0;
    int goodCount = 0;
    int averageCount = 0;
    int belowAverageCount = 0;
    int poorCount = 0;

    for (var review in reviewModel!) {
      if (review.fullRating >= 4.5) {
        excellentCount++;
      } else if (review.fullRating >= 3.5) {
        goodCount++;
      } else if (review.fullRating >= 2.5) {
        averageCount++;
      } else if (review.fullRating >= 1.5) {
        belowAverageCount++;
      } else {
        poorCount++;
      }
    }

    int totalReviews = reviewModel!.length;
    return {
      'Excellent': excellentCount / totalReviews,
      'Good': goodCount / totalReviews,
      'Average': averageCount / totalReviews,
      'Below Average': belowAverageCount / totalReviews,
      'Poor': poorCount / totalReviews,
    };
  }

  Map<String, double> categoryPercentages = {};

  @override
  void initState() {
    super.initState();
    getReviewList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: backAppBar(title: 'FeedBack'.tr, context: context),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (reviewModel != null)
                Column(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Row(
                    children: [
                      Text(
                        "Review".tr,
                        style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w500, color: const Color(0xFF1E2538)),
                      ),
                      Text(
                        "(${reviewModel!.length})",
                        style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w500, color: const Color(0xFF1E2538)),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Overall Rating".tr,
                    style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w500, color: const Color(0xFF969AA3)),
                  ),
                  Padding(
                      padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 10),
                      child: Column(children: [
                        Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                          Text(
                            averageRating.toStringAsFixed(2).toString(),
                            style: const TextStyle(
                              color: Color(0xFF1B233A),
                              fontSize: 40,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            RatingBar.builder(
                              initialRating: averageRating,
                              allowHalfRating: true,
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
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 4.0),
                              child: Text(
                                'based on ${reviewModel!.length} reviews',
                                style: const TextStyle(
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
                            percent: categoryPercentages['Excellent'] ?? 0.0,
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
                            percent: categoryPercentages['Good'] ?? 0.0,
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
                            percent: categoryPercentages['Average'] ?? 0.0,
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
                            percent: categoryPercentages['Below Average'] ?? 0.0,
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
                            percent: categoryPercentages['Poor'] ?? 0.0,
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
                                          (reviewList.userName ?? "").toString(),
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
                                        initialRating: double.tryParse((reviewList.fullRating ?? "0.0").toString())!,
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
                                                text: (reviewList.about ?? ""),
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
                Center(child: Text("Feedback not available".tr))
            ],
          ).appPaddingForScreen,
        ),
      ),
    );
  }
}
