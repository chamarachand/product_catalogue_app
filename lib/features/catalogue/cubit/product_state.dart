import 'package:flutter/material.dart';
import 'package:product_catalogue_app/features/catalogue/data/models/product.dart';

@immutable
sealed class ProductState {}

class ProductInitial extends ProductState {}

class ProductsLoading extends ProductState {}

class ProductsLoaded extends ProductState {
  final List<Product> products;

  ProductsLoaded(this.products);
}

class ProductsError extends ProductState {
  final String message;

  ProductsError(this.message);
}
