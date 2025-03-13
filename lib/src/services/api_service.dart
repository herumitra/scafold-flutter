import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';

class ApiService {
  final Dio _dio = Dio(BaseOptions(baseUrl: 'http://api.vimedika.com:4001'));

  Future<void> fetchProfile() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('tokenJWT');

      if (token == null) return;

      final response = await _dio.get(
        '/profile',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 200 && response.data['status'] == 'success') {
        await saveProfileData(response.data['data']);
      }
    } catch (e) {
      // print('Error fetching profile: $e');
      return;
    }
  }

  Future<void> saveProfileData(Map<String, dynamic> data) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      'profileData',
      jsonEncode({
        'user_id': data['useri_id'],
        'name': data['profile_name'],
        'branch_id': data['branch_id'],
        'branch_name': data['branch_name'],
        'address': data['address'],
        'phone': data['phone'],
        'email': data['email'],
        'sia_name': data['sia_name'],
        'psa_name': data['psa_name'],
        'sipa_name': data['sipa_name'],
        'tax_percentage': data['tax_percentage'],
        'journal_method': data['journal_method'],
      }),
    );

    // print(
    //   "Data profile berhasil disimpan: ${prefs.getString('profileData')}",
    // ); // Debugging
  }
}
