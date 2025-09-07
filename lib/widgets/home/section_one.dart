import 'package:flutter/material.dart';
import 'package:stunting_web/constants/colors.dart';
import 'package:stunting_web/constants/utils.dart';

class SectionOne extends StatelessWidget {
  const SectionOne({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          width: double.infinity,
          height: 450.0,
          color: CustomColor.whiteSecondary,
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Image.asset(
                    'assets/home1.png',
                    width: MediaQuery.of(context).size.width * 0.5,
                    height: MediaQuery.of(context).size.width * 0.5,
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.only(
                    top: 75,
                    left: 75,
                    right: 75,
                    bottom: 75,
                  ),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(
                      24,
                    ), // biar isi teks ga nempel ke pinggir
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF9D00), // warna #ff9d00
                      borderRadius: BorderRadius.circular(
                        16,
                      ), // sudut melengkung
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(
                            0.2,
                          ), // bayangan lembut
                          blurRadius: 8, // tingkat blur
                          offset: const Offset(0, 4), // arah bayangan (x, y)
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "APA ITU STUNTING?",
                          style: TextStyle(
                            fontSize: constraints.maxWidth * 0.025,
                            fontWeight: FontWeight.w900,
                            color: Colors.white, // teks kontras sama background
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          InfoText.description[0],
                          textAlign: TextAlign.justify,
                          style: TextStyle(
                            fontSize: MediaQuery.of(context).size.width * 0.015,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
