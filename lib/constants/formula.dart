class Formula {
  static String cleanFormula(String formula) {
    return formula.replaceAll("\n", " ").replaceAll(RegExp(r'\s+'), " ").trim();
  }

  static String formulaLikelihoodStunting(String col, int rowNumber) {
    return '''
      =IF(\$AH$rowNumber="Data tidak terpakai";""; 
        IF(OFFSET(\$E\$2;0;COLUMN()-COLUMN(\$AK\$1);ROWS(\$E\$2:\$E\$1000);1)="Data tidak ada";
            1;
            (COUNTIFS(
                OFFSET(\$E\$2;0;COLUMN()-COLUMN(\$AK\$1);ROWS(\$E\$2:\$E\$1000);1); $col$rowNumber;
                \$AG\$2:\$AG\$1000; 1
            ) + 1) / (COUNTIF(\$AG\$2:\$AG\$1000;1) + 3)
        )
      )
    ''';
  }

  static String formulaLikelihoodNormal(String col, int rowNumber) {
    return '''
      =IF(\$AH$rowNumber="Data tidak terpakai";""; 
        IF(OFFSET(\$E\$2;0;COLUMN()-COLUMN(\$BM\$1);ROWS(\$E\$2:\$E\$1000);1)="Data tidak ada";
            1;
            (COUNTIFS(
                OFFSET(\$E\$2;0;COLUMN()-COLUMN(\$BM\$1);ROWS(\$E\$2:\$E\$1000);1); $col$rowNumber;
                \$AG\$2:\$AG\$1000; 0
            ) + 1) / (COUNTIF(\$AG\$2:\$AG\$1000;0) + 3)
        )
      )
    ''';
  }

  static String getFormula(String key, int rowNumber, {String? colLikelihood}) {
    String formula = "";
    switch (key) {
      case "setengah_mateng_d":
        formula = cleanFormula('''
          =IF(ISBLANK('Form Responses 1'!D$rowNumber); ""; 
            DATEDIF('Form Responses 1'!D$rowNumber; TODAY(); "Y") & " tahun " & 
            DATEDIF('Form Responses 1'!D$rowNumber; TODAY(); "YM") & " bulan " & 
            DATEDIF('Form Responses 1'!D$rowNumber; TODAY(); "MD") & " hari | " & 
            IF(DATEDIF('Form Responses 1'!D$rowNumber; TODAY(); "m") < 12; "< 12 bulan"; 
                IF(DATEDIF('Form Responses 1'!D$rowNumber; TODAY(); "m") <= 24; "12 - 24 bulan"; "> 24 bulan")
            )
          )
        ''');
        break;

      case "setengah_mateng_e":
        formula = cleanFormula('''
          =IF(
            OR(ISBLANK(C$rowNumber); ISBLANK(D$rowNumber); ISBLANK('Form Responses 1'!E$rowNumber));
            "";
            IF(
              'Form Responses 1'!E$rowNumber < VLOOKUP(
                VALUE(REGEXEXTRACT(D$rowNumber; "(\\d+) tahun"))*12 + VALUE(REGEXEXTRACT(D$rowNumber; "(\\d+) bulan"));
                FILTER(WHO_DATA!A:D; WHO_DATA!B:B=C$rowNumber);
                3;
                FALSE
              );
              "Di bawah normal";
              IF(
                'Form Responses 1'!E$rowNumber > VLOOKUP(
                  VALUE(REGEXEXTRACT(D$rowNumber; "(\\d+) tahun"))*12 + VALUE(REGEXEXTRACT(D$rowNumber; "(\\d+) bulan"));
                  FILTER(WHO_DATA!A:D; WHO_DATA!B:B=C$rowNumber);
                  4;
                  FALSE
                );
                "Di atas normal";
                "Normal"
              )
            )
          )
        ''');
        break;

      case "setengah_mateng_f":
        formula = cleanFormula('''
          =IF(
            TRIM('Form Responses 1'!F$rowNumber)="";
            "";
            LET(
              usia_tahun; IFERROR(VALUE(REGEXEXTRACT(D$rowNumber; "^([0-9]+) tahun")); 0);
              usia_bulan; IFERROR(VALUE(REGEXEXTRACT(D$rowNumber; "tahun ([0-9]+) bulan")); 0);
              total_bulan; usia_tahun * 12 + usia_bulan;
              pb; IFERROR(VALUE('Form Responses 1'!F$rowNumber); "");
              batas_min; IFERROR(INDEX(FILTER(WHO_DATA!H\$2:H; WHO_DATA!F\$2:F = total_bulan; WHO_DATA!G\$2:G = C$rowNumber); 1); "");
              batas_max; IFERROR(INDEX(FILTER(WHO_DATA!I\$2:I; WHO_DATA!F\$2:F = total_bulan; WHO_DATA!G\$2:G = C$rowNumber); 1); "");
              IF(
                batas_min = "";
                "Usia di luar jangkauan WHO";
                IF(
                  pb = "";
                  "Data kosong";
                  IF(pb < batas_min; "Pendek"; IF(pb > batas_max; "Tinggi"; "Normal"))
                )
              )
            )
          )
        ''');
        break;

      case "setengah_mateng_g":
        formula = cleanFormula('''
          =IF(OR(TRIM('Form Responses 1'!F$rowNumber)=""; TRIM('Form Responses 1'!E$rowNumber)=""); "";
            LET(
              tb; VALUE('Form Responses 1'!F$rowNumber);
              tb_round; ROUND(tb; 0);
              bb; VALUE('Form Responses 1'!E$rowNumber);
              batas_min; IFERROR(INDEX(FILTER(WHO_DATA!M\$2:M; WHO_DATA!K\$2:K = tb_round; WHO_DATA!L\$2:L = C$rowNumber); 1); "");
              batas_max; IFERROR(INDEX(FILTER(WHO_DATA!N\$2:N; WHO_DATA!K\$2:K = tb_round; WHO_DATA!L\$2:L = C$rowNumber); 1); "");
              IF(
                batas_min = "";
                "TB tidak tersedia pada data";
                IF(bb < batas_min; "Kurus"; IF(bb > batas_max; "Gemuk"; "Normal"))
              )
            )
          )
        ''');
        break;

      case "setengah_mateng_h":
        formula = cleanFormula('''
          =IF('Form Responses 1'!G$rowNumber="";"";LET(
            lingkarRaw;'Form Responses 1'!G$rowNumber;
            lingkar;IF(ISNUMBER(lingkarRaw);lingkarRaw;NUMBERVALUE(TO_TEXT(lingkarRaw);",";"." ));
            gender;C$rowNumber;
            umurText;D$rowNumber;
            umurBulan;IFERROR(VALUE(REGEXEXTRACT(umurText;">\\s*(\\d+)"));VALUE(REGEXEXTRACT(umurText;"(\\d+)\\s*bulan")));
            bMinRaw;IFERROR(INDEX(FILTER(WHO_DATA!R:R;WHO_DATA!Q:Q=gender;WHO_DATA!P:P=umurBulan);1);"");
            bMaxRaw;IFERROR(INDEX(FILTER(WHO_DATA!S:S;WHO_DATA!Q:Q=gender;WHO_DATA!P:P=umurBulan);1);"");
            bMin;IF(ISNUMBER(bMinRaw);bMinRaw;IF(bMinRaw="";NA();NUMBERVALUE(TO_TEXT(bMinRaw);",";"." )));
            bMax;IF(ISNUMBER(bMaxRaw);bMaxRaw;IF(bMaxRaw="";NA();NUMBERVALUE(TO_TEXT(bMaxRaw);",";"." )));
            IF(OR(ISNA(bMin);ISNA(bMax);NOT(ISNUMBER(lingkar)));
              "Periksa format gender/umur/tabel";
              IF(lingkar<bMin;"Di bawah rata-rata";IF(lingkar>bMax;"Di atas rata-rata";"Normal"))
            )
          ))
        ''');
        break;

      case "setengah_mateng_i":
        formula = cleanFormula('''
          =IF('Form Responses 1'!H$rowNumber="";"";IF('Form Responses 1'!H$rowNumber<11,5;"Gizi buruk";IF('Form Responses 1'!H$rowNumber<=12,5;"Rawan";"Normal")))
        ''');
        break;

      case "siap_olah_e":
        formula = cleanFormula('''
          =if('Form data setengah mateng'!E$rowNumber="Di bawah normal";0;if('Form data setengah mateng'!E$rowNumber="Normal";1;if('Form data setengah mateng'!E$rowNumber="Di atas normal";2;"Data tidak ada")))
        ''');
        break;

      case "siap_olah_f":
        formula = cleanFormula('''
          =if('Form data setengah mateng'!F$rowNumber="Pendek";0;if('Form data setengah mateng'!F$rowNumber="Normal";1;if('Form data setengah mateng'!F$rowNumber="Tinggi";2;"Data tidak ada")))
        ''');
        break;

      case "siap_olah_g":
        formula = cleanFormula('''
          =if('Form data setengah mateng'!G$rowNumber="Kurus";0;if('Form data setengah mateng'!G$rowNumber="Normal";1;if('Form data setengah mateng'!G$rowNumber="Gemuk";2;"Data tidak ada")))
        ''');
        break;

      case "siap_olah_h":
        formula = cleanFormula('''
          =if('Form data setengah mateng'!H$rowNumber="Di bawah rata-rata";0;if('Form data setengah mateng'!H$rowNumber="Normal";1;if('Form data setengah mateng'!H$rowNumber="Di atas rata-rata";2;"Data tidak ada")))
        ''');
        break;

      case "siap_olah_i":
        formula = cleanFormula('''
          =if('Form data setengah mateng'!I$rowNumber="Gizi buruk";0;if('Form data setengah mateng'!I$rowNumber="Rawan";1;if('Form data setengah mateng'!I$rowNumber="Normal";2;"Data tidak ada")))
        ''');
        break;

      case "siap_olah_j":
        formula = cleanFormula('''
          =if('Form data setengah mateng'!J$rowNumber="Anak pertama";0;if('Form data setengah mateng'!J$rowNumber="Anak kedua";1;if('Form data setengah mateng'!J$rowNumber="Anak ketiga atau lebih";2;"Data tidak ada")))
        ''');
        break;

      case "siap_olah_k":
        formula = cleanFormula('''
          =if('Form data setengah mateng'!K$rowNumber="< 20 tahun";0;if('Form data setengah mateng'!K$rowNumber="20 - 35 tahun";1;if('Form data setengah mateng'!K$rowNumber="> 35 tahun";2;"Data tidak ada")))
        ''');
        break;

      case "siap_olah_l":
        formula = cleanFormula('''
          =if('Form data setengah mateng'!L$rowNumber="SD / SMP";0;if('Form data setengah mateng'!L$rowNumber="SMA";1;if('Form data setengah mateng'!L$rowNumber="Perguruan Tinggi";2;"Data tidak ada")))
        ''');
        break;

      case "siap_olah_m":
        formula = cleanFormula('''
          =if('Form data setengah mateng'!M$rowNumber="< Rp 1 juta";0;if('Form data setengah mateng'!M$rowNumber="Rp 1 - 3 juta";1;if('Form data setengah mateng'!M$rowNumber="> Rp 3 juta";2;"Data tidak ada")))
        ''');
        break;

      case "siap_olah_n":
        formula = cleanFormula('''
          =if('Form data setengah mateng'!N$rowNumber="< 4 kali";0;if('Form data setengah mateng'!N$rowNumber="4 - 7 kali";1;if('Form data setengah mateng'!N$rowNumber="≥ 8 kali";2;"Data tidak ada")))
        ''');
        break;

      case "siap_olah_o":
        formula = cleanFormula('''
          =if('Form data setengah mateng'!O$rowNumber="Kurang";0;if('Form data setengah mateng'!O$rowNumber="Cukup";1;if('Form data setengah mateng'!O$rowNumber="Sangat cukup";2;"Data tidak ada")))
        ''');
        break;

      case "siap_olah_p":
        formula = cleanFormula('''
          =if('Form data setengah mateng'!P$rowNumber="Sering terpapar";0;if('Form data setengah mateng'!P$rowNumber="Kadang";1;if('Form data setengah mateng'!P$rowNumber="Tidak ada paparan";2;"Data tidak ada")))
        ''');
        break;

      case "siap_olah_q":
        formula = cleanFormula('''
          =if('Form data setengah mateng'!Q$rowNumber="Ada penyakit kronis";0;if('Form data setengah mateng'!Q$rowNumber="Pernah sakit ringan";1;if('Form data setengah mateng'!Q$rowNumber="Sehat";2;"Data tidak ada")))
        ''');
        break;

      case "siap_olah_r":
        formula = cleanFormula('''
          =if('Form data setengah mateng'!R$rowNumber="Sangat stres";0;if('Form data setengah mateng'!R$rowNumber="Kadang stres";1;if('Form data setengah mateng'!R$rowNumber="Tidak stres";2;"Data tidak ada")))
        ''');
        break;

      case "siap_olah_s":
        formula = cleanFormula('''
          =if('Form data setengah mateng'!S$rowNumber="Dukun bayi";0;if('Form data setengah mateng'!S$rowNumber="Bidan";1;if('Form data setengah mateng'!S$rowNumber="Dokter RS";2;"Data tidak ada")))
        ''');
        break;

      case "siap_olah_t":
        formula = cleanFormula('''
          =if('Form data setengah mateng'!T$rowNumber="Tidak punya jaminan";0;if('Form data setengah mateng'!T$rowNumber="Punya BPJS";1;if('Form data setengah mateng'!T$rowNumber="Punya asuransi lain";2;"Data tidak ada")))
        ''');
        break;

      case "siap_olah_u":
        formula = cleanFormula('''
          =if('Form data setengah mateng'!U$rowNumber="Tidak sama sekali";0;if('Form data setengah mateng'!U$rowNumber="Sebagian";1;if('Form data setengah mateng'!U$rowNumber="Lengkap 6 bulan";2;"Data tidak ada")))
        ''');
        break;

      case "siap_olah_v":
        formula = cleanFormula('''
          =if('Form data setengah mateng'!V$rowNumber="< 6 bulan";0;if('Form data setengah mateng'!V$rowNumber="6 bulan";1;if('Form data setengah mateng'!V$rowNumber="> 6 bulan";2;"Data tidak ada")))
        ''');
        break;

      case "siap_olah_w":
        formula = cleanFormula('''
          =if('Form data setengah mateng'!W$rowNumber="Instan";0;if('Form data setengah mateng'!W$rowNumber="Campuran";1;if('Form data setengah mateng'!W$rowNumber="Buatan sendiri";2;"Data tidak ada")))
        ''');
        break;

      case "siap_olah_x":
        formula = cleanFormula('''
          =if('Form data setengah mateng'!X$rowNumber="< 3 kali / hari";0;if('Form data setengah mateng'!X$rowNumber="3 - 5 kali / hari";1;if('Form data setengah mateng'!X$rowNumber="> 5 kali / hari";2;"Data tidak ada")))
        ''');
        break;

      case "siap_olah_y":
        formula = cleanFormula('''
          =if('Form data setengah mateng'!Y$rowNumber="Tidak memperhatikan gizi";0;if('Form data setengah mateng'!Y$rowNumber="Kadang seimbang";1;if('Form data setengah mateng'!Y$rowNumber="Sangat seimbang";2;"Data tidak ada")))
        ''');
        break;

      case "siap_olah_z":
        formula = cleanFormula('''
          =if('Form data setengah mateng'!Z$rowNumber="Tidak minum suplemen";0;if('Form data setengah mateng'!Z$rowNumber="Kadang minum";1;if('Form data setengah mateng'!Z$rowNumber="Rutin minum";2;"Data tidak ada")))
        ''');
        break;

      case "siap_olah_aa":
        formula = cleanFormula('''
          =if('Form data setengah mateng'!AA$rowNumber="Tidak imunisasi";0;if('Form data setengah mateng'!AA$rowNumber="Imunisasi sebagian";1;if('Form data setengah mateng'!AA$rowNumber="Imunisasi lengkap";2;"Data tidak ada")))
        ''');
        break;

      case "siap_olah_ab":
        formula = cleanFormula('''
          =if('Form data setengah mateng'!AB$rowNumber="Buruk";0;if('Form data setengah mateng'!AB$rowNumber="Sedang";1;if('Form data setengah mateng'!AB$rowNumber="Baik";2;"Data tidak ada")))
        ''');
        break;

      case "siap_olah_ac":
        formula = cleanFormula('''
          =if('Form data setengah mateng'!AC$rowNumber="Tidak rutin";0;if('Form data setengah mateng'!AC$rowNumber="Kadang-kadang";1;if('Form data setengah mateng'!AC$rowNumber="Sangat rutin";2;"Data tidak ada")))
        ''');
        break;

      case "siap_olah_ad":
        formula = cleanFormula('''
          =if('Form data setengah mateng'!AD$rowNumber="Tidak pernah";0;if('Form data setengah mateng'!AD$rowNumber="Kadang";1;if('Form data setengah mateng'!AD$rowNumber="Rutin";2;"Data tidak ada")))
        ''');
        break;

      case "siap_olah_ae":
        formula = cleanFormula('''
          =if('Form data setengah mateng'!AE$rowNumber="Tidak ada";0;if('Form data setengah mateng'!AE$rowNumber="Kadang ada";1;if('Form data setengah mateng'!AE$rowNumber="Selalu mendukung";2;"Data tidak ada")))
        ''');
        break;

      case "siap_olah_af":
        formula = cleanFormula('''
          =if('Form data setengah mateng'!AF$rowNumber="Otoriter";0;if('Form data setengah mateng'!AF$rowNumber="Demokratis";1;if('Form data setengah mateng'!AF$rowNumber="Permisif";2;"Data tidak ada")))
        ''');
        break;

      case "siap_olah_ah":
        formula = cleanFormula('''
          =IF(COUNTIF(E$rowNumber:AF$rowNumber;"Data tidak ada")>0;"Data tidak terpakai";"OK")
        ''');
        break;

      case "siap_olah_ak_bl":
        formula = cleanFormula(
          formulaLikelihoodStunting(colLikelihood!, rowNumber),
        );
        break;

      case "siap_olah_bm_cn":
        formula = cleanFormula(
          formulaLikelihoodNormal(colLikelihood!, rowNumber),
        );
        break;

      case "siap_olah_co":
        formula = cleanFormula('''
          =IF(\$AH$rowNumber="Data tidak terpakai";""; \$AI\$1 * PRODUCT(AK$rowNumber:BL$rowNumber))
        ''');
        break;

      case "siap_olah_cp":
        formula = cleanFormula('''
          =IF(\$AH$rowNumber="Data tidak terpakai";""; \$AJ\$1 * PRODUCT(BM$rowNumber:CN$rowNumber))
        ''');
        break;

      case "siap_olah_cq":
        formula = cleanFormula('''
          =IF(\$AH$rowNumber="Data tidak terpakai";"Data tidak terpakai"; CO$rowNumber / (CO$rowNumber + CP$rowNumber))
        ''');
        break;

      case "siap_olah_cr":
        formula = cleanFormula('''
          =IF(\$AH$rowNumber="Data tidak terpakai";"Data tidak terpakai"; CP$rowNumber / (CO$rowNumber + CP$rowNumber))
        ''');
        break;

      case "siap_olah_cs":
        formula = cleanFormula('''
          =IF(\$AH$rowNumber="Data tidak terpakai";""; IF(CQ$rowNumber>=0,5;1;0))
        ''');
        break;

      case "siap_olah_ct":
        formula = cleanFormula('''
          =IF(\$AH$rowNumber="Data tidak terpakai";""; LN(\$AI\$1) + SUM(ARRAYFORMULA(LN(AK$rowNumber:BL$rowNumber))))
        ''');
        break;

      case "siap_olah_cu":
        formula = cleanFormula('''
          =IF(\$AH$rowNumber="Data tidak terpakai";""; LN(\$AJ\$1) + SUM(ARRAYFORMULA(LN(BM$rowNumber:CN$rowNumber))))
        ''');
        break;

      case "siap_olah_cv":
        formula = cleanFormula('''
          =IF(\$AH$rowNumber="Data tidak terpakai";"Data tidak terpakai";
            LET(
              m; MAX(CT$rowNumber;CU$rowNumber);
              a; EXP(CT$rowNumber-m);
              b; EXP(CU$rowNumber-m);
              a/(a+b)
            )
          )
        ''');
        break;

      case "siap_olah_cw":
        formula = cleanFormula('''
          =IF(\$AH$rowNumber="Data tidak terpakai";""; IF(CV$rowNumber>=0,5;1;0))
        ''');
        break;

      case "siap_olah_cx":
        formula = cleanFormula('''
          =IF(\$CS$rowNumber<>1;""; TEXTJOIN(", "; TRUE; FILTER(\$E\$1:\$AF\$1; \$E$rowNumber:\$AF$rowNumber=0)))
        ''');
        break;

      case "siap_olah_cy":
        formula = cleanFormula('''
          =TEXTJOIN(", "; TRUE;
            FILTER(
              DB\$2:DB\$100;
              REGEXMATCH(\$CX$rowNumber; DA\$2:DA\$100)
            )
          )
        ''');
        break;

      default:
        formula = "";
    }
    return formula;
  }

  static String formatItemIndikasiDanRekomendasi(String input) {
    List<String> parts = input
        .split(',')
        .map((e) => e.trim())
        .map((e) => e.replaceAll(RegExp(r'^\d+\.\s*'), ''))
        .where((e) => e.isNotEmpty)
        .toList();

    if (parts.isEmpty) return "";
    return parts
        .asMap()
        .entries
        .map((entry) {
          final index = entry.key + 1; // biar mulai dari 1
          final value = entry.value;
          return "$index. $value";
        })
        .join("\n");

    // if (parts.length == 1) {
    //   return parts[0];
    // } else if (parts.length == 2) {
    //   return "${parts[0]} dan ${parts[1]}";
    // } else {
    //   return "${parts.sublist(0, parts.length - 1).join(', ')} dan ${parts.last}";
    // }
  }
}
