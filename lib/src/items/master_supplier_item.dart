import 'package:flutter/material.dart';

class MasterSupplierItem extends StatelessWidget {
  const MasterSupplierItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        "Ini adalah halaman Master Supplier",
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
    );
  }
}
