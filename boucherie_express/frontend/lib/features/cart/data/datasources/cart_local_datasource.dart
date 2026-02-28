import 'package:hive_flutter/hive_flutter.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/exceptions.dart';
import '../../domain/entities/cart.dart';
import '../../../shared/domain/entities/product.dart';
import '../models/cart_item_model.dart';

/// Local data source for cart
abstract class CartLocalDataSource {
  Future<Cart> getCart();
  Future<Cart> addItem(Product product, int quantity, String preparationOption);
  Future<Cart> updateItemQuantity(String productId, int quantity);
  Future<Cart> removeItem(String productId);
  Future<void> clearCart();
}

@LazySingleton(as: CartLocalDataSource)
class CartLocalDataSourceImpl implements CartLocalDataSource {
  static const String _boxName = 'cart';

  Future<Box<CartItemModel>> get _box async {
    if (!Hive.isBoxOpen(_boxName)) {
      return await Hive.openBox<CartItemModel>(_boxName);
    }
    return Hive.box<CartItemModel>(_boxName);
  }

  @override
  Future<Cart> getCart() async {
    try {
      final box = await _box;
      final items = box.values.map((model) => model.toEntity()).toList();
      return Cart(items: items);
    } catch (e) {
      throw CacheException('Erreur lors de la récupération du panier');
    }
  }

  @override
  Future<Cart> addItem(
    Product product,
    int quantity,
    String preparationOption,
  ) async {
    try {
      final box = await _box;

      // Check if item already exists
      final existingIndex = box.values.toList().indexWhere(
        (item) => item.productJson['id'] == product.id,
      );

      if (existingIndex != -1) {
        // Update quantity
        final existing = box.getAt(existingIndex)!;
        final updated = CartItemModel(
          productJson: existing.productJson,
          quantity: existing.quantity + quantity,
          preparationOption: preparationOption,
        );
        await box.putAt(existingIndex, updated);
      } else {
        // Add new item
        final item = CartItem(
          product: product,
          quantity: quantity,
          preparationOption: preparationOption,
        );
        await box.add(CartItemModel.fromEntity(item));
      }

      return getCart();
    } catch (e) {
      throw CacheException('Erreur lors de l\'ajout au panier');
    }
  }

  @override
  Future<Cart> updateItemQuantity(String productId, int quantity) async {
    try {
      final box = await _box;
      final index = box.values.toList().indexWhere(
        (item) => item.productJson['id'] == productId,
      );

      if (index == -1) {
        throw CacheException('Produit introuvable dans le panier');
      }

      if (quantity <= 0) {
        await box.deleteAt(index);
      } else {
        final existing = box.getAt(index)!;
        final updated = CartItemModel(
          productJson: existing.productJson,
          quantity: quantity,
          preparationOption: existing.preparationOption,
        );
        await box.putAt(index, updated);
      }

      return getCart();
    } catch (e) {
      throw CacheException('Erreur lors de la mise à jour du panier');
    }
  }

  @override
  Future<Cart> removeItem(String productId) async {
    try {
      final box = await _box;
      final index = box.values.toList().indexWhere(
        (item) => item.productJson['id'] == productId,
      );

      if (index != -1) {
        await box.deleteAt(index);
      }

      return getCart();
    } catch (e) {
      throw CacheException('Erreur lors de la suppression du produit');
    }
  }

  @override
  Future<void> clearCart() async {
    try {
      final box = await _box;
      await box.clear();
    } catch (e) {
      throw CacheException('Erreur lors du vidage du panier');
    }
  }
}
