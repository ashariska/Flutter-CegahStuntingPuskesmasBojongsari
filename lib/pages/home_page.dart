import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stunting_web/constants/colors.dart';
import 'package:stunting_web/constants/dialog_item.dart';
import 'package:stunting_web/styles/style.dart';
import 'package:stunting_web/widgets/drawer_menu.dart';
import 'package:stunting_web/widgets/header.dart';
import 'package:stunting_web/widgets/home_widget.dart';
import 'package:stunting_web/widgets/laporan_widget.dart';
import 'package:stunting_web/widgets/survey_widget.dart';
import 'package:stunting_web/widgets/hasil_survey.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void confirmLogout() async {
    final confirm = await DialogItem.showDialogItem(
      context: context,
      title: "Logout",
      message: "Apakah Anda Yakin Ingin Keluar ?",
      confirmButtonText: "Ya, Keluar",
      cancelButtonText: "Batal",
      color: CustomColor.redMain,
      icon: Icons.logout_outlined,
    );

    if (confirm == true) {
      try {
        await _clearLoginStatus();
        Future.delayed(const Duration(milliseconds: 500), () {
          if (!mounted) return;
          Navigator.pushReplacementNamed(context, '/');
        });
      } on Exception catch (e) {
        General.showSnackBar(context, "Failed Log Out: $e");
      }
    }
  }

  void onMenuItemSelected(String menuName) {
    if (menuName == 'Beranda') {
      setState(() => currentIndex = 0);
    } else if (menuName == 'Survey') {
      setState(() => currentIndex = 1);
    } else if (menuName == 'Laporan') {
      setState(() => currentIndex = 2);
    } else if (menuName == 'Log Out') {
      Future.delayed(const Duration(milliseconds: 200), () {
        confirmLogout();
      });
    } else {
      setState(() => currentIndex = 3);
    }
  }

  Future<void> _clearLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('isLoggedIn');
    await prefs.remove('expirationTime');
  }

  void _openHasilSurvey(int row) async {
    // tampilkan loading dulu
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    await Future.delayed(const Duration(milliseconds: 500)); // simulasi loading
    if (!mounted) return;
    Navigator.pop(context); // tutup loading

    // buka halaman hasil survey
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => HasilSurvey(row: row)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      HomeWidget(),
      SurveyWidget(onSubmit: (row) => _openHasilSurvey(row)),
      LaporanWidget(onSubmit: (row) => _openHasilSurvey(row)),
      const Text("Error"),
    ];

    return Scaffold(
      key: _scaffoldKey,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Header(
          onMenuTap: () {
            _scaffoldKey.currentState?.openEndDrawer();
          },
        ),
      ),
      endDrawer: DrawerMenu(onMenuItemSelected: onMenuItemSelected),
      body: IndexedStack(index: currentIndex, children: pages),
    );
  }
}
