import 'package:flutter/material.dart';

class CustomGradient {
  static const LinearGradient scaffoldGradient = LinearGradient(
    begin: Alignment.centerLeft, // posisi warna awal
    end: Alignment.bottomRight, // posisi warna akhir
    colors: [
      Color(0xFF14967f), // warna akhir
      Color(0xFF16b3ac), // warna awal
      Color(0xFFd2dc02), // warna tengah
    ],
    stops: [
      0.0, // posisi warna pertama
      0.5, // posisi warna kedua
      1.0, // posisi warna ketiga
    ],
  );
}
