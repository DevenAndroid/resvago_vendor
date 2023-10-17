import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../widget/addsize.dart';

class DashBoardCharts extends StatefulWidget {
  const DashBoardCharts({super.key});

  @override
  State<DashBoardCharts> createState() => _DashBoardChartsState();
}

class _DashBoardChartsState extends State<DashBoardCharts> {

  @override
  Widget build(BuildContext context) {
    return SliverGrid.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, childAspectRatio: 1.25, crossAxisSpacing: 12, mainAxisSpacing: 12),
      itemCount: 4,
      itemBuilder: (context, index) {
        return Card(
          margin: EdgeInsets.zero,
          elevation: 2,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: AddSize.padding16, vertical: AddSize.padding16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: AddSize.size10,
                ),
                Flexible(
                  child: Text(
                    "ff",
                    style: GoogleFonts.poppins(
                        height: 1.5, fontWeight: FontWeight.w600, fontSize: 20, color: const Color(0xFF454B5C)),
                  ),
                ),
                Flexible(
                  child: Text(
                    "223",
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall!
                        .copyWith(height: 1.5, fontWeight: FontWeight.w500, fontSize: 14, color: const Color(0xFF8C9BB2)),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}