import 'package:flutter/material.dart';

class LaporanLabaRugiItem extends StatelessWidget {
  const LaporanLabaRugiItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        "Ini adalah halaman Laporan Laba Rugi",
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
    );
  }
}
