import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import '../utils/api_config.dart';

class ApiService {
  final Dio _dio = Dio(BaseOptions(baseUrl: ApiConfig.baseUrlAuth));

  Future<void> fetchProfile() async {
    try {
      final token = ApiConfig.getTokenJWT();

      // if (token == null) return;

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

  }
}
