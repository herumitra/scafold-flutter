import 'package:flutter/material.dart';

class TransaksiPenjualanItem extends StatelessWidget {
  const TransaksiPenjualanItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        "Ini adalah halaman Transaksi Penjualan",
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
    );
  }
}
