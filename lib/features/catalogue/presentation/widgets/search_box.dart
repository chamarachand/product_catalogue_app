import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:product_catalogue_app/features/catalogue/cubit/product_cubit.dart';

class SearchBox extends StatefulWidget {
  const SearchBox({super.key});

  @override
  State<SearchBox> createState() => _SearchBoxState();
}

class _SearchBoxState extends State<SearchBox> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _clearSearch() {
    _searchController.clear();
    context.read<ProductCubit>().searchProducts('');
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Search Products...',
          prefixIcon: const Icon(Icons.search),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  onPressed: _clearSearch,
                  icon: const Icon(Icons.clear),
                )
              : null,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        onChanged: (value) {
          context.read<ProductCubit>().searchProducts(value);
          setState(() {});
        },
      ),
    );
  }
}
