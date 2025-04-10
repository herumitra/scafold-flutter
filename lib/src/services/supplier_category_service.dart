import 'package:dio/dio.dart';
import '../models/supplier_category.dart';
import '../utils/api_config.dart';

// Initialize Dio
class SupplierCategoryService {
  final Dio _dio = Dio();

  // Get Supplier Categories
  Future<List<SupplierCategory>> getSupplierCategories() async {
    try {
      final token = await ApiConfig.getTokenJWT();
      final response = await _dio.get(
        ApiConfig.supplier_categories_endpoint,
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );

      // Pastikan response adalah Map, lalu ambil hanya data
      if (response.data is Map<String, dynamic> &&
          response.data.containsKey("data")) {
        final List<dynamic> supplierCategoryList = response.data["data"];
        return supplierCategoryList
            .map((json) => SupplierCategory.fromJson(json))
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

  // Create Supplier Category
  Future<void> createSupplierCategory(String name) async {
    final token = await ApiConfig.getTokenJWT();
    await _dio.post(
      ApiConfig.supplier_categories_endpoint,
      data: {"name": name},
      options: Options(headers: {"Authorization": "Bearer $token"}),
    );
  }

  // Update Supplier Category
  Future<void> updateSupplierCategory(int id, String name) async {
    final token = await ApiConfig.getTokenJWT();
    await _dio.put(
      "${ApiConfig.supplier_categories_endpoint}/$id",
      data: {"name": name},
      options: Options(headers: {"Authorization": "Bearer $token"}),
    );
  }

  // Delete Supplier Category
  Future<void> deleteSupplierCategory(int id) async {
    final token = await ApiConfig.getTokenJWT();
    await _dio.delete(
      "${ApiConfig.supplier_categories_endpoint}/$id",
      options: Options(headers: {"Authorization": "Bearer $token"}),
    );
  }
}
