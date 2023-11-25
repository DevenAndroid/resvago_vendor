import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:resvago_vendor/routers/routers.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if(kIsWeb){
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey:"AIzaSyBCol-O-qoqmOCLI_aRN0PeJ5KPvGPVQB8",
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

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
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
