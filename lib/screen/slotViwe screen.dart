import 'package:flutter/material.dart';
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
    );
  }
}
