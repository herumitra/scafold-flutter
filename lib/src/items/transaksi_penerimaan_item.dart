import 'package:flutter/material.dart';

class TransaksiPenerimaanItem extends StatelessWidget {
  const TransaksiPenerimaanItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        "Ini adalah halaman Transaksi Penerimaan",
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
    );
  }
}
