import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:product_catalogue_app/features/catalogue/cubit/product_cubit.dart';
import 'package:product_catalogue_app/features/catalogue/data/repository/product_repository.dart';
import 'package:product_catalogue_app/features/catalogue/presentation/pages/product_list_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.deepPurple)),

      // home: const MyHomePage(title: 'Flutter Demo Home Page'),
      home: BlocProvider(
        create: (_) =>
            ProductCubit(repository: ProductRepository())..fetchProducts(),
        child: const ProductListPage(),
      ),
    );
  }
}
