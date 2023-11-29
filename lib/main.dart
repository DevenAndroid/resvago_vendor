import 'package:firebase_core/firebase_core.dart';
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
        apiKey: "AIzaSyBCol-O-qoqmOCLI_aRN0PeJ5KPvGPVQB8",
        projectId: "resvago-b7bd4",
        messagingSenderId: "671324938172",
        appId: "1:671324938172:web:d017a2cf72416c24aed5b9",
        storageBucket: "resvago-b7bd4.appspot.com",
      ),
    );
  }
  await Firebase.initializeApp();
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
    if (sharedPreferences.getString("app_language") == null ||
        sharedPreferences.getString("app_language") == "english") {
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
          // colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
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
