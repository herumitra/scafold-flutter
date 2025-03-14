import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/supplier.dart';
import '../utils/api_config.dart';

class SupplierService {
  final Dio _dio = Dio();

  Future<String> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('tokenJWT') ?? "";
  }

  Future<List<Supplier>> getSuppliers() async {
    try {
      final token = await _getToken();
      // print("Token JWT: $token");
      // print("Calling API: ${ApiConfig.suppliers}");

      final response = await _dio.get(
        ApiConfig.suppliers,
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
    } on DioException catch (e) {
      // print("Dio Error: ${e.response?.statusCode} - ${e.message}");
      // print("Error Response: ${e.response?.data}");
      return [];
    } catch (e) {
      // print("Error: $e");
      return [];
    }
  }

  Future<void> createSupplier(
    String name,
    String phone,
    String address,
    String pic,
    int categoryId,
  ) async {
    final token = await _getToken();
    await _dio.post(
      ApiConfig.suppliers,
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
    final token = await _getToken();
    await _dio.put(
      "${ApiConfig.suppliers}/$id",
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
    final token = await _getToken();
    await _dio.delete(
      "${ApiConfig.suppliers}/$id",
      options: Options(headers: {"Authorization": "Bearer $token"}),
    );
  }
}
