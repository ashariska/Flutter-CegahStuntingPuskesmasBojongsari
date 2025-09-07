import 'package:flutter/material.dart';
import 'package:stunting_web/constants/colors.dart';
import 'package:stunting_web/constants/utils.dart';

class SectionTwo extends StatelessWidget {
  const SectionTwo({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          width: double.infinity,
          height: 250.0,
          color: CustomColor.greenMain,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "MENURUNKAN ANGKA STUNTING DI INDONESIA",
                  style: TextStyle(
                    fontSize: constraints.maxWidth * 0.03,
                    fontWeight: FontWeight.w900,
                    color: CustomColor.bgSecondary,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  InfoText.description[1],
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: constraints.maxWidth * 0.015,
                    color: Colors.white,
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
