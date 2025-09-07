import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stunting_web/constants/nav_items.dart';

class DrawerMenu extends StatefulWidget {
  final Function(String) onMenuItemSelected;
  const DrawerMenu({super.key, required this.onMenuItemSelected});

  @override
  State<DrawerMenu> createState() => _DrawerMenuState();
}

class _DrawerMenuState extends State<DrawerMenu> {
  static Future<String> getRole() async {
    final prefs = await SharedPreferences.getInstance();
    final role = prefs.getString('role') ?? "";
    return role;
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.black,
      child: FutureBuilder<String>(
        future: getRole(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("Tidak ada data"));
          }

          final data = snapshot.data!;
          var useNavIcons = data == "admin" ? navIcons : navIconsUser;
          var useNavTitles = data == "admin" ? navTitles : navTitlesUser;

          return ListView(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 20.0,
                    top: 20.0,
                    bottom: 20.0,
                  ),
                  child: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.close, color: Colors.white),
                  ),
                ),
              ),
              for (int i = 0; i < useNavIcons.length; i++)
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 30.0),
                  titleTextStyle: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                  onTap: () {
                    widget.onMenuItemSelected(useNavTitles[i]);
                    Navigator.pop(context);
                  },
                  leading: Icon(useNavIcons[i], color: Colors.white),
                  title: Text(useNavTitles[i]),
                ),
            ],
          );
        },
      ),
    );
  }
}
