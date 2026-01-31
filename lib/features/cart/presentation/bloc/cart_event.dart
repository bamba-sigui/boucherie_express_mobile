part of 'cart_bloc.dart';

abstract class CartEvent extends Equatable {
  const CartEvent();

  @override
  List<Object?> get props => [];
}

class LoadCart extends CartEvent {}

class AddProductToCart extends CartEvent {
  final Product product;
  final int quantity;
  final String preparationOption;

  const AddProductToCart({
    required this.product,
    required this.quantity,
    required this.preparationOption,
  });

  @override
  List<Object?> get props => [product, quantity, preparationOption];
}

class RemoveProductFromCart extends CartEvent {
  final String productId;

  const RemoveProductFromCart(this.productId);

  @override
  List<Object?> get props => [productId];
}

class ClearCart extends CartEvent {}
