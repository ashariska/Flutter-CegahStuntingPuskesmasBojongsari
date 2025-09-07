import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:stunting_web/constants/config.dart';
import 'package:googleapis/sheets/v4.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:stunting_web/constants/formula.dart';

class GSheetHelper {
  static Future<SheetsApi> getSheetsApi() async {
    // get credentials service account from spreadsheet
    final range = "'WHO_DATA'!U2";
    final url = Uri.parse(
      'https://sheets.googleapis.com/v4/spreadsheets/$spreadsheetId/values/$range?key=$gsheetApiKey',
    );
    var credentialsJson = "";
    final resCredential = await http.get(url);
    if (resCredential.statusCode == 200) {
      final decoded = jsonDecode(resCredential.body);
      final rows = decoded['values'] as List<dynamic>? ?? [];
      for (var i = 0; i < rows.length; i++) {
        final row = rows[i] as List<dynamic>;
        credentialsJson = (row.isNotEmpty) ? row[0].toString() : '';
      }
    }
    final credentials = ServiceAccountCredentials.fromJson(
      json.decode(credentialsJson),
    );

    final scopes = [SheetsApi.spreadsheetsScope];

    final client = await clientViaServiceAccount(credentials, scopes);

    return SheetsApi(client);
  }

  static Future<List<Map<String, dynamic>>> fetchFromSheet({
    required String spreadsheetId,
    required String apiKey,
  }) async {
    final range = "'Form data siap olah (naive bayes)'!A2:CT";
    final url = Uri.parse(
      'https://sheets.googleapis.com/v4/spreadsheets/$spreadsheetId/values/$range?key=$apiKey',
    );

    final res = await http.get(url);

    if (res.statusCode == 200) {
      final decoded = jsonDecode(res.body);
      final rows = decoded['values'] as List<dynamic>? ?? [];

      final List<Map<String, dynamic>> results = [];

      for (var i = 0; i < rows.length; i++) {
        final row = rows[i] as List<dynamic>;
        final rowNumber = i + 2;
        final tgl = (row.length > 0) ? row[0].toString() : '';
        final nama = (row.length > 1) ? row[1].toString() : '';
        final jenis_kelamin = (row.length > 2) ? row[2].toString() : '';
        final usia = (row.length > 3) ? row[3].toString() : '';
        final is_stunting = (row.length > 96) ? row[96].toString() : '';

        results.add({
          'row': rowNumber,
          'tgl': tgl,
          'nama': nama,
          'jenis_kelamin': jenis_kelamin,
          'usia': usia,
          'is_stunting': is_stunting,
        });
      }
      return results;
    } else {
      return []; // return kosong biar tetap aman
    }
  }

