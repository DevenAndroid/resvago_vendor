import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:resvago_vendor/routers/routers.dart';
import 'package:resvago_vendor/utils/helper.dart';
import 'package:resvago_vendor/widget/common_text_field.dart';

import '../widget/appassets.dart';

class ThankYouScreen extends StatefulWidget {
  const ThankYouScreen({super.key});

  @override
  State<ThankYouScreen> createState() => _ThankYouScreenState();
}

class _ThankYouScreenState extends State<ThankYouScreen> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
            child: Container(
                height: Get.height,
                width: Get.width,
                decoration:  const BoxDecoration(
                    image: DecorationImage(
                        fit: BoxFit.fill,
                        image: AssetImage(kIsWeb ?AppAssets.webThankYou :AppAssets.thankYou))),
                child: SingleChildScrollView(
                    child: Padding(
                        padding: const EdgeInsets.only(left: 4.0, right: 4),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: size.height * 0.17,
                              ),
                              Center(
                                  child: Image.asset(
                                AppAssets.tick,
                                height: 100,
                                width: 100,
                              )),
                              const SizedBox(
                                height: 20,
                              ),
                              Align(
                                alignment: Alignment.center,
                                child: Text(
                                  'THANK YOU ',
                                  style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 40,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              Align(
                                alignment: Alignment.center,
                                child: Text(
                                  'your account has been successfully created',
                                  style: GoogleFonts.poppins(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400
                                      // fontFamily: 'poppins',
                                      ),
                                ),
                              ),
                              SizedBox(
                                height: size.height * 0.4,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 10.0, right: 10),
                                child: CommonButtonBlue(
                                  title: "CONTINUE",
                                  onPressed: () {
                                    Get.toNamed(MyRouters.loginScreen);
                                  },
                                ),
                              )
                            ])))).appPaddingForScreen));
  }
}
