import 'package:get/get_navigation/src/routes/get_route.dart';

import '../screen/login_screen.dart';
import '../screen/onboarding_screen.dart';
import '../screen/otp_screen.dart';
import '../screen/signup screen.dart';
import '../screen/thankyou_screen.dart';
import '../splash_screen.dart';

class MyRouters {
  static var splashScreen = "/splashScreen";
  static var onBoardingScreen = "/onBoardingScreen";
  static var signUpScreen = "/signUpScreen";
  static var loginScreen = "/loginScreen";
  static var otpScreen = "/otpScreen";
  static var thankYouScreen = "/thankYouScreen";

  static var route = [
    GetPage(name: '/', page: () => const SplashScreen()),
    GetPage(name: '/onBoardingScreen', page: () => const OnBoardingScreen()),
    GetPage(name: '/loginScreen', page: () => const LoginScreen()),
    GetPage(name: '/signUpScreen', page: () => const SignUpScreen()),
    GetPage(name: '/otpScreen', page: () => const OtpScreen()),
    GetPage(name: '/thankYouScreen', page: () => const ThankYouScreen()),
  ];
}
