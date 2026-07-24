import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:product_catalogue_app/features/catalogue/cubit/product_cubit.dart';
import 'package:product_catalogue_app/features/catalogue/cubit/product_state.dart';
import 'package:product_catalogue_app/features/catalogue/presentation/pages/product_details_page.dart';
import 'package:product_catalogue_app/features/catalogue/presentation/widgets/product_card.dart';
import 'package:product_catalogue_app/features/catalogue/presentation/widgets/search_box.dart';

class ProductListPage extends StatelessWidget {
  const ProductListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Catalog"), centerTitle: true),
      body: Column(
        children: [
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 500),
              child: const SearchBox(),
            ),
          ),
          Expanded(
            child: BlocBuilder<ProductCubit, ProductState>(
              builder: (context, state) {
                if (state is ProductsLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state is ProductsError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: .center,
                      children: [
                        Text(state.message),
                        ElevatedButton(
                          onPressed: () {
                            context.read<ProductCubit>().fetchProducts();
                          },
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  );
                }

                if (state is ProductsLoaded) {
                  if (state.displayProducts.isEmpty) {
                    return const Text("No products available");
                  }

                  return GridView.builder(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 220,
                      childAspectRatio: 0.65,
                    ),

                    itemCount: state.displayProducts.length,
                    itemBuilder: (context, index) {
                      final product = state.displayProducts[index];
                      final isFavourite = state.favouriteIds.contains(
                        product.id,
                      );

                      return ProductCard(
                        product: product,
                        isFavourite: isFavourite,
                        onFavouriteToggle: () {
                          context.read<ProductCubit>().toggleFavourite(
                            product.id,
                          );
                        },
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  ProductDetailsPage(product: product),
                            ),
                          );
                        },
                      );
                    },
                  );
                }

                return const SizedBox();
              },
            ),
          ),
        ],
      ),
    );
  }
}
