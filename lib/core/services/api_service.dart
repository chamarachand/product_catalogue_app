import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:product_catalogue_app/core/constants/url_constants.dart';

class ApiService {
  Future<List<dynamic>> fetchProducts() async {
    const String baseUrl = '${UrlConstants.baseUrl}${UrlConstants.products}';
    debugPrint("baseUrl $baseUrl");
    final uri = Uri.parse(baseUrl);

    late final http.Response response;
    try {
      response = await http.get(uri);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        return data['products'] as List<dynamic>;
      } else {
        throw Exception('API Error');
      }
    } catch (e) {
      throw Exception('Could not connect');
    }
  }
}
