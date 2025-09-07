import 'package:flutter/material.dart';
import 'package:stunting_web/widgets/footer.dart';
import 'package:stunting_web/widgets/home/section_four.dart';
import 'package:stunting_web/widgets/home/section_one.dart';
import 'package:stunting_web/widgets/home/section_three.dart';
import 'package:stunting_web/widgets/home/section_two.dart';

class HomeWidget extends StatelessWidget {
  const HomeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Scaffold(
          body: ListView(
            scrollDirection: Axis.vertical,
            children: [
              SectionOne(),
              SectionTwo(),
              SectionThree(),
              SectionFour(),
              Footer(),
            ],
          ),
        );
      },
    );
  }
}
