import 'package:flutter/material.dart';
import 'package:stunting_web/constants/colors.dart';

class Footer extends StatelessWidget {
  const Footer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: CustomColor.scaffoldBg,
        border: const Border(top: BorderSide(color: Colors.black12, width: 1)),
      ),
      child: const Center(
        child: Text(
          "© 2025 Puskesmas Bojongsari - Semua Hak Dilindungi",
          style: TextStyle(fontSize: 12, color: Colors.white),
        ),
      ),
    );
  }
}