  static Future<Map<String, dynamic>> fetchOneFromSheet({
    required String spreadsheetId,
    required String apiKey,
    required int rowNumber,
  }) async {
    Map<String, dynamic> data = {};

    // Data dari form data setengah mateng
    final rangeSetengahMateng =
        "'Form data setengah mateng'!A$rowNumber:AF$rowNumber";
    final urlSetengahMateng = Uri.parse(
      'https://sheets.googleapis.com/v4/spreadsheets/$spreadsheetId/values/$rangeSetengahMateng?key=$apiKey',
    );
    final resSetengahMateng = await http.get(urlSetengahMateng);
    if (resSetengahMateng.statusCode == 200) {
      final decoded = jsonDecode(resSetengahMateng.body);
      final rows = decoded['values'] as List<dynamic>? ?? [];

      final row = rows.first as List<dynamic>;
      data['tanggal'] = row[0].toString();
      data['nama'] = row[1].toString();
      data['jenis_kelamin'] = row[2].toString();
      data['usia'] = row[3].toString().replaceAll("–", "-");
      data['berat_badan_terhadap_umur'] = row[4].toString();
      data['tinggi_badan_terhadap_umur'] = row[5].toString();
      data['berat_badan_terhadap_tinggi'] = row[6].toString();
      data['lingkar_kepala_terhadap_umur'] = row[7].toString();
      data['lingkar_lengan_atas'] = row[8].toString();
      data['posisi_anak'] = row[9].toString();
      data['ibu_hamil'] = row[10].toString();
      data['pendidikan_ibu'] = row[11].toString();
      data['kondisi_ekonomi'] = row[12].toString().replaceAll("–", "-");
      data['pemeriksaan_rutin'] = row[13].toString();
      data['istirahat'] = row[14].toString();
      data['menghindari_rokok'] = row[15].toString();
      data['riwayat_penyakit'] = row[16].toString();
      data['kesehatan_mental'] = row[17].toString();
      data['persalinan'] = row[18].toString();
      data['layanan_kesehatan'] = row[19].toString();
      data['asi'] = row[20].toString();
      data['pendamping_asi'] = row[21].toString();
      data['kualitas_mpasi'] = row[22].toString();
      data['makan_anak'] = row[23].toString();
      data['pola_makan'] = row[24].toString();
      data['status_gizi'] = row[25].toString();
      data['riwayat_imunisasi'] = row[26].toString();
      data['kebersihan_lingkungan'] = row[27].toString();
      data['kebersihan_diri'] = row[28].toString();
      data['olahraga'] = row[29].toString();
      data['dukungan_keluarga'] = row[30].toString();
      data['pola_asuh'] = row[31].toString();
    }

    // Data dari form data siap olah (stunting ground truth)
    final rangeStuntingGroundTruth =
        "'Form data siap olah (naive bayes)'!AG$rowNumber";
    final urlStuntingroundTruth = Uri.parse(
      'https://sheets.googleapis.com/v4/spreadsheets/$spreadsheetId/values/$rangeStuntingGroundTruth?key=$apiKey',
    );
    final resStuntingGroundTruth = await http.get(urlStuntingroundTruth);
    if (resStuntingGroundTruth.statusCode == 200) {
      final decoded = jsonDecode(resStuntingGroundTruth.body);
      final rows = decoded['values'] as List<dynamic>? ?? [];

      final row = rows.first as List<dynamic>;
      data['indikasi_awal'] = row[0].toString() == "1" ? "Stunting" : "Normal";
    }

    // Data dari form data siap olah (probabilitas stunting dan normal)
    final rangeProbabilitas =
        "'Form data siap olah (naive bayes)'!CQ$rowNumber:CR$rowNumber";
    final urlProbabilitas = Uri.parse(
      'https://sheets.googleapis.com/v4/spreadsheets/$spreadsheetId/values/$rangeProbabilitas?key=$apiKey',
    );
    final resProbabilitas = await http.get(urlProbabilitas);
    if (resProbabilitas.statusCode == 200) {
      final decoded = jsonDecode(resProbabilitas.body);
      final rows = decoded['values'] as List<dynamic>? ?? [];

      final row = rows.first as List<dynamic>;
      data['probabilitas_stunting'] = row[0].toString() == "Data tidak terpakai"
          ? "-"
          : row[0].toString();
      data['probabilitas_normal'] = row[1].toString() == "Data tidak terpakai"
          ? "-"
          : row[1].toString();
    }

    // Data dari form data siap olah (indikasi dan rekomendasi)
    final rangeRekomen =
        "'Form data siap olah (naive bayes)'!CX$rowNumber:CY$rowNumber";
    final urlRekomen = Uri.parse(
      'https://sheets.googleapis.com/v4/spreadsheets/$spreadsheetId/values/$rangeRekomen?key=$apiKey',
    );
    final resRekomen = await http.get(urlRekomen);
    if (resRekomen.statusCode == 200) {
      final decoded = jsonDecode(resRekomen.body);
      if (decoded.containsKey('values')) {
        final rows = decoded['values'] as List<dynamic>? ?? [];
        final row = rows.first as List<dynamic>;
        data['indikasi'] = Formula.formatItemIndikasiDanRekomendasi(
          row[0].toString(),
        );
        data['rekomendasi'] = Formula.formatItemIndikasiDanRekomendasi(
          row[1].toString(),
        );
      } else {
        data['indikasi'] = "-";
        data['rekomendasi'] = "-";
      }
    }

    return data;
  }

