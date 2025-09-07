import 'package:flutter/material.dart';
import 'package:stunting_web/constants/colors.dart';
import 'package:stunting_web/widgets/info_grid.dart';

class SectionThree extends StatelessWidget {
  const SectionThree({super.key});

  @override
  Widget build(BuildContext context) {
    final items = [
      InfoItem(
        iconPath: "assets/icons/anemia.svg",
        title: "Cegah Anemia",
        info: "Memberikan Tablet Tambah Darah Kepada Remaja Putri",
      ),
      InfoItem(
        iconPath: "assets/icons/ibu.svg",
        title: "Kesehatan Ibu",
        info: "Tambahan Suplemen & Makanan Bergizi Bagi Ibu Hamil/Menyusi",
      ),
      InfoItem(
        iconPath: "assets/icons/posyandu.svg",
        title: "Aktivasi Posyandu",
        info: "Mengaktifkan Kembali Pusat Untuk Memantau Tumbuh Kembang Anak",
      ),
      InfoItem(
        iconPath: "assets/icons/gizi.svg",
        title: "Akses Nutrisi",
        info: "Akses Asupan Bergizi bagi Ibu Hamil dan Balita",
      ),
      InfoItem(
        iconPath: "assets/icons/data.svg",
        title: "Sistem Pendataan",
        info: "Sistem Data Pemantauan Perkembangan Anak",
      ),
      InfoItem(
        iconPath: "assets/icons/sosialisasi.svg",
        title: "Sosialisasi",
        info: "Edukasi Mengenai Gizi dan Stunting Kepada Masyarakat",
      ),
      InfoItem(
        iconPath: "assets/icons/kolaborasi.svg",
        title: "Kolaboarasi",
        info: "Koordinasi Seluruh Pihak Terkait untuk Menangani Stunting",
      ),
    ];
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          width: double.infinity,
          color: Colors.grey[200],
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Text(
                "UPAYA PEMERINTAH",
                style: TextStyle(
                  fontSize: constraints.maxWidth * 0.03,
                  fontWeight: FontWeight.w900,
                  color: CustomColor.scaffoldBg,
                ),
              ),
              SizedBox(height: 30),
              InfoGrid(items: items),
              SizedBox(height: 30),
            ],
          ),
        );
      },
    );
  }
}
