import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:product_catalogue_app/features/catalogue/cubit/product_state.dart';
import 'package:product_catalogue_app/features/catalogue/data/repository/product_repository.dart';

class ProductCubit extends Cubit<ProductState> {
  final ProductRepository repository;

  ProductCubit({required this.repository}) : super(ProductInitial());

  Future<void> fetchProducts() async {
    emit(ProductsLoading());

    try {
      final products = await repository.getProducts();
      emit(ProductsLoaded(allProducts: products, displayProducts: products));
    } catch (e, stacktrace) {
      debugPrint("fetchProducts error $e");
      debugPrint("fetchProducts error stack $stacktrace");

      emit(ProductsError("Unable to load products. Please try again later"));
    }
  }

  void searchProducts(String query) {
    if (state is ProductsLoaded) {
      final currentState = state as ProductsLoaded;

      final filtered = query.trim().isEmpty
          ? currentState.allProducts
          : currentState.allProducts
                .where(
                  (product) =>
                      product.title.toLowerCase().contains(query.toLowerCase()),
                )
                .toList();

      emit(
        ProductsLoaded(
          allProducts: currentState.allProducts,
          displayProducts: filtered,
        ),
      );
    }
  }
}
