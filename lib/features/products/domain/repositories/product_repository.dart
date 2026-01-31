import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/category.dart';
import '../entities/product.dart';

/// Product repository interface
abstract class ProductRepository {
  /// Get all products
  Future<Either<Failure, List<Product>>> getAllProducts();

  /// Get products by category
  Future<Either<Failure, List<Product>>> getProductsByCategory(
    String categoryId,
  );

  /// Get product by ID
  Future<Either<Failure, Product>> getProductById(String id);

  /// Search products
  Future<Either<Failure, List<Product>>> searchProducts(String query);

  /// Get all categories
  Future<Either<Failure, List<Category>>> getCategories();
}
