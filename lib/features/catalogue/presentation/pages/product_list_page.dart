import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:product_catalogue_app/features/catalogue/cubit/product_cubit.dart';
import 'package:product_catalogue_app/features/catalogue/cubit/product_state.dart';
import 'package:product_catalogue_app/features/catalogue/data/models/product.dart';
import 'package:product_catalogue_app/features/catalogue/presentation/pages/product_details_page.dart';
import 'package:product_catalogue_app/features/catalogue/presentation/widgets/product_card.dart';
import 'package:product_catalogue_app/features/catalogue/presentation/widgets/search_box.dart';
import 'package:product_catalogue_app/features/theme/cubit/theme_cubit.dart';

class ProductListPage extends StatelessWidget {
  const ProductListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Catalogue",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: BlocBuilder<ThemeCubit, ThemeMode>(
              builder: (context, themeMode) {
                final isDark = (themeMode == ThemeMode.dark);

                return IconButton(
                  onPressed: () => context.read<ThemeCubit>().toggleTheme(),
                  icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
                );
              },
            ),
          ),
        ],
      ),
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
                  return _ProductErrorView(
                    msg: state.message,
                    onRetry: () => context.read<ProductCubit>().fetchProducts(),
                  );
                }

                if (state is ProductsLoaded) {
                  if (state.displayProducts.isEmpty) {
                    final isSearchResultsEmpty = state.allProducts.isNotEmpty;

                    return _ProductEmptyView(
                      isSearchResultEmpty: isSearchResultsEmpty,
                    );
                  }

                  return _ProductsGridView(
                    displayProducts: state.displayProducts,
                    favouriteIds: state.favouriteIds,
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

class _ProductEmptyView extends StatelessWidget {
  final bool isSearchResultEmpty;

  const _ProductEmptyView({required this.isSearchResultEmpty});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isSearchResultEmpty
                  ? Icons.search_off
                  : Icons.inventory_2_outlined,
              size: 60,
              color: Theme.of(context).disabledColor,
            ),
            const SizedBox(height: 16),
            Text(
              isSearchResultEmpty
                  ? "No products match your search."
                  : "No products available.",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
      ),
    );
  }
}

class _ProductErrorView extends StatelessWidget {
  final String msg;
  final VoidCallback onRetry;

  const _ProductErrorView({required this.msg, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline_outlined,
              size: 60,
              color: Theme.of(context).disabledColor,
            ),
            const SizedBox(height: 16),
            Text(
              msg,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProductsGridView extends StatelessWidget {
  final List<Product> displayProducts;
  final Set<int> favouriteIds;

  const _ProductsGridView({
    required this.displayProducts,
    required this.favouriteIds,
  });

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        await context.read<ProductCubit>().fetchProducts();
      },
      child: GridView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 220,
          childAspectRatio: 0.63,
        ),

        itemCount: displayProducts.length,
        itemBuilder: (context, index) {
          final product = displayProducts[index];
          final isFavourite = favouriteIds.contains(product.id);

          return ProductCard(
            product: product,
            isFavourite: isFavourite,
            onFavouriteToggle: () {
              context.read<ProductCubit>().toggleFavourite(product.id);
            },
            onTap: () {
              FocusScope.of(context).unfocus();

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ProductDetailsPage(product: product),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
