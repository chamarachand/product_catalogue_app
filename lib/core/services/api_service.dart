import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:product_catalogue_app/core/constants/url_constants.dart';
import 'package:product_catalogue_app/core/errors/exceptions.dart';

class ApiService {
  Future<List<dynamic>> fetchProducts() async {
    const String baseUrl = '${UrlConstants.baseUrl}${UrlConstants.products}';
    debugPrint("baseUrl $baseUrl");
    final uri = Uri.parse(baseUrl);

    final http.Response response;
    try {
      response = await http.get(uri);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        return data['products'] as List<dynamic>;
      } else {
        debugPrint("Server error: ${response.statusCode}");
        throw const ServerException();
      }
    } on SocketException catch (e) {
      debugPrint("Network error: $e");
      throw const NetworkException();
    } on AppException {
      rethrow;
    } catch (e) {
      debugPrint("fetchProducts error: $e");
      throw const UnknownException();
    }
  }
}
