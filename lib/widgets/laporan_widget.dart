import 'package:flutter/material.dart';
import 'package:stunting_web/constants/colors.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:stunting_web/constants/config.dart';
import 'package:stunting_web/constants/gsheet_helper.dart';
import 'package:stunting_web/constants/dialog_item.dart';
import 'package:stunting_web/styles/style.dart';
import 'package:stunting_web/widgets/footer.dart';

class LaporanWidget extends StatefulWidget {
  final Function(int)? onSubmit;
  const LaporanWidget({super.key, this.onSubmit});

  @override
  State<LaporanWidget> createState() => _LaporanWidgetState();
}

class _LaporanWidgetState extends State<LaporanWidget> {
  bool isLoading = false;
  void confirmDelete(int row) async {
    final confirm = await DialogItem.showDialogItem(
      context: context,
      title: "Hapus Data",
      message: "Apakah Anda Yakin Ingin Menghapus Data Ini ?",
      confirmButtonText: "Ya, Hapus",
      cancelButtonText: "Batal",
      color: CustomColor.redMain,
      icon: Icons.delete_outline_outlined,
    );

    if (confirm == true) {
      setState(() => isLoading = true);
      try {
        await GSheetHelper.clearItemFromSheet(spreadsheetId, row);
        General.showSnackBar(context, "Data Berhasil Dihapus");
      } on Exception catch (e) {
        General.showSnackBar(context, "Failed Delete: $e");
      } finally {
        setState(() => isLoading = false);
      }
    }
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Scaffold(
          key: _scaffoldKey,
          body: Container(
            width: double.infinity,
            height: double.infinity,
            color: CustomColor.greenMain,
            child: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                  child: Column(
                    children: [
                      // Judul
                      Container(
                        width: double.infinity,
                        height: 50.0,
                        color: CustomColor.greenMain,
                        child: Center(
                          child: Text(
                            "Laporan Riwayat Deteksi Stunting",
                            style: TextStyle(
                              fontSize: constraints.maxWidth * 0.025,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Box tabel
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: SizedBox(
                          height: 450,
                          child: FutureBuilder<List<Map<String, dynamic>>>(
                            future: GSheetHelper.fetchFromSheet(
                              spreadsheetId: spreadsheetId,
                              apiKey: gsheetApiKey,
                            ),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              } else if (snapshot.hasError) {
                                return Center(
                                  child: Text("Error: ${snapshot.error}"),
                                );
                              } else if (!snapshot.hasData ||
                                  snapshot.data!.isEmpty) {
                                return const Center(
                                  child: Text("Tidak ada data"),
                                );
                              }

                              final data = snapshot.data!;

                              return DataTable2(
                                columns: const [
                                  DataColumn2(
                                    label: Center(
                                      child: Text(
                                        'Tanggal Survey',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                        ),
                                      ),
                                    ),
                                    size: ColumnSize.L,
                                  ),
                                  DataColumn(
                                    label: Center(
                                      child: Text(
                                        'Nama',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                        ),
                                      ),
                                    ),
                                  ),
                                  DataColumn(
                                    label: Center(
                                      child: Text(
                                        'Jenis Kelamin',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                        ),
                                      ),
                                    ),
                                  ),
                                  DataColumn(
                                    label: Center(
                                      child: Text(
                                        'Usia',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                        ),
                                      ),
                                    ),
                                  ),
                                  DataColumn(
                                    label: Center(
                                      child: Text(
                                        'Stunting',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                        ),
                                      ),
                                    ),
                                  ),
                                  DataColumn(
                                    label: Center(
                                      child: Text(
                                        'Aksi',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                        ),
                                      ),
                                    ),
                                    numeric: true,
                                  ),
                                ],
                                rows: data.map((item) {
                                  return DataRow(
                                    cells: [
                                      DataCell(Text(item['tgl'] ?? '')),
                                      DataCell(Text(item['nama'] ?? '')),
                                      DataCell(
                                        Text(item['jenis_kelamin'] ?? ''),
                                      ),
                                      DataCell(
                                        Text(
                                          item['usia']
                                                  ?.split('|')
                                                  .first
                                                  .trim() ??
                                              '',
                                        ),
                                      ),
                                      DataCell(
                                        Text(
                                          item['is_stunting'] == "1"
                                              ? "Stunting"
                                              : "Normal",
                                          style: TextStyle(
                                            color: item['is_stunting'] == "1"
                                                ? Colors.red
                                                : Colors.green,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      DataCell(
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            IconButton(
                                              icon: const Icon(
                                                Icons.visibility,
                                                color: Colors.blue,
                                              ),
                                              tooltip: "Detail",
                                              onPressed: () {
                                                setState(() {
                                                  if (widget.onSubmit != null) {
                                                    widget.onSubmit!(
                                                      item['row'],
                                                    );
                                                  }
                                                });
                                              },
                                            ),
                                            IconButton(
                                              icon: const Icon(
                                                Icons.delete,
                                                color: Colors.red,
                                              ),
                                              tooltip: "Hapus",
                                              onPressed: isLoading
                                                  ? null
                                                  : () async {
                                                      confirmDelete(
                                                        item['row'],
                                                      );
                                                    },
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  );
                                }).toList(),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 15),
                Footer(),
              ],
            ),
          ),
        );
      },
    );
  }
}
