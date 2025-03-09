import 'package:flutter/material.dart';

class DashboardItem extends StatelessWidget {
  const DashboardItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        "Ini adalah halaman Dashboard",
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
    );
  }
}
