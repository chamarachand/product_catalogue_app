import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:product_catalogue_app/core/errors/exceptions.dart';
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

    test('returns a list of products on success', () async {
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

    test('rethrows AppException when ApiService throws AppException', () async {
      // Arrange
      when(
        () => mockApiService.fetchProducts(),
      ).thenThrow(const ServerException('Server failed'));

      // Act & Assert
      expect(
        () async => await repository.getProducts(),
        throwsA(isA<ServerException>()),
      );
    });

    test('throws UnknownException when an generic exception occurs', () async {
      // Arrange
      when(
        () => mockApiService.fetchProducts(),
      ).thenThrow(Exception('Unexpected network error'));

      // Act & Assert
      expect(
        () async => await repository.getProducts(),
        throwsA(isA<UnknownException>()),
      );
    });

    test('getFavouriteIds returns saved favourite IDs', () {
      // Arrange
      final favouriteIds = {1, 3, 5};

      when(
        () => mockLocalStorageService.getFavouriteIds(),
      ).thenReturn(favouriteIds);

      // Act
      final result = repository.getFavouriteIds();

      // Assert
      expect(result, favouriteIds);
    });

    test('saveFavouriteIds saves favourite IDs', () async {
      // Arrange
      final favouriteIds = {2, 4};

      when(
        () => mockLocalStorageService.saveFavouriteIds(favouriteIds),
      ).thenAnswer((_) async {});

      // Act
      await repository.saveFavouriteIds(favouriteIds);

      // Assert
      verify(
        () => mockLocalStorageService.saveFavouriteIds(favouriteIds),
      ).called(1);
    });
  });
}
