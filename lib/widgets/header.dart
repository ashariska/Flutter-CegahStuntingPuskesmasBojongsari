import 'package:flutter/material.dart';
import 'package:stunting_web/styles/style.dart';

class Header extends StatelessWidget {
  const Header({super.key, this.onLogoTap, this.onMenuTap});
  final VoidCallback? onLogoTap;
  final VoidCallback? onMenuTap;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 75,
      decoration: kHeaderDecoration,
      child: Row(
        children: [
          // SiteLogo(onTap: onLogoTap),
          Image.asset('assets/logo.png', width: 100, height: 100),
          Text(
            'Puskesmas Bojongsari',
            style: TextStyle(
              fontWeight: FontWeight.w300,
              color: Colors.white,
              fontSize: 25,
            ),
          ),
          const Spacer(),
          IconButton(
            onPressed: onMenuTap,
            icon: const Icon(Icons.menu),
            color: Colors.white,
          ),
          const SizedBox(width: 15),
        ],
      ),
    );
  }
}
