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

/// Cart entity — toute la logique métier de calcul est ici.
class Cart extends Equatable {
  final List<CartItem> items;

  /// Seuil de livraison gratuite (FCFA).
  static const double freeDeliveryThreshold = 30000.0;

  /// Frais de livraison standard (FCFA).
  static const double standardDeliveryFee = 2000.0;

  const Cart({this.items = const []});

  // ── Calculs métier ────────────────────────────────────────────────────

  /// Somme des prix × quantités.
  double get subtotal => items.fold(0.0, (sum, item) => sum + item.totalPrice);

  /// Alias pour compatibilité ascendante.
  double get totalPrice => subtotal;

  /// Frais de livraison dynamiques : 0 si le seuil est atteint.
  double get deliveryFee =>
      subtotal >= freeDeliveryThreshold ? 0.0 : standardDeliveryFee;

  /// Montant total (sous-total + livraison).
  double get totalAmount => subtotal + deliveryFee;

  /// Nombre total d'articles (somme des quantités).
  int get totalItems => items.fold(0, (sum, item) => sum + item.quantity);

  bool get isEmpty => items.isEmpty;

  /// Progression vers la livraison gratuite (0.0 → 1.0, clampée).
  double get freeDeliveryProgress =>
      (subtotal / freeDeliveryThreshold).clamp(0.0, 1.0);

  /// `true` si la livraison gratuite est atteinte.
  bool get hasFreeDelivery => subtotal >= freeDeliveryThreshold;

  /// Montant restant pour atteindre la livraison gratuite.
  double get remainingForFreeDelivery =>
      hasFreeDelivery ? 0.0 : freeDeliveryThreshold - subtotal;

  Cart copyWith({List<CartItem>? items}) {
    return Cart(items: items ?? this.items);
  }

  @override
  List<Object?> get props => [items];
}