  static Future<int?> pushItemToSheet(
    String spreadsheetId,
    Map<String, dynamic> data,
  ) async {
    final sheetsApi = await getSheetsApi();

    final values = [
      [
        data['tgl'] ?? "",
        data["nama"] ?? "",
        data["jenis_kelamin"] ?? "",
        data['tanggal_lahir'] ?? "",
        data["berat_badan"] ?? "",
        data["tinggi_badan"] ?? "",
        data["lingkar_kepala"] ?? "",
        data["lingkar_lengan"] ?? "",
        data["posisi_anak"] ?? "",
        data["ibu_hamil"] ?? "",
        data["pendidikan_ibu"] ?? "",
        data["kondisi_ekonomi"] ?? "",
        data["pemeriksaan_rutin"] ?? "",
        data["istirahat"] ?? "",
        data["menghindari_rokok"] ?? "",
        data["riwayat_penyakit"] ?? "",
        data["kesehatan_mental"] ?? "",
        data["persalinan"] ?? "",
        data["layanan_kesehatan"] ?? "",
        data["asi"] ?? "",
        data["pendamping_asi"] ?? "",
        data["kualitas_mpasi"] ?? "",
        data["makan_anak"] ?? "",
        data["pola_makan"] ?? "",
        data["status_gizi"] ?? "",
        data["riwayat_imunisasi"] ?? "",
        data["kebersihan_lingkungan"] ?? "",
        data["kebersihan_diri"] ?? "",
        data["olahraga"] ?? "",
        data["dukungan_keluarga"] ?? "",
        data["pola_asuh"] ?? "",
      ],
    ];

    final response = await sheetsApi.spreadsheets.values.append(
      ValueRange.fromJson({"values": values}),
      spreadsheetId,
      nameFormResponses1,
      valueInputOption: "USER_ENTERED",
    );

    int? rowNumber;
    final updatedRange = response.updates?.updatedRange;
    if (updatedRange != null) {
      final match = RegExp(r'[A-Z]+(\d+):').firstMatch(updatedRange);
      if (match != null) {
        rowNumber = int.tryParse(match.group(1)!);
      }
    }

    // insert to Form data setengah mateng
    final valuesSetMateng = [
      [
        "='Form Responses 1'!A$rowNumber",
        "='Form Responses 1'!B$rowNumber",
        "='Form Responses 1'!C$rowNumber",
        Formula.getFormula("setengah_mateng_d", rowNumber!),
        Formula.getFormula("setengah_mateng_e", rowNumber),
        Formula.getFormula("setengah_mateng_f", rowNumber),
        Formula.getFormula("setengah_mateng_g", rowNumber),
        Formula.getFormula("setengah_mateng_h", rowNumber),
        Formula.getFormula("setengah_mateng_i", rowNumber),
        "='Form Responses 1'!I$rowNumber",
        "='Form Responses 1'!J$rowNumber",
        "='Form Responses 1'!K$rowNumber",
        "='Form Responses 1'!L$rowNumber",
        "='Form Responses 1'!M$rowNumber",
        "='Form Responses 1'!N$rowNumber",
        "='Form Responses 1'!O$rowNumber",
        "='Form Responses 1'!P$rowNumber",
        "='Form Responses 1'!Q$rowNumber",
        "='Form Responses 1'!R$rowNumber",
        "='Form Responses 1'!S$rowNumber",
        "='Form Responses 1'!T$rowNumber",
        "='Form Responses 1'!U$rowNumber",
        "='Form Responses 1'!V$rowNumber",
        "='Form Responses 1'!W$rowNumber",
        "='Form Responses 1'!X$rowNumber",
        "='Form Responses 1'!Y$rowNumber",
        "='Form Responses 1'!Z$rowNumber",
        "='Form Responses 1'!AA$rowNumber",
        "='Form Responses 1'!AB$rowNumber",
        "='Form Responses 1'!AC$rowNumber",
        "='Form Responses 1'!AD$rowNumber",
        "='Form Responses 1'!AE$rowNumber",
      ],
    ];
    await sheetsApi.spreadsheets.values.append(
      ValueRange.fromJson({"values": valuesSetMateng}),
      spreadsheetId,
      nameFormSetengahMateng,
      valueInputOption: "USER_ENTERED",
    );

    // insert to Form data siap olah (naive bayes)
    final valuesSiapOlah = [
      [
        "='Form data setengah mateng'!A$rowNumber",
        "='Form data setengah mateng'!B$rowNumber",
        "='Form data setengah mateng'!C$rowNumber",
        "='Form data setengah mateng'!D$rowNumber",
        Formula.getFormula("siap_olah_e", rowNumber),
        Formula.getFormula("siap_olah_f", rowNumber),
        Formula.getFormula("siap_olah_g", rowNumber),
        Formula.getFormula("siap_olah_h", rowNumber),
        Formula.getFormula("siap_olah_i", rowNumber),
        Formula.getFormula("siap_olah_j", rowNumber),
        Formula.getFormula("siap_olah_k", rowNumber),
        Formula.getFormula("siap_olah_l", rowNumber),
        Formula.getFormula("siap_olah_m", rowNumber),
        Formula.getFormula("siap_olah_n", rowNumber),
        Formula.getFormula("siap_olah_o", rowNumber),
        Formula.getFormula("siap_olah_p", rowNumber),
        Formula.getFormula("siap_olah_q", rowNumber),
        Formula.getFormula("siap_olah_r", rowNumber),
        Formula.getFormula("siap_olah_s", rowNumber),
        Formula.getFormula("siap_olah_t", rowNumber),
        Formula.getFormula("siap_olah_u", rowNumber),
        Formula.getFormula("siap_olah_v", rowNumber),
        Formula.getFormula("siap_olah_w", rowNumber),
        Formula.getFormula("siap_olah_x", rowNumber),
        Formula.getFormula("siap_olah_y", rowNumber),
        Formula.getFormula("siap_olah_z", rowNumber),
        Formula.getFormula("siap_olah_aa", rowNumber),
        Formula.getFormula("siap_olah_ab", rowNumber),
        Formula.getFormula("siap_olah_ac", rowNumber),
        Formula.getFormula("siap_olah_ad", rowNumber),
        Formula.getFormula("siap_olah_ae", rowNumber),
        Formula.getFormula("siap_olah_af", rowNumber),
        "=IF(F$rowNumber=0;1;0)",
        Formula.getFormula("siap_olah_ah", rowNumber),
        "",
        "",
        Formula.getFormula("siap_olah_ak_bl", rowNumber, colLikelihood: "E"),
        Formula.getFormula("siap_olah_ak_bl", rowNumber, colLikelihood: "F"),
        Formula.getFormula("siap_olah_ak_bl", rowNumber, colLikelihood: "G"),
        Formula.getFormula("siap_olah_ak_bl", rowNumber, colLikelihood: "H"),
        Formula.getFormula("siap_olah_ak_bl", rowNumber, colLikelihood: "I"),
        Formula.getFormula("siap_olah_ak_bl", rowNumber, colLikelihood: "J"),
        Formula.getFormula("siap_olah_ak_bl", rowNumber, colLikelihood: "K"),
        Formula.getFormula("siap_olah_ak_bl", rowNumber, colLikelihood: "L"),
        Formula.getFormula("siap_olah_ak_bl", rowNumber, colLikelihood: "M"),
        Formula.getFormula("siap_olah_ak_bl", rowNumber, colLikelihood: "N"),
        Formula.getFormula("siap_olah_ak_bl", rowNumber, colLikelihood: "O"),
        Formula.getFormula("siap_olah_ak_bl", rowNumber, colLikelihood: "P"),
        Formula.getFormula("siap_olah_ak_bl", rowNumber, colLikelihood: "Q"),
        Formula.getFormula("siap_olah_ak_bl", rowNumber, colLikelihood: "R"),
        Formula.getFormula("siap_olah_ak_bl", rowNumber, colLikelihood: "S"),
        Formula.getFormula("siap_olah_ak_bl", rowNumber, colLikelihood: "T"),
        Formula.getFormula("siap_olah_ak_bl", rowNumber, colLikelihood: "U"),
        Formula.getFormula("siap_olah_ak_bl", rowNumber, colLikelihood: "V"),
        Formula.getFormula("siap_olah_ak_bl", rowNumber, colLikelihood: "W"),
        Formula.getFormula("siap_olah_ak_bl", rowNumber, colLikelihood: "X"),
        Formula.getFormula("siap_olah_ak_bl", rowNumber, colLikelihood: "Y"),
        Formula.getFormula("siap_olah_ak_bl", rowNumber, colLikelihood: "Z"),
        Formula.getFormula("siap_olah_ak_bl", rowNumber, colLikelihood: "AA"),
        Formula.getFormula("siap_olah_ak_bl", rowNumber, colLikelihood: "AB"),
        Formula.getFormula("siap_olah_ak_bl", rowNumber, colLikelihood: "AC"),
        Formula.getFormula("siap_olah_ak_bl", rowNumber, colLikelihood: "AD"),
        Formula.getFormula("siap_olah_ak_bl", rowNumber, colLikelihood: "AE"),
        Formula.getFormula("siap_olah_ak_bl", rowNumber, colLikelihood: "AF"),
        Formula.getFormula("siap_olah_bm_cn", rowNumber, colLikelihood: "E"),
        Formula.getFormula("siap_olah_bm_cn", rowNumber, colLikelihood: "F"),
        Formula.getFormula("siap_olah_bm_cn", rowNumber, colLikelihood: "G"),
        Formula.getFormula("siap_olah_bm_cn", rowNumber, colLikelihood: "H"),
        Formula.getFormula("siap_olah_bm_cn", rowNumber, colLikelihood: "I"),
        Formula.getFormula("siap_olah_bm_cn", rowNumber, colLikelihood: "J"),
        Formula.getFormula("siap_olah_bm_cn", rowNumber, colLikelihood: "K"),
        Formula.getFormula("siap_olah_bm_cn", rowNumber, colLikelihood: "L"),
        Formula.getFormula("siap_olah_bm_cn", rowNumber, colLikelihood: "M"),
        Formula.getFormula("siap_olah_bm_cn", rowNumber, colLikelihood: "N"),
        Formula.getFormula("siap_olah_bm_cn", rowNumber, colLikelihood: "O"),
        Formula.getFormula("siap_olah_bm_cn", rowNumber, colLikelihood: "P"),
        Formula.getFormula("siap_olah_bm_cn", rowNumber, colLikelihood: "Q"),
        Formula.getFormula("siap_olah_bm_cn", rowNumber, colLikelihood: "R"),
        Formula.getFormula("siap_olah_bm_cn", rowNumber, colLikelihood: "S"),
        Formula.getFormula("siap_olah_bm_cn", rowNumber, colLikelihood: "T"),
        Formula.getFormula("siap_olah_bm_cn", rowNumber, colLikelihood: "U"),
        Formula.getFormula("siap_olah_bm_cn", rowNumber, colLikelihood: "V"),
        Formula.getFormula("siap_olah_bm_cn", rowNumber, colLikelihood: "W"),
        Formula.getFormula("siap_olah_bm_cn", rowNumber, colLikelihood: "X"),
        Formula.getFormula("siap_olah_bm_cn", rowNumber, colLikelihood: "Y"),
        Formula.getFormula("siap_olah_bm_cn", rowNumber, colLikelihood: "Z"),
        Formula.getFormula("siap_olah_bm_cn", rowNumber, colLikelihood: "AA"),
        Formula.getFormula("siap_olah_bm_cn", rowNumber, colLikelihood: "AB"),
        Formula.getFormula("siap_olah_bm_cn", rowNumber, colLikelihood: "AC"),
        Formula.getFormula("siap_olah_bm_cn", rowNumber, colLikelihood: "AD"),
        Formula.getFormula("siap_olah_bm_cn", rowNumber, colLikelihood: "AE"),
        Formula.getFormula("siap_olah_bm_cn", rowNumber, colLikelihood: "AF"),
        Formula.getFormula("siap_olah_co", rowNumber),
        Formula.getFormula("siap_olah_cp", rowNumber),
        Formula.getFormula("siap_olah_cq", rowNumber),
        Formula.getFormula("siap_olah_cr", rowNumber),
        Formula.getFormula("siap_olah_cs", rowNumber),
        Formula.getFormula("siap_olah_ct", rowNumber),
        Formula.getFormula("siap_olah_cu", rowNumber),
        Formula.getFormula("siap_olah_cv", rowNumber),
        Formula.getFormula("siap_olah_cw", rowNumber),
        Formula.getFormula("siap_olah_cx", rowNumber),
        Formula.getFormula("siap_olah_cy", rowNumber),
      ],
    ];
    await sheetsApi.spreadsheets.values.append(
      ValueRange.fromJson({"values": valuesSiapOlah}),
      spreadsheetId,
      nameFormSiapOlah,
      valueInputOption: "USER_ENTERED",
    );

    return rowNumber;
  }

