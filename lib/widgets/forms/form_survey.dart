import 'package:flutter/material.dart';
import 'package:stunting_web/widgets/forms/ReactiveRadioGroup.dart';

class FormSurvey extends StatelessWidget {
  const FormSurvey({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "21. Kualitas MPASI",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
        ),
        const Text(
          "Apakah Ibu membuat MPASI sendiri atau membeli makanan instan?",
        ),
        ReactiveRadioGroup<String>(
          formControlName: 'kualitas_mpasi',
          options: [
            {'value': 'Instan', 'label': 'Instan'},
            {'value': 'Campuran', 'label': 'Campuran'},
            {'value': 'Buatan sendiri', 'label': 'Buatan sendiri'},
          ],
        ),

        const SizedBox(height: 16),
        const Text(
          "22. Pemberian Makan Anak",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
        ),
        const Text("Seberapa sering Ibu memberi makan anak dalam sehari?"),
        ReactiveRadioGroup<String>(
          formControlName: 'makan_anak',
          options: [
            {'value': '< 3 kali / hari', 'label': '< 3 kali / hari'},
            {'value': '3 - 5 kali / hari', 'label': '3 - 5 kali / hari'},
            {'value': '> 5 kali / hari', 'label': '> 5 kali / hari'},
          ],
        ),

        const SizedBox(height: 16),
        const Text(
          "23. Pola Makan Sehat",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
        ),
        const Text(
          "Apakah Ibu mengatur pola makan keluarga dengan memperhatikan gizi seimbang?",
        ),
        ReactiveRadioGroup<String>(
          formControlName: 'pola_makan',
          options: [
            {
              'value': 'Tidak memperhatikan gizi',
              'label': 'Tidak memperhatikan gizi',
            },
            {'value': 'Kadang seimbang', 'label': 'Kadang seimbang'},
            {'value': 'Sangat seimbang', 'label': 'Sangat seimbang'},
          ],
        ),

        const SizedBox(height: 16),
        const Text(
          "24. Status Gizi Ibu Hamil",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
        ),
        const Text(
          "Apakah Ibu rutin mengonsumsi suplemen zat besi atau vitamin dari puskesmas?",
        ),
        ReactiveRadioGroup<String>(
          formControlName: 'status_gizi',
          options: [
            {'value': 'Tidak minum suplemen', 'label': 'Tidak minum suplemen'},
            {'value': 'Kadang minum', 'label': 'Kadang minum'},
            {'value': 'Rutin minum', 'label': 'Rutin minum'},
          ],
        ),

        const SizedBox(height: 16),
        const Text(
          "25. Riwayat Imunisasi",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
        ),
        const Text(
          "Apakah anak Ibu sudah mendapatkan imunisasi dasar lengkap?",
        ),
        ReactiveRadioGroup<String>(
          formControlName: 'riwayat_imunisasi',
          options: [
            {'value': 'Tidak imunisasi', 'label': 'Tidak imunisasi'},
            {'value': 'Imunisasi sebagian', 'label': 'Imunisasi sebagian'},
            {'value': 'Imunisasi lengkap', 'label': 'Imunisasi lengkap'},
          ],
        ),

        const SizedBox(height: 16),
        const Text(
          "26. Kebersihan Lingkungan",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
        ),
        const Text(
          "Seberapa sering Ibu membersihkan rumah dan apakah rumah Ibu memiliki saluran pembuangan serta tempat sampah yang layak?",
        ),
        ReactiveRadioGroup<String>(
          formControlName: 'kebersihan_lingkungan',
          options: [
            {'value': 'Buruk', 'label': 'Buruk'},
            {'value': 'Sedang', 'label': 'Sedang'},
            {'value': 'Baik', 'label': 'Baik'},
          ],
        ),

        const SizedBox(height: 16),
        const Text(
          "27. Kebersihan Diri",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
        ),
        const Text(
          "Apakah Ibu rutin mencuci tangan sebelum makan dan setelah dari toilet?",
        ),
        ReactiveRadioGroup<String>(
          formControlName: 'kebersihan_diri',
          options: [
            {'value': 'Tidak rutin', 'label': 'Tidak rutin'},
            {'value': 'Kadang-kadang', 'label': 'Kadang-kadang'},
            {'value': 'Sangat rutin', 'label': 'Sangat rutin'},
          ],
        ),

        const SizedBox(height: 16),
        const Text(
          "28. Olahraga",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
        ),
        const Text(
          "Apakah Ibu memiliki waktu untuk melakukan aktivitas fisik atau olahraga ringan?",
        ),
        ReactiveRadioGroup<String>(
          formControlName: 'olahraga',
          options: [
            {'value': 'Tidak pernah', 'label': 'Tidak pernah'},
            {'value': 'Kadang', 'label': 'Kadang'},
            {'value': 'Rutin', 'label': 'Rutin'},
          ],
        ),

        const SizedBox(height: 16),
        const Text(
          "29. Dukungan Keluarga",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
        ),
        const Text(
          "Apakah Ibu mendapatkan dukungan dari keluarga dalam mengasuh anak?",
        ),
        ReactiveRadioGroup<String>(
          formControlName: 'dukungan_keluarga',
          options: [
            {'value': 'Tidak ada', 'label': 'Tidak ada'},
            {'value': 'Kadang ada', 'label': 'Kadang ada'},
            {'value': 'Selalu mendukung', 'label': 'Selalu mendukung'},
          ],
        ),

        const SizedBox(height: 16),
        const Text(
          "30. Pola Asuh",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
        ),
        const Text("Bagaimana pola pengasuhan ibu terhadap anak?"),
        ReactiveRadioGroup<String>(
          formControlName: 'pola_asuh',
          options: [
            {'value': 'Otoriter', 'label': 'Otoriter'},
            {'value': 'Demokratis', 'label': 'Demokratis'},
            {'value': 'Permisif', 'label': 'Permisif'},
          ],
        ),
      ],
    );
  }
}
