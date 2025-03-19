import 'package:dio/dio.dart';
import '../models/supplier_category.dart';
import '../utils/api_config.dart';

class SupplierCategoryService {
  final Dio _dio = Dio();

  /// 🔍 Mengambil daftar kategori supplier
  Future<List<SupplierCategory>> getSupplierCategories() async {
    try {
      final token = await ApiConfig.getTokenJWT();
      final response = await _dio.get(
        ApiConfig.supplier_categories_endpoint,
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );

      print("📥 RESPON API: ${response.data}"); // Debugging

      if (response.data is Map<String, dynamic> &&
          response.data.containsKey("data")) {
        final List<dynamic> supplierCategoryList = response.data["data"];

        // Konversi ke list SupplierCategory
        final parsedData = supplierCategoryList
            .map((json) => SupplierCategory.fromJson(json))
            .toList();

        print("📌 Parsed Data: $parsedData"); // Debugging

        return parsedData;
      } else {
        print("⚠️ Format response API tidak sesuai.");
        return [];
      }
    } on DioException catch (e) {
      print("🚨 Dio Error: ${e.response?.statusCode} - ${e.message}");
      print("❌ Error Response: ${e.response?.data}");
      return [];
    } catch (e) {
      print("⚠️ General Error: $e");
      return [];
    }
  }

  /// ➕ Menambahkan kategori supplier
  Future<void> createSupplierCategory(String name) async {
    try {
      final token = await ApiConfig.getTokenJWT();
      final response = await _dio.post(
        ApiConfig.supplier_categories_endpoint,
        data: {"name": name},
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );

      print("✅ CREATE Response: ${response.data}");
    } catch (e) {
      print("❌ CREATE Error: $e");
    }
  }

  /// ✏️ Mengupdate kategori supplier
  Future<void> updateSupplierCategory(int id, String name) async {
    try {
      final token = await ApiConfig.getTokenJWT();
      final response = await _dio.put(
        "${ApiConfig.supplier_categories_endpoint}/$id",
        data: {"name": name},
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );

      print("✅ UPDATE Response: ${response.data}");
    } catch (e) {
      print("❌ UPDATE Error: $e");
    }
  }

  /// ❌ Menghapus kategori supplier
  Future<void> deleteSupplierCategory(int id) async {
    try {
      final token = await ApiConfig.getTokenJWT();
      final response = await _dio.delete(
        "${ApiConfig.supplier_categories_endpoint}/$id",
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );

      print("✅ DELETE Response: ${response.data}");
    } catch (e) {
      print("❌ DELETE Error: $e");
    }
  }
}
