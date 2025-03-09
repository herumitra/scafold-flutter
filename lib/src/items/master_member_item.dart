import 'package:flutter/material.dart';

class MasterMemberItem extends StatelessWidget {
  const MasterMemberItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        "Ini adalah halaman Master Member",
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
    );
  }
}
