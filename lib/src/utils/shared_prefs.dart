import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

class SharedPrefs {
  static Future<void> saveProfileData(Map<String, dynamic> data) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      final jsonString = jsonEncode({
        "user_id": data["user_id"] ?? "",
        "name": data["profile_name"] ?? "",
        "branch_id": data["branch_id"] ?? "",
        "branch_name": data["branch_name"] ?? "",
        "address": data["address"] ?? "",
        "phone": data["phone"] ?? "",
        "email": data["email"] ?? "",
        "sia_name": data["sia_name"] ?? "",
        "psa_name": data["psa_name"] ?? "",
        "sipa_name": data["sipa_name"] ?? "",
        "tax_percentage": data["tax_percentage"] ?? 0,
        "journal_method": data["journal_method"] ?? "",
      });

      await prefs.setString('profileData', jsonString);
    } catch (e) {
      debugPrint("❌ Error saat menyimpan profile data: $e");
    }
  }

  static Future<Map<String, dynamic>?> loadProfileData() async {
    final prefs = await SharedPreferences.getInstance();
    final profileJson = prefs.getString('profileData');

    if (profileJson != null) {
      try {
        final decodedData = jsonDecode(profileJson);
        if (decodedData is Map<String, dynamic>) {
          return decodedData;
        } else {
          await prefs.remove('profileData');
          return null;
        }
      } catch (e) {
        debugPrint("❌ Error saat decoding JSON: $e");
        return null;
      }
    }
    return null;
  }
}
