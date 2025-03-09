import 'package:flutter/material.dart';

class TransaksiPembelianItem extends StatelessWidget {
  const TransaksiPembelianItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        "Ini adalah halaman Transaksi Pembelian",
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
    );
  }
}
