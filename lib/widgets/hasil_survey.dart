import 'package:flutter/material.dart';
import 'package:stunting_web/constants/colors.dart';
import 'package:stunting_web/constants/config.dart';
import 'package:stunting_web/constants/gsheet_helper.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:stunting_web/constants/fields_label.dart';

class HasilSurvey extends StatefulWidget {
  final int row;

  const HasilSurvey({super.key, required this.row});

  @override
  State<HasilSurvey> createState() => _HasilSurveyState();
}

class _HasilSurveyState extends State<HasilSurvey> {
  late Future<Map<String, dynamic>> futureData;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    futureData = GSheetHelper.fetchOneFromSheet(
      spreadsheetId: spreadsheetId,
      apiKey: gsheetApiKey,
      rowNumber: widget.row,
    );
  }

  /// Fungsi generate PDF
  Future<void> _generatePdf(Map<String, dynamic> data) async {
    final pdf = pw.Document();
    final logoData = await rootBundle.load('assets/logo.png');
    final logoImage = pw.MemoryImage(logoData.buffer.asUint8List());
    final fontData = await rootBundle.load("assets/fonts/Roboto-Regular.ttf");
    final printFont = pw.Font.ttf(fontData);

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (context) => [
          pw.Header(
            level: 0,
            child: pw.Row(
              crossAxisAlignment: pw.CrossAxisAlignment.center,
              children: [
                pw.Image(logoImage, width: 50, height: 50),
                pw.SizedBox(width: 16),
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      "Hasil Deteksi Stunting Anak",
                      style: pw.TextStyle(
                        fontSize: 20,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                    pw.SizedBox(height: 4),
                    pw.Text(
                      "Puskesmas Bojongsari",
                      style: pw.TextStyle(
                        fontSize: 14,
                        color: PdfColors.grey700,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // pw.SizedBox(height: 16),
          ...data.entries.map((e) {
            // final key = e.key.replaceAll("_", " ");
            // final formattedKey = toBeginningOfSentenceCase(key);
            // final value = e.value.toString();
            final key = fieldLabels[e.key] ?? e.key.replaceAll("_", " ");
            final value = e.value.toString();

            final isHighlight = [
              "indikasi_awal",
              "probabilitas_stunting",
              "probabilitas_normal",
              "indikasi",
              "rekomendasi",
            ].contains(e.key);

            return pw.Container(
              margin: const pw.EdgeInsets.symmetric(vertical: 4),
              padding: const pw.EdgeInsets.all(8),
              decoration: pw.BoxDecoration(
                color: isHighlight ? PdfColors.blue100 : PdfColors.white,
                borderRadius: pw.BorderRadius.circular(4),
                // border: pw.Border.all(color: PdfColors.grey300, width: 0.5),
              ),
              child: pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  // Key
                  pw.Expanded(
                    flex: 2,
                    child: pw.Text(
                      key,
                      style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  // Titik dua
                  pw.Text(
                    ":",
                    style: pw.TextStyle(
                      fontWeight: pw.FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                  pw.SizedBox(width: 6),
                  // Value
                  pw.Expanded(
                    flex: 3,
                    child: pw.Text(
                      value.isEmpty ? "-" : value,
                      style: pw.TextStyle(
                        font: printFont,
                        fontSize: 12,
                        fontWeight: isHighlight
                            ? pw.FontWeight.bold
                            : pw.FontWeight.normal,
                        color: isHighlight
                            ? PdfColors.blue900
                            : PdfColors.black,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );

    // Preview / download
    await Printing.layoutPdf(
      onLayout: (format) async => pdf.save(),
      name: "Hasil_Deteksi_Stunting.pdf",
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Detail Deteksi Stunting")),
      backgroundColor: CustomColor.blueSecondary,
      body: FutureBuilder<Map<String, dynamic>>(
        future: futureData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("Data tidak ditemukan"));
          }

          final data = snapshot.data!;

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1000),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.all(Radius.circular(12)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "📋 Hasil Deteksi Stunting Anak",
                              style: Theme.of(context).textTheme.headlineMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: CustomColor.scaffoldBg,
                                  ),
                            ),
                            FutureBuilder<Map<String, dynamic>>(
                              future: futureData,
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                        ConnectionState.done &&
                                    snapshot.hasData &&
                                    snapshot.data!.isNotEmpty) {
                                  return ElevatedButton(
                                    onPressed: _isLoading
                                        ? null
                                        : () async {
                                            setState(() => _isLoading = true);

                                            try {
                                              await _generatePdf(
                                                snapshot.data!,
                                              );
                                            } finally {
                                              setState(
                                                () => _isLoading = false,
                                              );
                                            }
                                          },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: CustomColor.bluePrimary,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                          50,
                                        ), // radius 50%
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 20,
                                        vertical: 12,
                                      ),
                                    ),
                                    child: _isLoading
                                        ? const SizedBox(
                                            height: 20,
                                            width: 20,
                                            child: CircularProgressIndicator(
                                              color: Colors.white,
                                              strokeWidth: 2,
                                            ),
                                          )
                                        : Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: const [
                                              Icon(
                                                Icons.download,
                                                color: Colors.white,
                                              ),
                                              SizedBox(width: 8),
                                              Text(
                                                "Download PDF",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ],
                                          ),
                                  );
                                }
                                return const SizedBox.shrink();
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Render data
                        // ...data.entries.map((e) {
                        //   final key = e.key.replaceAll("_", " ");
                        //   //.toUpperCase()
                        //   final value = e.value.toString();
                        ...data.entries.map((e) {
                          // ambil label dari map, fallback ke key asli (title case)
                          final key =
                              fieldLabels[e.key] ?? e.key.replaceAll("_", " ");
                          final value = e.value.toString();

                          // Highlight field khusus
                          final isHighlight = [
                            "indikasi_awal",
                            "probabilitas_stunting",
                            "probabilitas_normal",
                            "indikasi",
                            "rekomendasi",
                          ].contains(e.key);

                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 6.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    key,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 3,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 6,
                                      horizontal: 10,
                                    ),
                                    decoration: BoxDecoration(
                                      color: isHighlight
                                          ? CustomColor.blueSecondary
                                                .withOpacity(0.2)
                                          : Colors.transparent,
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text(
                                      value.isEmpty ? "-" : value,
                                      style: TextStyle(
                                        color: isHighlight
                                            ? CustomColor.bluePrimary
                                            : Colors.black87,
                                        fontWeight: isHighlight
                                            ? FontWeight.bold
                                            : FontWeight.normal,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
