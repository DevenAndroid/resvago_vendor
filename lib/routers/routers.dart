import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:resvago_vendor/screen/Menu/add_menu.dart';
import 'package:resvago_vendor/screen/Menu/menu_screen.dart';
import 'package:resvago_vendor/screen/bottom_nav_bar/oder_list_screen.dart';
import 'package:resvago_vendor/screen/dashboard/dashboard_screen.dart';
import '../screen/Promo_code_list.dart';
import '../screen/add_booking_slot_screen.dart';
import '../screen/bank_details_screen.dart';
import '../screen/bottom_nav_bar/bottomnav_bar.dart';
import '../screen/bottom_nav_bar/menu_list_screen.dart';
import '../screen/bottom_nav_bar/wallet_screen.dart';
import '../screen/delivery_oders_details_screen.dart';
import '../screen/login_screen.dart';
import '../screen/oder_details_screen.dart';
import '../screen/onboarding_screen.dart';
import '../screen/reviwe_screen.dart';
import '../screen/signup screen.dart';
import '../screen/slot_list.dart';
import '../screen/thankyou_screen.dart';
import '../splash_screen.dart';

class MyRouters {
  static var splashScreen = "/splashScreen";
  static var onBoardingScreen = "/onBoardingScreen";
  static var signUpScreen = "/signUpScreen";
  static var loginScreen = "/loginScreen";
  static var bottomNavbar = "/bottomNavbar";
  static var otpScreen = "/otpScreen";
  static var thankYouScreen = "/thankYouScreen";
  static var vendorDashboard = "/vendorDashboard";
  static var menuScreen = "/menuScreen";
  static var walletScreen = "/walletScreen";
  static var oderListScreen = "/oderListScreen";
  static var menuListScreen = "/menuListScreen";
  static var addBookingSlot = "/addBookingSlot";
  static var oderDetailsScreen = "/oderDetailsScreen";
  static var bankDetailsScreen = "/bankDetailsScreen";
  static var promoCodeList = "/promoCodeList";
  static var slotListScreen = "/slotListScreen";
  static var deliveryOderDetailsScreen = "/deliveryOderDetailsScreen";
  static var reviewScreen = "/reviewScreen";
  // static var addMenuScreen = "/addMenuScreen";
  static var route = [
    GetPage(name: '/', page: () => const SplashScreen()),
    GetPage(name: '/onBoardingScreen', page: () => const OnBoardingScreen()),
    GetPage(name: '/loginScreen', page: () => const LoginScreen()),
    GetPage(name: '/signUpScreen', page: () => const SignUpScreen()),
    GetPage(name: '/bottomNavbar', page: () => const BottomNavbar()),
    GetPage(name: '/thankYouScreen', page: () => const ThankYouScreen()),
    GetPage(name: '/vendorDashboard', page: () => const VendorDashboard()),
    GetPage(name: '/menuScreen', page: () => const MenuScreen()),
    GetPage(name: '/walletScreen', page: () => const WalletScreen()),
    GetPage(name: '/oderListScreen', page: () => const OderListScreen()),
    GetPage(name: '/menuListScreen', page: () => const MenuListScreen()),
    // GetPage(name: '/addBookingSlot', page: () => const AddBookingSlot()),
    GetPage(name: '/oderDetailsScreen', page: () => const OderDetailsScreen()),
    GetPage(name: '/bankDetailsScreen', page: () => const BankDetailsScreen()),
    GetPage(name: '/promoCodeList', page: () => const PromoCodeList()),
    GetPage(name: '/slotListScreen', page: () => const SlotListScreen()),
    GetPage(name: '/deliveryOderDetailsScreen', page: () => const DeliveryOderDetailsScreen()),
    GetPage(name: '/reviewScreen', page: () => const ReviewScreen()),
    // GetPage(name: '/addMenuScreen', page: () => const AddMenuScreen()),
  ];
}
