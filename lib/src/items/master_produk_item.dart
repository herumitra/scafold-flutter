import 'package:flutter/material.dart';

class MasterProdukItem extends StatelessWidget {
  const MasterProdukItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        "Ini adalah halaman Master Produk",
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
    );
  }
}
