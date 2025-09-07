import 'package:flutter/material.dart';
import 'package:stunting_web/constants/utils.dart';

class SectionFour extends StatelessWidget {
  const SectionFour({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth =
        MediaQuery.maybeOf(context)?.size.width ??
        1200; // aman kalau MediaQuery null
    final text = (InfoText.description.length > 2)
        ? InfoText.description[2]
        : "Data tidak tersedia";

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(75),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: screenWidth * 0.4,
            child: Text(
              text,
              textAlign: TextAlign.justify,
              style: TextStyle(
                fontSize: screenWidth * 0.018,
                color: Colors.black87,
                height: 1.5,
              ),
            ),
          ),
          SizedBox(width: screenWidth * 0.05),
          SizedBox(
            width: screenWidth * 0.45,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Image.asset('assets/home2.png', width: screenWidth * 0.5),
            ),
          ),
        ],
      ),
    );
  }
}
