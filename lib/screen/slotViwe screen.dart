import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:resvago_vendor/widget/custom_textfield.dart';
class SlotViewScreen extends StatefulWidget {
  const SlotViewScreen({super.key});

  @override
  State<SlotViewScreen> createState() => _SlotViewScreenState();
}

class _SlotViewScreenState extends State<SlotViewScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: backAppBar(title: "Slot View", context: context),
      body: Column(
        children: [
          SizedBox(height: 40,),
          Padding(
    padding: const EdgeInsets.all(8.0),
    child: Container(
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
    child: Column(
    children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Start Date",
                style: GoogleFonts.poppins(
                    color: const Color(0xFF1A2E33), fontWeight: FontWeight.w300, fontSize: 16),
              ),
              Text("10 Oct 2023",
                style: GoogleFonts.poppins(
                    color: const Color(0xFF1A2E33), fontWeight: FontWeight.w500, fontSize: 16),
              ),
            ],
          ),
          SizedBox(height: 10,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("End Date",
                style: GoogleFonts.poppins(
                    color: const Color(0xFF1A2E33), fontWeight: FontWeight.w300, fontSize: 16),
              ),
              Text("10 Oct 2023",
                style: GoogleFonts.poppins(
                    color: const Color(0xFF1A2E33), fontWeight: FontWeight.w500, fontSize: 16),
              ),
            ],
          ),
      SizedBox(height: 15,),
      FittedBox(
        child: Row(
          children: List.generate(
              25,
                  (index) => Padding(
                padding: const EdgeInsets.only(left: 2, right: 2),
                child: Container(
                  color: Colors.grey[200],
                  height: 2,
                  width: 10,
                ),
              )),
        ),
      ),
      SizedBox(height: 15,),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("Lunch Start Time ",
            style: GoogleFonts.poppins(
                color: const Color(0xFF1A2E33), fontWeight: FontWeight.w300, fontSize: 16),
          ),
          Text("12:30PM",
            style: GoogleFonts.poppins(
                color: const Color(0xFF1A2E33), fontWeight: FontWeight.w500, fontSize: 16),
          ),
        ],
      ),
      SizedBox(height: 10,),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("Lunch End Time ",
            style: GoogleFonts.poppins(
                color: const Color(0xFF1A2E33), fontWeight: FontWeight.w300, fontSize: 16),
          ),
          Text("02:30PM",
            style: GoogleFonts.poppins(
                color: const Color(0xFF1A2E33), fontWeight: FontWeight.w500, fontSize: 16),
          ),
        ],
      ),
      SizedBox(height: 15,),
      FittedBox(
        child: Row(
          children: List.generate(
              25,
                  (index) => Padding(
                padding: const EdgeInsets.only(left: 2, right: 2),
                child: Container(
                  color: Colors.grey[200],
                  height: 2,
                  width: 10,
                ),
              )),
        ),
      ),
      SizedBox(height: 15,),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("Number of Guest",
            style: GoogleFonts.poppins(
                color: const Color(0xFF1A2E33), fontWeight: FontWeight.w300, fontSize: 16),
          ),
          Text("12",
            style: GoogleFonts.poppins(
                color: const Color(0xFF1A2E33), fontWeight: FontWeight.w500, fontSize: 16),
          ),
        ],
      ),
      SizedBox(height: 10,),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("Interval TIme",
            style: GoogleFonts.poppins(
                color: const Color(0xFF1A2E33), fontWeight: FontWeight.w300, fontSize: 16),
          ),
          Text("30 Mint",
            style: GoogleFonts.poppins(
                color: const Color(0xFF1A2E33), fontWeight: FontWeight.w500, fontSize: 16),
          ),
        ],
      ),
      SizedBox(height: 10,),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("Total Booking",
            style: GoogleFonts.poppins(
                color: const Color(0xFF1A2E33), fontWeight: FontWeight.w300, fontSize: 16),
          ),
          Text("10",
            style: GoogleFonts.poppins(
                color: const Color(0xFF1A2E33), fontWeight: FontWeight.w500, fontSize: 16),
          ),
        ],
      ),
      SizedBox(height: 10,),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("Offers",
            style: GoogleFonts.poppins(
                color: const Color(0xFF1A2E33), fontWeight: FontWeight.w300, fontSize: 16),
          ),
          Text("30%",
            style: GoogleFonts.poppins(
                color: const Color(0xFF1A2E33), fontWeight: FontWeight.w500, fontSize: 16),
          ),
        ],
      ),
    ],
    ),
    )),
        ],
      ));
  }
}
