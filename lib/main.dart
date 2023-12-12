import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:resvago_vendor/routers/routers.dart';
import 'package:resvago_vendor/widget/local_string.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyBN7-pBlJcY6p8stbdeDRgo-JVF6MO2K30",
          projectId: "resvago-ire",
          storageBucket: "resvago-ire.appspot.com",
          messagingSenderId: "382013840274",
          appId: "1:382013840274:web:6e7442ab8927e2b4abff4b",
      ),
    );
  } else {
    await Firebase.initializeApp();
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
  }
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  updateLanguage() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    if (sharedPreferences.getString("app_language") == null || sharedPreferences.getString("app_language") == "english") {
      Get.updateLocale(const Locale('en', 'US'));
    } else {
      Get.updateLocale(const Locale('es', 'ES'));
    }
  }

  @override
  void initState() {
    super.initState();
    updateLanguage();
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      translations: LocaleString(),
      locale: const Locale('en', 'US'),
      title: 'Flutter Demo',
      theme: ThemeData(
          // // colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          // focusColor: Colors.transparent,
          // hoverColor: Colors.transparent,
          useMaterial3: false,
          appBarTheme: const AppBarTheme(color: Colors.white),
          backgroundColor: Colors.white),
      color: Colors.white,
      debugShowCheckedModeBanner: false,
      initialRoute: "/",
      getPages: MyRouters.route,
    );
  }
}
