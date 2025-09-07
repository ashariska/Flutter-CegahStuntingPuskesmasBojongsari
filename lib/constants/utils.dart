import 'package:reactive_forms/reactive_forms.dart';

class idDoubleValueAccessor extends ControlValueAccessor<double, String> {
  idDoubleValueAccessor._();
  static final instance = idDoubleValueAccessor._();

  @override
  String? modelToViewValue(double? modelValue) {
    return modelValue?.toString();
  }

  @override
  double? viewToModelValue(String? viewValue) {
    if (viewValue == null) return null;
    final text = viewValue.trim();
    if (text.isEmpty) return null;
    return double.tryParse(text.replaceAll(',', '.'));
  }
}

class FormUtils {
  static FormGroup buildFormStunting() {
    return FormGroup({
      'nama': FormControl<String>(
        validators: [
          Validators.required,
          Validators.minLength(5),
          Validators.maxLength(50),
        ],
      ),
      'tanggal_lahir': FormControl<DateTime>(validators: [Validators.required]),
      'jenis_kelamin': FormControl<String>(validators: [Validators.required]),
      'berat_badan': FormControl<double>(
        validators: [Validators.required, Validators.min(0)],
      ),
      'tinggi_badan': FormControl<double>(validators: [Validators.required]),
      'lingkar_kepala': FormControl<double>(validators: [Validators.required]),
      'lingkar_lengan': FormControl<double>(validators: [Validators.required]),
      'posisi_anak': FormControl<String>(validators: [Validators.required]),
      'ibu_hamil': FormControl<String>(validators: [Validators.required]),
      'pendidikan_ibu': FormControl<String>(validators: [Validators.required]),
      'kondisi_ekonomi': FormControl<String>(validators: [Validators.required]),
      'pemeriksaan': FormControl<String>(validators: [Validators.required]),
      'istirahat': FormControl<String>(validators: [Validators.required]),
      'menghidari_rokok': FormControl<String>(
        validators: [Validators.required],
      ),
      'riwayat_penyakit': FormControl<String>(
        validators: [Validators.required],
      ),
      'kesehatan_mental': FormControl<String>(
        validators: [Validators.required],
      ),
      'persalinan': FormControl<String>(validators: [Validators.required]),
      'layanan_kesehatan': FormControl<String>(
        validators: [Validators.required],
      ),
      'asi': FormControl<String>(validators: [Validators.required]),
      'pendamping_asi': FormControl<String>(validators: [Validators.required]),
      'makan_anak': FormControl<String>(validators: [Validators.required]),
      'pola_makan': FormControl<String>(validators: [Validators.required]),
      'status_gizi': FormControl<String>(validators: [Validators.required]),
      'riwayat_imunisasi': FormControl<String>(
        validators: [Validators.required],
      ),
      'kebersihan_lingkungan': FormControl<String>(
        validators: [Validators.required],
      ),
      'kebersihan_diri': FormControl<String>(validators: [Validators.required]),
      'olahraga': FormControl<String>(validators: [Validators.required]),
      'dukungan_keluarga': FormControl<String>(
        validators: [Validators.required],
      ),
      'pola_asuh': FormControl<String>(validators: [Validators.required]),
    });
  }
}

class InfoText {
  static const List<String> description = [
    "Kondisi gagal pada proses pertumbuhan dan perkembangan anak balita akibat kekurangan gizi sejak dalam kandungan, yang ditandai dengan tubuh lebih pendek atau kerdil dibandingkan dengan anak seusianya.",
    "Pemerintah berupaya menurunkan angka stunting di Indonesia. Data kementerian kesehatan menunjukkan pravelensi stunting nasional pada tahun 2021 mencapai 24,4%. Angka ini melebihi batas yang ditetapkan WHO (World Health Organization), yakni dibawah 20%",
    "Kita ditugaskan menurunkan angka Stunting dari 24% ke 14% pada 2024. Untuk bisa menurunkannya pastikan gizi terpenuhi bahkan sejak remaja dan saat ibu hamil, karena kondisi ini paling rawan yang bisa menyebabkan stunting",
  ];
}
