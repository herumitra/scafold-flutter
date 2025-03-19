import 'package:dio/dio.dart';
import '../models/supplier.dart';
import '../utils/api_config.dart';

class SupplierService {
  final Dio _dio = Dio();

  Future<List<Supplier>> getSuppliers() async {
    try {
      final token = await ApiConfig.getTokenJWT();
      final response = await _dio.get(
        ApiConfig.suppliers_endpoint,
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );

      // Pastikan response adalah Map, lalu ambil hanya data
      if (response.data is Map<String, dynamic> &&
          response.data.containsKey("data")) {
        final List<dynamic> supplierList = response.data["data"];
        // print("Supplier List: $supplierList");

        return supplierList.map((json) => Supplier.fromJson(json)).toList();
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

  Future<List<Map<String, dynamic>>> getSupplierCategories() async {
    final token = await ApiConfig.getTokenJWT();
    final response = await _dio.get(ApiConfig.supplier_categories_endpoint,options: Options(headers: {"Authorization": "Bearer $token"}));

    if (response.data["status"] == "success") {
      return List<Map<String, dynamic>>.from(response.data["data"]);
    } else {
      throw Exception("Gagal mengambil kategori");
    }
  }

  Future<void> createSupplier(
    String name,
    String phone,
    String address,
    String pic,
    int categoryId,
  ) async {
    final token = await ApiConfig.getTokenJWT();
    await _dio.post(
      ApiConfig.suppliers_endpoint,
      data: {
        "name": name,
        "phone": phone,
        "address": address,
        "pic": pic,
        "supplier_category_id": categoryId,
      },
      options: Options(headers: {"Authorization": "Bearer $token"}),
    );
  }

  Future<void> updateSupplier(
    String id,
    String name,
    String phone,
    String address,
    String pic,
    int categoryId,
  ) async {
    final token = await ApiConfig.getTokenJWT();
    await _dio.put(
      "${ApiConfig.suppliers_endpoint}/$id",
      data: {
        "name": name,
        "phone": phone,
        "address": address,
        "pic": pic,
        "supplier_category_id": categoryId,
      },
      options: Options(headers: {"Authorization": "Bearer $token"}),
    );
  }

  Future<void> deleteSupplier(String id) async {
    final token = await ApiConfig.getTokenJWT();
    await _dio.delete(
      "${ApiConfig.suppliers_endpoint}/$id",
      options: Options(headers: {"Authorization": "Bearer $token"}),
    );
  }
}
