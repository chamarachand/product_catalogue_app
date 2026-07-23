import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:product_catalogue_app/core/services/api_service.dart';
import 'package:product_catalogue_app/core/services/local_storage_service.dart';
import 'package:product_catalogue_app/features/catalogue/data/models/product.dart';
import 'package:product_catalogue_app/features/catalogue/data/repository/product_repository.dart';

class MockApiService extends Mock implements ApiService {}

class MockLocalStorageService extends Mock implements LocalStorageService {}

void main() {
  late MockApiService mockApiService;
  late MockLocalStorageService mockLocalStorageService;
  late ProductRepository repository;

  setUp(() {
    mockApiService = MockApiService();
    mockLocalStorageService = MockLocalStorageService();

    repository = ProductRepository(
      apiService: mockApiService,
      localStorageService: mockLocalStorageService,
    );
  });

  group('ProductRepository Unit Tests', () {
    final mockJsonResponse = [
      {
        'id': 1,
        'title': 'Test Product 1',
        'description': 'A nice test product',
        'category': 'beauty',
        'price': 19.99,
        'thumbnail': 'https://example.com/thumb.png',
        'images': ['https://example.com/img.png'],
      },
      {
        'id': 2,
        'title': 'Test Product 2',
        'description': 'Another test product',
        'category': 'fragrances',
        'price': 49.00,
        'thumbnail': 'https://example.com/thumb2.png',
        'images': ['https://example.com/img2.png'],
      },
    ];

    test('getProducts on success', () async {
      // Arrange
      when(
        () => mockApiService.fetchProducts(),
      ).thenAnswer((_) async => mockJsonResponse);

      // Act
      final result = await repository.getProducts();

      // Assert
      expect(result, isA<List<Product>>());
      expect(result.length, 2);
      expect(result.first.title, 'Test Product 1');
      expect(result.first.price, 19.99);
    });

    test('getProducts fails', () async {
      // Arrange
      when(
        () => mockApiService.fetchProducts(),
      ).thenThrow(Exception('Could not connect'));

      // Act and Assert
      expect(
        () async => await repository.getProducts(),
        throwsA(isA<Exception>()),
      );
    });
  });
}
