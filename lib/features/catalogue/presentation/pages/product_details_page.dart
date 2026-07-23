import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:product_catalogue_app/core/constants/app_constants.dart';
import 'package:product_catalogue_app/features/catalogue/cubit/product_cubit.dart';
import 'package:product_catalogue_app/features/catalogue/cubit/product_state.dart';
import 'package:product_catalogue_app/features/catalogue/data/models/product.dart';

class ProductDetailsPage extends StatelessWidget {
  final Product product;

  const ProductDetailsPage({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Details'),
        actions: [
          BlocBuilder<ProductCubit, ProductState>(
            builder: (context, state) {
              final isFavourite =
                  state is ProductsLoaded &&
                  state.favouriteIds.contains(product.id);

              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: IconButton(
                  icon: Icon(
                    isFavourite ? Icons.favorite : Icons.favorite_border,
                    color: isFavourite ? Colors.red : null,
                  ),
                  onPressed: () {
                    context.read<ProductCubit>().toggleFavourite(product.id);
                  },
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Hero(
                tag: 'product-image-${product.id}',
                child: CachedNetworkImage(
                  imageUrl: product.images.isNotEmpty
                      ? product.images.first
                      : product.thumbnail,
                  height: 300,
                  fit: BoxFit.contain,
                  fadeInDuration: Duration.zero,
                  // placeholder: (context, url) =>
                  //     const Center(child: CircularProgressIndicator()),
                  placeholder: (context, url) => CachedNetworkImage(
                    imageUrl: product.thumbnail,
                    fit: BoxFit.contain,
                  ),
                  errorWidget: (context, url, error) =>
                      const Icon(Icons.image_not_supported, size: 80),
                ),
              ),
            ),

            const SizedBox(height: 24),

            Text(
              product.title,
              style: Theme.of(context).textTheme.headlineSmall,
            ),

            const SizedBox(height: 12),

            Text(
              '${AppConstants.currency}${product.price.toStringAsFixed(2)}',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),

            const SizedBox(height: 16),

            Chip(label: Text(product.category.toUpperCase())),

            const SizedBox(height: 24),

            Text('Description', style: Theme.of(context).textTheme.titleMedium),

            const SizedBox(height: 8),

            Text(
              product.description,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
      ),
    );
  }
}
