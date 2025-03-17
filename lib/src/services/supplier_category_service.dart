import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/supplier.dart';
import '../utils/api_config.dart';

class SupplierCategoryService {
  final Dio _dio = Dio();

  Future<String> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('tokenJWT') ?? "";
  }

  Future<String> getToken() async{
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('tokenJWT') ?? "";
  }

/*************  ✨ Codeium Command ⭐  *************/
  /// Fetches the list of suppliers from the API.
  ///
  /// This function makes an authenticated GET request to the suppliers API
  /// endpoint using a JWT token. If the response is successful and contains
  /// supplier data, it parses the JSON data into a list of `Supplier` objects.
  ///
  /// Returns a `Future` that completes with a list of `Supplier` objects if
  /// the API call is successful. If the API response format is not as expected
  /// or if there is a network error, the function returns an empty list.
  ///
  /// Throws an `Exception` if the response format is invalid.

/******  fa5778ab-833b-47cd-848d-0f6f81e2e852  *******/
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
    final token = await getToken();
    final response = await _dio.get(
      "http://api.vimedika.com:4002/api/supplier_categories",
      options: Options(headers: {"Authorization": "Bearer $token"}),
    );

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
