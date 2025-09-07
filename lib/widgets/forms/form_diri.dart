import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';

class FormDiri extends StatelessWidget {
  const FormDiri({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Nama
        const Text(
          "1. Nama Anak",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
        ),
        ReactiveTextField<String>(
          formControlName: 'nama',
          decoration: const InputDecoration(
            hintText: 'Nama Lengkap Anak',
            helperText: "sebutkan nama anak anda",
            border: OutlineInputBorder(),
          ),
          validationMessages: {
            ValidationMessage.required: (_) => 'Nama wajib diisi',
          },
        ),
        const SizedBox(height: 16),

        // Dropdown jenis kelamin
        const Text(
          "2. Jenis Kelamin",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
        ),
        ReactiveDropdownField<String>(
          formControlName: 'jenis_kelamin',
          decoration: const InputDecoration(
            hintText: 'Jenis Kelamin Anak',
            helperText: "Pilih Jenis Kelamin",
            border: OutlineInputBorder(),
          ),
          items: const [
            DropdownMenuItem(value: 'Laki-laki', child: Text('Laki-laki')),
            DropdownMenuItem(value: 'Perempuan', child: Text('Perempuan')),
          ],
          validationMessages: {
            ValidationMessage.required: (_) => 'Pilih jenis kelamin',
          },
        ),
        const SizedBox(height: 16),

        // Umur
        const Text(
          "3. Usia Anak",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
        ),
        ReactiveDatePicker<DateTime>(
          formControlName: 'tanggal_lahir',
          fieldLabelText: "Pilih Tanggal Lahir",

          firstDate: DateTime(2000),
          lastDate: DateTime.now(),
          builder: (context, picker, child) {
            return InkWell(
              onTap: picker.showPicker,
              child: InputDecorator(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  helperText: "Masukkan Tanggal Lahir Anak",
                ),
                child: picker.value == null
                    ? const Text('Pilih tanggal')
                    : Text(
                        // Format hanya date, tanpa jam
                        "${picker.value!.day}-${picker.value!.month}-${picker.value!.year}",
                      ),
              ),
            );
          },
        ),
      ],
    );
  }
}
