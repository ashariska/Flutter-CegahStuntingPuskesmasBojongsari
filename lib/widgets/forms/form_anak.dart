import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:reactive_forms/reactive_forms.dart';

class FormAnak extends StatelessWidget {
  const FormAnak({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //Berat Badan
        const Text(
          "4. Berat Badan (Kg)",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
        ),
        ReactiveTextField<String>(
          formControlName: 'berat_badan',
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [
            // izinkan angka + titik/koma satu kali
            FilteringTextInputFormatter.allow(RegExp(r'^\d*([,]\d*)?$')),
          ],
          decoration: const InputDecoration(
            hintText: "Masukan Berat Badan Anak",
            helperText: "Contoh : 3,7",
            border: OutlineInputBorder(),
          ),
          validationMessages: {
            ValidationMessage.required: (_) => 'Berat badan wajib diisi',
          },
        ),
        const SizedBox(height: 16),

        //Tinggi Badan
        const Text(
          "5. Tinggi Badan (cm)",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
        ),
        ReactiveTextField<String>(
          formControlName: 'tinggi_badan',
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [
            // izinkan angka + titik/koma satu kali
            FilteringTextInputFormatter.allow(RegExp(r'^\d*([,]\d*)?$')),
          ],
          decoration: const InputDecoration(
            helperText: "Contoh : 104.5",
            hintText: "Masukan Tinggi Badan Anak",
            border: OutlineInputBorder(),
          ),
          validationMessages: {
            ValidationMessage.required: (_) => 'Masukan Tinggi Badan Anak',
          },
        ),
        const SizedBox(height: 16),

        //Lingkar Kepala
        const Text(
          "6. Lingkar Kepala (cm)",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
        ),
        ReactiveTextField<String>(
          formControlName: 'lingkar_kepala',
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [
            // izinkan angka + titik/koma satu kali
            FilteringTextInputFormatter.allow(RegExp(r'^\d*([,]\d*)?$')),
          ],
          decoration: const InputDecoration(
            helperText: "Contoh : 36,5",
            hintText: "Masukan Ukuran Lingkar Kepala Anak",
            border: OutlineInputBorder(),
          ),
          validationMessages: {
            ValidationMessage.required: (_) => 'Masukan Lingkar Kepala Anak',
          },
        ),
        const SizedBox(height: 16),

        //Lingkar Lengan
        const Text(
          "7. Lingkar Lengan (cm)",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
        ),
        ReactiveTextField<String>(
          formControlName: 'lingkar_lengan',
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [
            // izinkan angka + titik/koma satu kali
            FilteringTextInputFormatter.allow(RegExp(r'^\d*([,]\d*)?$')),
          ],
          decoration: const InputDecoration(
            hintText: "Masukan Lingkar Tangan Anak",
            helperText: "Contoh : 12,5",
            border: OutlineInputBorder(),
          ),
          validationMessages: {
            ValidationMessage.required: (_) => 'Masukan Lingkar Tangan Anak',
          },
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
