// lib/data/repositories/property_repository.dart
import 'dart:convert';
import 'package:dhanyan/data/models/product_model.dart';
import 'package:http/http.dart' as http;

class PropertyRepository {
  final String baseUrl =
      "https://69392e32c8d59937aa06c656.mockapi.io/list/dhanyan";

  Future<List<PropertyModel>> getProperties({
    required int page,
    int limit = 100,
  }) async {
    final url = Uri.parse("$baseUrl?page=$page&limit=$limit");
    final resp = await http.get(url);

    if (resp.statusCode == 200) {
      final List body = jsonDecode(resp.body) as List;
      return body.map((e) => PropertyModel.fromJson(e as Map<String, dynamic>)).toList();
    } else {
      throw Exception("Failed to load properties: ${resp.statusCode}");
    }
  }

  Future<bool> deleteProperty(String id) async {
    final url = Uri.parse("$baseUrl/$id");
    final resp = await http.delete(url);
    return resp.statusCode == 200 || resp.statusCode == 204;
  }

  Future<PropertyModel?> getPropertyById(String id) async {
    final url = Uri.parse("$baseUrl/$id");
    final resp = await http.get(url);
    if (resp.statusCode == 200) {
      return PropertyModel.fromJson(jsonDecode(resp.body));
    }
    return null;
  }
}
