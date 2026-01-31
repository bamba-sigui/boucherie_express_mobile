import 'package:equatable/equatable.dart';
import 'package:boucherie_express/features/products/domain/entities/product.dart';

/// Cart item entity
class CartItem extends Equatable {
  final Product product;
  final int quantity;
  final String preparationOption;

  const CartItem({
    required this.product,
    required this.quantity,
    required this.preparationOption,
  });

  String get productId => product.id;
  String get productName => product.name;
  double get price => product.price;
  double get totalPrice => product.price * quantity;

  CartItem copyWith({
    Product? product,
    int? quantity,
    String? preparationOption,
  }) {
    return CartItem(
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
      preparationOption: preparationOption ?? this.preparationOption,
    );
  }

  @override
  List<Object?> get props => [product.id, quantity, preparationOption];
}

/// Cart entity
class Cart extends Equatable {
  final List<CartItem> items;

  const Cart({this.items = const []});

  double get subtotal => items.fold(0.0, (sum, item) => sum + item.totalPrice);

  // Aliases and helpers for UI convenience
  double get totalPrice => subtotal;
  double get deliveryFee => 1000.0; // Fixed for MVP
  double get totalAmount => subtotal + deliveryFee;

  int get totalItems => items.fold(0, (sum, item) => sum + item.quantity);

  bool get isEmpty => items.isEmpty;

  Cart copyWith({List<CartItem>? items}) {
    return Cart(items: items ?? this.items);
  }

  @override
  List<Object?> get props => [items];
}
