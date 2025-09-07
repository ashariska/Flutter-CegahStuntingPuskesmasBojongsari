import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:stunting_web/constants/colors.dart';
import 'package:flutter/services.dart';
import 'package:stunting_web/constants/config.dart';
import 'package:stunting_web/constants/dialog_item.dart';
import 'package:stunting_web/constants/gsheet_helper.dart';
import 'package:stunting_web/widgets/forms/form_anak.dart';
import 'package:stunting_web/widgets/forms/form_diri.dart';
import 'package:stunting_web/widgets/forms/form_ibu.dart';
import 'package:stunting_web/widgets/forms/form_survey.dart';
import 'package:stunting_web/styles/style.dart';
// import 'package:stunting_web/widgets/hasil_survey.dart';

class SurveyWidget extends StatefulWidget {
  final Function(int)? onSubmit;
  const SurveyWidget({super.key, this.onSubmit});

  @override
  State<SurveyWidget> createState() => _SurveyWidgetState();
}

class _SurveyWidgetState extends State<SurveyWidget> {
  void confirmSubmit() async {
    final confirm = await DialogItem.showDialogItem(
      context: context,
      title: "Simpan Data",
      message: "Apakah Yakin Data yang Dimasukan Sudah Benar ?",
      confirmButtonText: "Ya, Simpan",
      cancelButtonText: "Batal",
      color: CustomColor.bgMain,
      icon: Icons.question_mark_outlined,
    );

    if (confirm == true) {
      if (formStunting.valid) {
        setState(() => _isLoading = true); // start loading

        try {
          final data = formStunting.value;

          final tglNow = DateFormat(
            "dd/MM/yyyy HH:mm:ss",
          ).format(DateTime.now());
          final DateFormat formatter = DateFormat('dd/MM/yyyy');
          final tanggalLahir = data['tanggal_lahir'] as DateTime?;

          final item = {
            "tgl": tglNow,
            "nama": data['nama'],
            "jenis_kelamin": data['jenis_kelamin'],
            'tanggal_lahir': tanggalLahir != null
                ? formatter.format(tanggalLahir)
                : null,
            "berat_badan": data['berat_badan'],
            "tinggi_badan": data['tinggi_badan'],
            "lingkar_kepala": data['lingkar_kepala'],
            "lingkar_lengan": data['lingkar_lengan'],
            "posisi_anak": data['posisi_anak'],
            "ibu_hamil": data['ibu_hamil'],
            "pendidikan_ibu": data['pendidikan_ibu'],
            "kondisi_ekonomi": data['kondisi_ekonomi'],
            "pemeriksaan_rutin": data['pemeriksaan_rutin'],
            "istirahat": data['istirahat'],
            "menghindari_rokok": data['menghindari_rokok'],
            "riwayat_penyakit": data['riwayat_penyakit'],
            "kesehatan_mental": data['kesehatan_mental'],
            "persalinan": data['persalinan'],
            "layanan_kesehatan": data['layanan_kesehatan'],
            "asi": data['asi'],
            "pendamping_asi": data['pendamping_asi'],
            "kualitas_mpasi": data['kualitas_mpasi'],
            "makan_anak": data['makan_anak'],
            "pola_makan": data['pola_makan'],
            "status_gizi": data['status_gizi'],
            "riwayat_imunisasi": data['riwayat_imunisasi'],
            "kebersihan_lingkungan": data['kebersihan_lingkungan'],
            "kebersihan_diri": data['kebersihan_diri'],
            "olahraga": data['olahraga'],
            "dukungan_keluarga": data['dukungan_keluarga'],
            "pola_asuh": data['pola_asuh'],
          };

          final row = await GSheetHelper.pushItemToSheet(spreadsheetId, item);

          if (widget.onSubmit != null) {
            widget.onSubmit!(row!);
          }

          formStunting.reset();

          General.showSnackBar(context, 'Data berhasil disimpan');
        } catch (e) {
          General.showSnackBar(context, 'Gagal menyimpan: $e');
        } finally {
          setState(() => _isLoading = false); // stop loading
        }
      } else {
        General.showSnackBar(context, 'Isi data terlebih dahulu');
        formStunting.markAllAsTouched();
      }
    }
  }

