part of 'checkout_bloc.dart';

abstract class CheckoutEvent extends Equatable {
  const CheckoutEvent();

  @override
  List<Object?> get props => [];
}

/// Charge le checkout avec le panier courant.
class LoadCheckout extends CheckoutEvent {
  final Cart cart;

  const LoadCheckout({required this.cart});

  @override
  List<Object?> get props => [cart];
}

/// Sélectionne une méthode de paiement.
class SelectPaymentMethod extends CheckoutEvent {
  final PaymentMethod method;

  const SelectPaymentMethod(this.method);

  @override
  List<Object?> get props => [method];
}

/// Soumet la commande.
class SubmitOrder extends CheckoutEvent {}
