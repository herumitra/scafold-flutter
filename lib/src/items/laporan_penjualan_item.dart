import 'package:flutter/material.dart';

class LaporanPenjualanItem extends StatelessWidget {
  const LaporanPenjualanItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        "Ini adalah halaman Laporan Penjualan",
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
    );
  }
}
