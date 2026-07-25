import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:product_catalogue_app/core/services/local_storage_service.dart';
import 'package:product_catalogue_app/core/theme/app_theme.dart';
import 'package:product_catalogue_app/features/catalogue/cubit/product_cubit.dart';
import 'package:product_catalogue_app/features/catalogue/data/repository/product_repository.dart';
import 'package:product_catalogue_app/features/catalogue/presentation/pages/product_list_page.dart';
import 'package:product_catalogue_app/features/theme/cubit/theme_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();
  final localStorageService = LocalStorageService(prefs);

  final productRepository = ProductRepository(
    localStorageService: localStorageService,
  );

  runApp(
    MyApp(
      productRepository: productRepository,
      localStorageService: localStorageService,
    ),
  );
}

class MyApp extends StatelessWidget {
  final ProductRepository productRepository;
  final LocalStorageService localStorageService;

  const MyApp({
    super.key,
    required this.productRepository,
    required this.localStorageService,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) =>
              ProductCubit(repository: productRepository)..fetchProducts(),
        ),
        BlocProvider(
          create: (_) => ThemeCubit(localStorageService: localStorageService),
        ),
      ],
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, themeMode) {
          return MaterialApp(
            title: 'Product Catalogue',
            themeMode: themeMode,
            theme: AppTheme.light,
            darkTheme: AppTheme.dark,
            home: const ProductListPage(),
          );
        },
      ),
    );
  }
}
