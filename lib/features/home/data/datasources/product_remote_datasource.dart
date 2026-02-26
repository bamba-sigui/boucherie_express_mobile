import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/error/exceptions.dart';
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
  final FirebaseFirestore firestore;

  ProductRemoteDataSourceImpl(this.firestore);

  @override
  Future<List<ProductModel>> getAllProducts() async {
    try {
      final snapshot = await firestore
          .collection(AppConstants.collectionProducts)
          .get();

      return snapshot.docs
          .map((doc) => ProductModel.fromJson({...doc.data(), 'id': doc.id}))
          .toList();
    } catch (e) {
      throw ServerException('Erreur lors de la récupération des produits');
    }
  }

  @override
  Future<List<ProductModel>> getProductsByCategory(String categoryId) async {
    try {
      final snapshot = await firestore
          .collection(AppConstants.collectionProducts)
          .where('category', isEqualTo: categoryId)
          .get();

      return snapshot.docs
          .map((doc) => ProductModel.fromJson({...doc.data(), 'id': doc.id}))
          .toList();
    } catch (e) {
      throw ServerException('Erreur lors de la récupération des produits');
    }
  }

  @override
  Future<ProductModel> getProductById(String id) async {
    try {
      final doc = await firestore
          .collection(AppConstants.collectionProducts)
          .doc(id)
          .get();

      if (!doc.exists) {
        throw NotFoundException('Produit introuvable');
      }

      return ProductModel.fromJson({...doc.data()!, 'id': doc.id});
    } catch (e) {
      if (e is NotFoundException) rethrow;
      throw ServerException('Erreur lors de la récupération du produit');
    }
  }

  @override
  Future<List<ProductModel>> searchProducts(String query) async {
    try {
      final snapshot = await firestore
          .collection(AppConstants.collectionProducts)
          .get();

      final products = snapshot.docs
          .map((doc) => ProductModel.fromJson({...doc.data(), 'id': doc.id}))
          .toList();

      return products
          .where(
            (product) =>
                product.name.toLowerCase().contains(query.toLowerCase()) ||
                product.description.toLowerCase().contains(query.toLowerCase()),
          )
          .toList();
    } catch (e) {
      throw ServerException('Erreur lors de la recherche');
    }
  }

  @override
  Future<List<CategoryModel>> getCategories() async {
    try {
      final snapshot = await firestore
          .collection(AppConstants.collectionCategories)
          .get();

      return snapshot.docs
          .map((doc) => CategoryModel.fromJson({...doc.data(), 'id': doc.id}))
          .toList();
    } catch (e) {
      throw ServerException('Erreur lors de la récupération des catégories');
    }
  }
}
