import 'package:flutter/material.dart';
import 'package:product_catalogue_app/features/catalogue/data/models/product.dart';

@immutable
sealed class ProductState {}

class ProductInitial extends ProductState {}

class ProductsLoading extends ProductState {}

class ProductsLoaded extends ProductState {
  final List<Product> allProducts;
  final List<Product> displayProducts;
  final Set<int> favouriteIds;
  final String searchQuery;

  ProductsLoaded({
    required this.allProducts,
    required this.displayProducts,
    this.favouriteIds = const {},
    this.searchQuery = '',
  });

  ProductsLoaded copyWith({
    List<Product>? allProducts,
    List<Product>? displayProducts,
    Set<int>? favouriteIds,
    String? searchQuery,
  }) {
    return ProductsLoaded(
      allProducts: allProducts ?? this.allProducts,
      displayProducts: displayProducts ?? this.displayProducts,
      favouriteIds: favouriteIds ?? this.favouriteIds,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}

class ProductsError extends ProductState {
  final String message;

  ProductsError(this.message);
}
