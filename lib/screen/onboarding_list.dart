import 'package:get/get.dart';

import '../widget/app_strings_file.dart';
import '../widget/appassets.dart';


class OnBoarding {
  String title;
  String img;
  String description;

  OnBoarding(
      {required this.title, required this.img,required this.description,});
}

List<OnBoarding> page1 = [
  OnBoarding(
    title: AppStrings.youFirst.tr,
    img: "assets/images/onboarding2.png",
    description: AppStrings.weDontChargeYou.tr,

  ),
  OnBoarding(
    title: AppStrings.beautifullyDesigned.tr,
    img: "assets/images/onboarding.png",
    description: AppStrings.everyMenuItemIs.tr,

  ),
  OnBoarding(
    title: AppStrings.unbeatableRates.tr,
    img: "assets/images/onbording2.png",
    description: AppStrings.weDontChargeAnyOrder.tr,

  ),

];


class OnBoardModelResponse {
  final String? image, title, description;


  OnBoardModelResponse({
    this.image,
    this.title,
    this.description,
  });
}

List<OnBoardModelResponse> OnBoardingData = [
  OnBoardModelResponse(
    image: AppAssets.onboarding,
    title: AppStrings.youFirst.tr,

    description:  AppStrings.weDontChargeYou.tr,

  ),
  OnBoardModelResponse(
    image: AppAssets.onboarding1,
    title: AppStrings.beautifullyDesigned.tr,
    description: AppStrings.everyMenuItemIs.tr,

  ),
  OnBoardModelResponse(
    image: AppAssets.onboarding2,
    title: AppStrings.unbeatableRates.tr,
    description: AppStrings.weDontChargeAnyOrder.tr,

  )
];