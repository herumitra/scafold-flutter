import 'package:dio/dio.dart';
import '../models/unit.dart';
import '../utils/api_config.dart';

// Initialize Dio
class UnitService {
  final Dio _dio = Dio();

  // Get Supplier Categories
  Future<List<Unit>> getUnits() async {
    try {
      final token = await ApiConfig.getTokenJWT();
      final response = await _dio.get(
        ApiConfig.units_endpoint,
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );

      // Pastikan response adalah Map, lalu ambil hanya data
      if (response.data is Map<String, dynamic> &&
          response.data.containsKey("data")) {
        final List<dynamic> supplierCategoryList = response.data["data"];
        return supplierCategoryList.map((json) => Unit.fromJson(json)).toList();
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

  // Create Unit
  Future<void> createUnit(String name) async {
    final token = await ApiConfig.getTokenJWT();
    await _dio.post(
      ApiConfig.units_endpoint,
      data: {"name": name},
      options: Options(headers: {"Authorization": "Bearer $token"}),
    );
  }

  // Update Unit
  Future<void> updateUnit(String id, String name) async {
    final token = await ApiConfig.getTokenJWT();
    await _dio.put(
      "${ApiConfig.units_endpoint}/$id",
      data: {"name": name},
      options: Options(headers: {"Authorization": "Bearer $token"}),
    );
  }

  // Delete Unit
  Future<void> deleteUnit(String id) async {
    final token = await ApiConfig.getTokenJWT();
    await _dio.delete(
      "${ApiConfig.units_endpoint}/$id",
      options: Options(headers: {"Authorization": "Bearer $token"}),
    );
  }
}
