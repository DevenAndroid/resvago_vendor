import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:resvago_vendor/widget/custom_textfield.dart';
class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  bool state = false;
  bool state1 = false;
  bool state2 = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: backAppBar(title: "Setting ", context: context),
      body: Column(
        children: [
          SizedBox(height: 20,),
      Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),

            child: Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Row(
                children: [

                  Text(
                    "Set Delivery",
                    style: GoogleFonts.poppins(
                        color: const Color(0xFF292F45),
                        fontSize: 15,
                        fontWeight: FontWeight.w400),
                  ),
                  const Spacer(),

                  CupertinoSwitch(

                    value:state,
                    activeColor: const Color(0xffFAAF40),
                    onChanged: (value) {
                      state = value;
                      setState(() {

                      });
                    },
                  ),

                ],
              ),
            ),
          ),
      ),
          SizedBox(height: 10,),

          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),

              child: Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Row(
                  children: [

                    Text(
                      "Cancellation",
                      style: GoogleFonts.poppins(
                          color: const Color(0xFF292F45),
                          fontSize: 15,
                          fontWeight: FontWeight.w400),
                    ),
                    const Spacer(),

                    CupertinoSwitch(

                      value:state1,
                      activeColor: const Color(0xffFAAF40),
                      onChanged: (value) {
                        state1 = value;
                        setState(() {

                        });
                      },
                    ),

                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: 10,),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),

              child: Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Row(
                  children: [

                    Text(
                      "Menu selection",
                      style: GoogleFonts.poppins(
                          color: const Color(0xFF292F45),
                          fontSize: 15,
                          fontWeight: FontWeight.w400),
                    ),
                    const Spacer(),

                    CupertinoSwitch(

                      value:state2,
                      activeColor: const Color(0xffFAAF40),
                      onChanged: (value) {
                        state2 = value;
                        setState(() {

                        });
                      },
                    ),

                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: 10,),
        ],
      ),
    );
  }
}
