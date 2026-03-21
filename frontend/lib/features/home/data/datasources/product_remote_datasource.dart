import 'package:injectable/injectable.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/network/api_client.dart';
import '../../../shared/data/models/category_model.dart';
import '../../../shared/data/models/product_model.dart';

/// Remote data source for products
abstract class ProductRemoteDataSource {
  Future<List<ProductModel>> getAllProducts();
  Future<List<ProductModel>> getProductsByCategory(String categoryId);
  Future<ProductModel> getProductById(String id);
  Future<List<ProductModel>> searchProducts(String query);
  Future<List<CategoryModel>> getCategories();
}

@LazySingleton(as: ProductRemoteDataSource)
class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  final ApiClient apiClient;

  ProductRemoteDataSourceImpl(this.apiClient);

  @override
  Future<List<ProductModel>> getAllProducts() async {
    try {
      final data = await apiClient.get(ApiConstants.products);
      return (data as List)
          .map((json) => ProductModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } on AppException {
      rethrow;
    } catch (e) {
      throw ServerException('Erreur lors de la récupération des produits');
    }
  }

  @override
  Future<List<ProductModel>> getProductsByCategory(String categoryId) async {
    try {
      final data = await apiClient.get(
        ApiConstants.products,
        queryParameters: {'category': categoryId},
      );
      return (data as List)
          .map((json) => ProductModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } on AppException {
      rethrow;
    } catch (e) {
      throw ServerException('Erreur lors de la récupération des produits');
    }
  }

  @override
  Future<ProductModel> getProductById(String id) async {
    try {
      final data = await apiClient.get(ApiConstants.product(id));
      return ProductModel.fromJson(data as Map<String, dynamic>);
    } on AppException {
      rethrow;
    } catch (e) {
      throw ServerException('Erreur lors de la récupération du produit');
    }
  }

  @override
  Future<List<ProductModel>> searchProducts(String query) async {
    try {
      final data = await apiClient.get(
        ApiConstants.products,
        queryParameters: {'q': query},
      );
      return (data as List)
          .map((json) => ProductModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } on AppException {
      rethrow;
    } catch (e) {
      throw ServerException('Erreur lors de la recherche');
    }
  }

  @override
  Future<List<CategoryModel>> getCategories() async {
    try {
      final data = await apiClient.get(ApiConstants.categories);
      return (data as List)
          .map((json) => CategoryModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } on AppException {
      rethrow;
    } catch (e) {
      throw ServerException('Erreur lors de la récupération des catégories');
    }
  }
}
