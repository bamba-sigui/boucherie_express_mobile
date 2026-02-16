import 'package:equatable/equatable.dart';

import '../../../cart/domain/entities/cart.dart';
import 'delivery_address.dart';
import 'payment_method.dart';

/// Agrégat de commande en cours de finalisation.
///
/// Contient le panier, l'adresse de livraison et la méthode de paiement
/// sélectionnée. Toute la logique de validation métier est ici.
class Checkout extends Equatable {
  final Cart cart;
  final DeliveryAddress? deliveryAddress;
  final PaymentMethod? selectedPaymentMethod;

  const Checkout({
    required this.cart,
    this.deliveryAddress,
    this.selectedPaymentMethod,
  });

  // ── Business rules ────────────────────────────────────────────────────

  /// Le panier doit contenir au moins un article.
  bool get hasItems => !cart.isEmpty;

  /// Une adresse valide est renseignée.
  bool get hasValidAddress =>
      deliveryAddress != null && deliveryAddress!.isValid;

  /// Un mode de paiement est sélectionné.
  bool get hasPaymentMethod => selectedPaymentMethod != null;

  /// Toutes les conditions pour passer commande sont remplies.
  bool get canPlaceOrder => hasItems && hasValidAddress && hasPaymentMethod;

  /// Nombre total d'articles (somme des quantités).
  int get totalItems => cart.totalItems;

  /// Sous-total du panier.
  double get subtotal => cart.subtotal;

  /// Frais de livraison.
  double get deliveryFee => cart.deliveryFee;

  /// Montant total à payer.
  double get totalAmount => cart.totalAmount;

  /// Valide la sélection du paiement et retourne le checkout mis à jour.
  Checkout selectPayment(PaymentMethod method) {
    return Checkout(
      cart: cart,
      deliveryAddress: deliveryAddress,
      selectedPaymentMethod: method,
    );
  }

  Checkout copyWith({
    Cart? cart,
    DeliveryAddress? deliveryAddress,
    PaymentMethod? selectedPaymentMethod,
  }) {
    return Checkout(
      cart: cart ?? this.cart,
      deliveryAddress: deliveryAddress ?? this.deliveryAddress,
      selectedPaymentMethod:
          selectedPaymentMethod ?? this.selectedPaymentMethod,
    );
  }

  @override
  List<Object?> get props => [cart, deliveryAddress, selectedPaymentMethod];
}
