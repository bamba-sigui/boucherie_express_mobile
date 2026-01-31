import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/cart.dart';
import 'package:boucherie_express/features/products/domain/entities/product.dart';

/// Cart repository interface
abstract class CartRepository {
  /// Get current cart
  Future<Either<Failure, Cart>> getCart();

  /// Add item to cart
  Future<Either<Failure, Cart>> addItem(
    Product product,
    int quantity,
    String preparationOption,
  );

  /// Update item quantity
  Future<Either<Failure, Cart>> updateItemQuantity(
    String productId,
    int quantity,
  );

  /// Remove item from cart
  Future<Either<Failure, Cart>> removeItem(String productId);

  /// Clear cart
  Future<Either<Failure, void>> clearCart();
}
