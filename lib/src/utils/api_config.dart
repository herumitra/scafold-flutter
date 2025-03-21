import 'package:shared_preferences/shared_preferences.dart';

class ApiConfig {
  // URL API
  static const String baseUrl = "http://api.vimedika.com:4002";

  // URL API Auth
  static const String baseUrlAuth = "http://api.vimedika.com:4001";

  // Endpoint API for Suppliers
  static const String suppliers_endpoint = "$baseUrl/api/suppliers";

  // Endpoint API for Supplier Categories
  static const String supplier_categories_endpoint =
      "$baseUrl/api/supplier_categories";

  // Endpoint API for Member Categories
  static const String member_categories_endpoint =
      "$baseUrl/api/member_categories";

  // Endpoint API for Product Categories
  static const String product_categories_endpoint =
      "$baseUrl/api/product_categories";

  // Static method to get token
  static Future<String> getTokenJWT() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('tokenJWT') ?? "";
  }

  // Static method to set token
  static Future<void> setTokenJWT(String tokenJWT) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('tokenJWT', tokenJWT);
  }
}
