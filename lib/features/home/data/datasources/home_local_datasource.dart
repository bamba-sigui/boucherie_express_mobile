import 'package:injectable/injectable.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/network/api_client.dart';
import '../../../shared/data/models/product_model.dart';
import '../../../shared/domain/entities/product.dart';
import '../../domain/entities/home_category.dart';

/// Source de données pour la feature Home.
///
/// Connectée au backend Flask pour les produits, catégories et favoris.
abstract class HomeLocalDataSource {
  Future<List<Product>> getProducts({String? categoryId});
  Future<List<HomeCategory>> getCategories();
  Future<void> toggleFavorite(String productId);
  Future<List<Product>> searchProducts(String query);
  Future<List<Product>> getFavoriteProducts();
  Set<String> get favoriteIds;
}

@LazySingleton(as: HomeLocalDataSource)
class HomeLocalDataSourceImpl implements HomeLocalDataSource {
  final ApiClient _apiClient;

  /// Cache local des IDs favoris pour un accès synchrone.
  final Set<String> _favoriteIds = {};

  HomeLocalDataSourceImpl(this._apiClient);

  @override
  Set<String> get favoriteIds => _favoriteIds;

  @override
  Future<List<Product>> getProducts({String? categoryId}) async {
    final queryParams = <String, dynamic>{};
    if (categoryId != null && categoryId.isNotEmpty && categoryId != 'tout') {
      queryParams['category'] = categoryId;
    }

    final data = await _apiClient.get(
      ApiConstants.products,
      queryParameters: queryParams.isNotEmpty ? queryParams : null,
    );
    return (data as List)
        .map(
          (json) => ProductModel.fromJson(json as Map<String, dynamic>),
        )
        .toList();
  }

  @override
  Future<List<HomeCategory>> getCategories() async {
    final data = await _apiClient.get(ApiConstants.categories);
    final apiCategories = (data as List)
        .map((json) {
          final map = json as Map<String, dynamic>;
          return HomeCategory(
            id: map['id'] as String,
            name: map['name'] as String,
            icon: map['icon'] as String? ?? '',
          );
        })
        .toList();

    // Ajouter la catégorie "Tout" en tête
    return [
      const HomeCategory(id: 'tout', name: 'Tout', icon: '🏠'),
      ...apiCategories,
    ];
  }

  @override
  Future<void> toggleFavorite(String productId) async {
    if (_favoriteIds.contains(productId)) {
      await _apiClient.delete(ApiConstants.favorite(productId));
      _favoriteIds.remove(productId);
    } else {
      await _apiClient.post(ApiConstants.favorite(productId));
      _favoriteIds.add(productId);
    }
  }

  @override
  Future<List<Product>> searchProducts(String query) async {
    final data = await _apiClient.get(
      ApiConstants.products,
      queryParameters: {'q': query},
    );
    return (data as List)
        .map(
          (json) => ProductModel.fromJson(json as Map<String, dynamic>),
        )
        .toList();
  }

  @override
  Future<List<Product>> getFavoriteProducts() async {
    final data = await _apiClient.get(ApiConstants.favorites);
    final products = (data as List)
        .map(
          (json) => ProductModel.fromJson(json as Map<String, dynamic>),
        )
        .toList();

    // Sync le cache local
    _favoriteIds
      ..clear()
      ..addAll(products.map((p) => p.id));

    return products;
  }
}
