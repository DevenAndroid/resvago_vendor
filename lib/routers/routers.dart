import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:resvago_vendor/screen/Menu/add_menu.dart';
import 'package:resvago_vendor/screen/Menu/menu_screen.dart';
import 'package:resvago_vendor/screen/dashboard/dashboard_screen.dart';
import '../screen/login_screen.dart';
import '../screen/onboarding_screen.dart';
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
  static var vendorDashboard = "/vendorDashboard";
  static var menuScreen = "/menuScreen";
  // static var addMenuScreen = "/addMenuScreen";
  static var route = [
    GetPage(name: '/', page: () => const SplashScreen()),
    GetPage(name: '/onBoardingScreen', page: () => const OnBoardingScreen()),
    GetPage(name: '/loginScreen', page: () => const LoginScreen()),
    GetPage(name: '/signUpScreen', page: () => const SignUpScreen()),
    GetPage(name: '/thankYouScreen', page: () => const ThankYouScreen()),
    GetPage(name: '/thankYouScreen', page: () => const ThankYouScreen()),
    GetPage(name: '/vendorDashboard', page: () => const VendorDashboard()),
    GetPage(name: '/menuScreen', page: () => const MenuScreen()),
    // GetPage(name: '/addMenuScreen', page: () => const AddMenuScreen()),
  ];
}
