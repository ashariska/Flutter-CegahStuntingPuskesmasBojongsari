import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class InfoItem {
  final String iconPath;
  final String title;
  final String info;

  InfoItem({required this.iconPath, required this.title, required this.info});
}

class InfoGrid extends StatelessWidget {
  final List<InfoItem> items;

  const InfoGrid({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // tentukan lebar tiap box
        double boxWidth = 160; // contoh, bisa kamu sesuaikan
        double spacing = 16;
        // int maxPerRow = (constraints.maxWidth / (boxWidth + spacing)).floor();

        return Wrap(
          spacing: spacing, // jarak horizontal antar box
          runSpacing: spacing, // jarak vertical antar baris
          alignment:
              WrapAlignment.center, // PENTING: supaya baris terakhir center
          children: List.generate(items.length, (index) {
            return SizedBox(
              width: boxWidth,
              child: _InfoBox(item: items[index]),
            );
          }),
        );
      },
    );
  }
}

class _InfoBox extends StatelessWidget {
  final InfoItem item;

  const _InfoBox({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: const Offset(2, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(item.iconPath, width: 50, height: 50),
          const SizedBox(height: 12),
          Text(
            item.title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            item.info,
            style: const TextStyle(fontSize: 12, color: Colors.black54),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
