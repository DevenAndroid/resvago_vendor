import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:resvago_vendor/widget/custom_textfield.dart';
class SlotListScreen extends StatefulWidget {
  const SlotListScreen({super.key});

  @override
  State<SlotListScreen> createState() => _SlotListScreenState();
}

class _SlotListScreenState extends State<SlotListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: backAppBar(title: "Slot List", context: context),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 10,),
            ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                physics: NeverScrollableScrollPhysics(),
                itemCount:6,
                itemBuilder: (context, index) {
                  return

                    Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          padding: EdgeInsets.all(14),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10)

                          ),
                          child: Row(
                            children: [

                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Start Date", style: GoogleFonts.poppins(
                                      color: const Color(0xFF1A2E33),
                                      fontWeight: FontWeight.w300,
                                      fontSize: 14),),
                                  Text("10 Oct 2023", style: GoogleFonts.poppins(
                                      color: const Color(0xFF1A2E33),
                                      fontWeight: FontWeight.w500,
                                      fontSize: 15),),
                                ],
                              ),
                              Spacer(),
                              Icon(Icons.remove_red_eye_outlined)
                            ],
                          ),));
                    })],
        ),
      ),
    );
  }
}
