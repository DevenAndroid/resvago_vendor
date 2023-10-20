import 'package:flutter/material.dart';
import 'package:resvago_vendor/widget/apptheme.dart';
class TotalEarningScreen extends StatefulWidget {
  const TotalEarningScreen({super.key});

  @override
  State<TotalEarningScreen> createState() => _TotalEarningScreenState();
}

class _TotalEarningScreenState extends State<TotalEarningScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: AppTheme.primaryColor,
              borderRadius: BorderRadius.only(bottomLeft:Radius.circular(10),bottomRight: Radius.circular(10))
            ),
            child: Row(
              children: [

              ],
            ),
          )
        ],
      ),
    );
  }
}
