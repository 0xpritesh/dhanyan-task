import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product_model.dart';

class ProductRepository {
  final String baseUrl =
      "https://69392e32c8d59937aa06c656.mockapi.io/list/dhanyan";

  Future<List<ProductModel>> fetchProducts(int page) async {
    final response = await http.get(
      Uri.parse("$baseUrl?page=$page&limit=20"),
    );

    if (response.statusCode == 200) {
      final List jsonList = jsonDecode(response.body);
      return jsonList.map((e) => ProductModel.fromJson(e)).toList();
    } else {
      throw Exception("Failed to load products");
    }
  }
}