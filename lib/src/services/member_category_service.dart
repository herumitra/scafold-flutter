import 'package:dio/dio.dart';
import '../models/member_category.dart';
import '../utils/api_config.dart';

// Initialize Dio
class MemberCategoryService {
  final Dio _dio = Dio();

  // Get Member Categories
  Future<List<MemberCategory>> getMemberCategories() async {
    try {
      final token = await ApiConfig.getTokenJWT();
      final response = await _dio.get(
        ApiConfig.member_categories_endpoint,
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );

      // Pastikan response adalah Map, lalu ambil hanya data
      if (response.data is Map<String, dynamic> &&
          response.data.containsKey("data")) {
        final List<dynamic> memberCategoryList = response.data["data"];
        return memberCategoryList
            .map((json) => MemberCategory.fromJson(json))
            .toList();
      } else {
        throw Exception("Format response API tidak sesuai.");
      }
    } on DioException {
      // print("Dio Error: ${e.response?.statusCode} - ${e.message}");
      // print("Error Response: ${e.response?.data}");
      return [];
    } catch (e) {
      // print("Error: $e");
      return [];
    }
  }

  // Create Member Category
  Future<void> createMemberCategory(String name) async {
    final token = await ApiConfig.getTokenJWT();
    await _dio.post(
      ApiConfig.member_categories_endpoint,
      data: {"name": name},
      options: Options(headers: {"Authorization": "Bearer $token"}),
    );
  }

  // Update Member Category
  Future<void> updateMemberCategory(int id, String name) async {
    final token = await ApiConfig.getTokenJWT();
    await _dio.put(
      "${ApiConfig.member_categories_endpoint}/$id",
      data: {"name": name},
      options: Options(headers: {"Authorization": "Bearer $token"}),
    );
  }

  // Delete Member Category
  Future<void> deleteMemberCategory(int id) async {
    final token = await ApiConfig.getTokenJWT();
    await _dio.delete(
      "${ApiConfig.member_categories_endpoint}/$id",
      options: Options(headers: {"Authorization": "Bearer $token"}),
    );
  }
}
