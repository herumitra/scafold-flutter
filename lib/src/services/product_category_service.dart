import 'package:dio/dio.dart';
import '../models/product_category.dart';
import '../utils/api_config.dart';

// Initialize Dio
class ProductCategoryService {
  final Dio _dio = Dio();

  // Get Product Categories
  Future<List<ProductCategory>> getProductCategories() async {
    try {
      final token = await ApiConfig.getTokenJWT();
      final response = await _dio.get(
        ApiConfig.product_categories_endpoint,
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );

      // Pastikan response adalah Map, lalu ambil hanya data
      if (response.data is Map<String, dynamic> &&
          response.data.containsKey("data")) {
        final List<dynamic> productCategoryList = response.data["data"];
        return productCategoryList
            .map((json) => ProductCategory.fromJson(json))
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

  // Create Product Category
  Future<void> createProductCategory(String name) async {
    final token = await ApiConfig.getTokenJWT();
    await _dio.post(
      ApiConfig.product_categories_endpoint,
      data: {"name": name},
      options: Options(headers: {"Authorization": "Bearer $token"}),
    );
  }

  // Update Product Category
  Future<void> updateProductCategory(int id, String name) async {
    final token = await ApiConfig.getTokenJWT();
    await _dio.put(
      "${ApiConfig.product_categories_endpoint}/$id",
      data: {"name": name},
      options: Options(headers: {"Authorization": "Bearer $token"}),
    );
  }

  // Delete Product Category
  Future<void> deleteProductCategory(int id) async {
    final token = await ApiConfig.getTokenJWT();
    await _dio.delete(
      "${ApiConfig.product_categories_endpoint}/$id",
      options: Options(headers: {"Authorization": "Bearer $token"}),
    );
  }
}
