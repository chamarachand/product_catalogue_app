import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:product_catalogue_app/core/errors/exceptions.dart';

import 'package:product_catalogue_app/features/catalogue/cubit/product_state.dart';
import 'package:product_catalogue_app/features/catalogue/data/models/product.dart';
import 'package:product_catalogue_app/features/catalogue/data/repository/product_repository.dart';

class ProductCubit extends Cubit<ProductState> {
  final ProductRepository repository;

  ProductCubit({required this.repository}) : super(ProductInitial());

  Future<void> fetchProducts() async {
    final currentQuery = state is ProductsLoaded
        ? (state as ProductsLoaded).searchQuery
        : '';

    emit(ProductsLoading());

    try {
      final products = await repository.getProducts();
      final savedFavourites = repository.getFavouriteIds();

      emit(
        ProductsLoaded(
          allProducts: products,
          displayProducts: currentQuery.isEmpty
              ? products
              : _filterProducts(products, currentQuery),
          searchQuery: currentQuery,
          favouriteIds: savedFavourites,
        ),
      );
    } on AppException catch (e) {
      emit(ProductsError(e.message));
    } catch (e, stacktrace) {
      debugPrint("fetchProducts error $e");
      debugPrint("fetchProducts error stack $stacktrace");

      emit(ProductsError("Something went wrong. Please try again."));
    }
  }

  void searchProducts(String query) {
    if (state is ProductsLoaded) {
      final currentState = state as ProductsLoaded;
      final trimmedQuery = query.trim();

      final filtered = trimmedQuery.isEmpty
          ? currentState.allProducts
          : _filterProducts(currentState.allProducts, trimmedQuery);

      emit(
        currentState.copyWith(
          displayProducts: filtered,
          searchQuery: trimmedQuery,
        ),
      );
    }
  }

  Future<void> toggleFavourite(int productId) async {
    if (state is ProductsLoaded) {
      final currentState = state as ProductsLoaded;
      final favouriteIds = Set<int>.from(currentState.favouriteIds);

      if (favouriteIds.contains(productId)) {
        favouriteIds.remove(productId);
      } else {
        favouriteIds.add(productId);
      }

      emit(currentState.copyWith(favouriteIds: favouriteIds));

      await repository.saveFavouriteIds(favouriteIds);
    }
  }

  List<Product> _filterProducts(List<Product> products, String query) {
    if (query.isEmpty) return products;
    return products
        .where((p) => p.title.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }
}
