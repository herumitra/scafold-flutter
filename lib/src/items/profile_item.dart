import 'package:flutter/material.dart';

class ProfileItem extends StatelessWidget {
  const ProfileItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        "Ini adalah halaman Profile",
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
    );
  }
}
