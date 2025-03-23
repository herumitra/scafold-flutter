import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import '../utils/api_config.dart';

class ApiService {
  // final Dio _dio = Dio(BaseOptions(baseUrl: ApiConfig.baseUrlAuth));

  final Dio _dio = Dio();

  Future<Map<String, dynamic>> fetchProfile() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('tokenJWT');

      if (token == null || token.isEmpty) {
        return {"status": "error", "message": "Token tidak ditemukan"};
      }

      final response = await _dio.get(
        ApiConfig.baseUrlAuth,
        options: Options(
          headers: {"Authorization": "Bearer $token"},
          validateStatus: (status) => status! < 500,
        ),
      );

      if (response.statusCode == 200 && response.data['status'] == 'success') {
        return response.data;
      } else {
        return {
          "status": "error",
          "message": response.data['message'] ?? "Gagal mengambil data",
        };
      }
    } catch (e) {
      return {"status": "error", "message": "Terjadi kesalahan, coba lagi"};
    }
  }

  Future<void> saveProfileData(Map<String, dynamic> data) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Debug: Lihat isi data sebelum menyimpan
      debugPrint("🔹 Data yang akan disimpan ke SharedPreferences: $data");

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

      debugPrint("✅ Profile data berhasil disimpan!");
    } catch (e) {
      debugPrint("❌ Error saat menyimpan profile data: $e");
    }
  }
}
