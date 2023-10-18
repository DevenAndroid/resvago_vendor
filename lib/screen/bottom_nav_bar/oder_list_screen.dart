import 'package:flutter/material.dart';
class OderListScreen extends StatefulWidget {
  const OderListScreen({super.key});

  @override
  State<OderListScreen> createState() => _OderListScreenState();
}

class _OderListScreenState extends State<OderListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text("Oder List ")),
    );
  }
}