  static Future<void> clearItemFromSheet(
    String spreadsheetId,
    int rowIndex,
  ) async {
    final sheetsApi = await getSheetsApi();

    final requestFormResponses1 = BatchUpdateSpreadsheetRequest.fromJson({
      "requests": [
        {
          "deleteDimension": {
            "range": {
              "sheetId": gidFormResponses1,
              "dimension": "ROWS",
              "startIndex": rowIndex - 1,
              "endIndex": rowIndex,
            },
          },
        },
      ],
    });

    final requestFormSetMateng = BatchUpdateSpreadsheetRequest.fromJson({
      "requests": [
        {
          "deleteDimension": {
            "range": {
              "sheetId": gidFormSetengahMateng,
              "dimension": "ROWS",
              "startIndex": rowIndex - 1,
              "endIndex": rowIndex,
            },
          },
        },
      ],
    });

    final requestFormSiaOlah = BatchUpdateSpreadsheetRequest.fromJson({
      "requests": [
        {
          "deleteDimension": {
            "range": {
              "sheetId": gidFormSiapOlah,
              "dimension": "ROWS",
              "startIndex": rowIndex - 1,
              "endIndex": rowIndex,
            },
          },
        },
      ],
    });

    await sheetsApi.spreadsheets.batchUpdate(
      requestFormResponses1,
      spreadsheetId,
    );
    await sheetsApi.spreadsheets.batchUpdate(
      requestFormSetMateng,
      spreadsheetId,
    );
    await sheetsApi.spreadsheets.batchUpdate(requestFormSiaOlah, spreadsheetId);
  }
}