  bool _isLoading = false;
  final formStunting = FormGroup({
    'nama': FormControl<String>(
      validators: [
        Validators.required,
        Validators.minLength(5),
        Validators.maxLength(50),
      ],
    ),
    'jenis_kelamin': FormControl<String>(validators: [Validators.required]),
    'tanggal_lahir': FormControl<DateTime>(validators: [Validators.required]),
    'berat_badan': FormControl<String>(validators: [Validators.required]),
    'tinggi_badan': FormControl<String>(validators: [Validators.required]),
    'lingkar_kepala': FormControl<String>(validators: [Validators.required]),
    'lingkar_lengan': FormControl<String>(validators: [Validators.required]),
    'posisi_anak': FormControl<String>(validators: [Validators.required]),
    'ibu_hamil': FormControl<String>(validators: [Validators.required]),
    'pendidikan_ibu': FormControl<String>(validators: [Validators.required]),
    'kondisi_ekonomi': FormControl<String>(validators: [Validators.required]),
    'pemeriksaan_rutin': FormControl<String>(validators: [Validators.required]),
    'istirahat': FormControl<String>(validators: [Validators.required]),
    'menghindari_rokok': FormControl<String>(validators: [Validators.required]),
    'riwayat_penyakit': FormControl<String>(validators: [Validators.required]),
    'kesehatan_mental': FormControl<String>(validators: [Validators.required]),
    'persalinan': FormControl<String>(validators: [Validators.required]),
    'layanan_kesehatan': FormControl<String>(validators: [Validators.required]),
    'asi': FormControl<String>(validators: [Validators.required]),
    'pendamping_asi': FormControl<String>(validators: [Validators.required]),
    'kualitas_mpasi': FormControl<String>(validators: [Validators.required]),
    'makan_anak': FormControl<String>(validators: [Validators.required]),
    'pola_makan': FormControl<String>(validators: [Validators.required]),
    'status_gizi': FormControl<String>(validators: [Validators.required]),
    'riwayat_imunisasi': FormControl<String>(validators: [Validators.required]),
    'kebersihan_lingkungan': FormControl<String>(
      validators: [Validators.required],
    ),
    'kebersihan_diri': FormControl<String>(validators: [Validators.required]),
    'olahraga': FormControl<String>(validators: [Validators.required]),
    'dukungan_keluarga': FormControl<String>(validators: [Validators.required]),
    'pola_asuh': FormControl<String>(validators: [Validators.required]),
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColor.blueSecondary,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Center(
            // biar form tetap di tengah
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1000),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 8,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: ReactiveForm(
                  formGroup: formStunting,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // HEADER
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: CustomColor.greenMain,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(10.0),
                            topRight: Radius.circular(10.0),
                          ),
                        ),
                        child: Column(
                          children: [
                            Icon(
                              Icons.assignment,
                              size: 40,
                              color: Colors.white,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "Form Deteksi Stunting",
                              style: Theme.of(context).textTheme.titleLarge
                                  ?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      // === FORM FIELDS ===
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            FormDiri(),
                            const SizedBox(height: 16),
                            FormAnak(),
                            const SizedBox(height: 16),
                            FormIbu(),
                            const SizedBox(height: 16),
                            FormSurvey(),
                            const SizedBox(height: 16),
                            // Tombol submit
                            Center(
                              child: SizedBox(
                                width: 250,
                                height: 50,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: CustomColor.bluePrimary,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 16,
                                    ),
                                  ),
                                  onPressed: _isLoading ? null : confirmSubmit,
                                  child: _isLoading
                                      ? const SizedBox(
                                          height: 20,
                                          width: 20,
                                          child: CircularProgressIndicator(
                                            color: Colors.white,
                                            strokeWidth: 2,
                                          ),
                                        )
                                      : const Text(
                                          "Simpan",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
