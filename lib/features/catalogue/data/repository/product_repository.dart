import 'package:flutter/material.dart';
import 'package:product_catalogue_app/core/services/api_service.dart';
import 'package:product_catalogue_app/features/catalogue/data/models/product.dart';

class ProductRepository {
  final ApiService _apiService;

  ProductRepository({ApiService? apiService})
    : _apiService = apiService ?? ApiService();

  Future<List<Product>> getProducts() async {
    try {
      final productsRaw = await _apiService.fetchProducts();

      final products = productsRaw
          .map((product) => Product.fromJson(product))
          .toList();
      debugPrint("Products $products");
      return products;
    } catch (e) {
      throw Exception(); // change later to customer error handling
    }
  }
}
