import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../domain/entities/cart.dart';
import '../../domain/usecases/add_to_cart.dart';
import '../../domain/usecases/clear_cart.dart' as uc_clear;
import '../../domain/usecases/get_cart.dart';
import '../../domain/usecases/remove_from_cart.dart';
import '../../domain/usecases/update_cart_item_quantity.dart' as uc;
import '../../../shared/domain/entities/product.dart';

part 'cart_event.dart';
part 'cart_state.dart';

@injectable
class CartBloc extends Bloc<CartEvent, CartState> {
  final GetCart getCart;
  final AddToCart addToCart;
  final RemoveFromCart removeFromCart;
  final uc.UpdateCartItemQuantity updateCartItemQuantity;
  final uc_clear.ClearCart clearCartUseCase;

  CartBloc(
    this.getCart,
    this.addToCart,
    this.removeFromCart,
    this.updateCartItemQuantity,
    this.clearCartUseCase,
  ) : super(CartInitial()) {
    on<LoadCart>(_onLoadCart);
    on<AddProductToCart>(_onAddProductToCart);
    on<RemoveProductFromCart>(_onRemoveProductFromCart);
    on<UpdateCartItemQuantity>(_onUpdateCartItemQuantity);
    on<ClearCart>(_onClearCart);
  }

  Future<void> _onLoadCart(LoadCart event, Emitter<CartState> emit) async {
    emit(CartLoading());

    final result = await getCart();

    result.fold(
      (failure) => emit(CartError(failure.message)),
      (cart) => emit(CartLoaded(cart)),
    );
  }

  Future<void> _onAddProductToCart(
    AddProductToCart event,
    Emitter<CartState> emit,
  ) async {
    final result = await addToCart(
      AddToCartParams(
        product: event.product,
        quantity: event.quantity,
        preparationOption: event.preparationOption,
      ),
    );

    result.fold(
      (failure) => emit(CartError(failure.message)),
      (cart) => emit(CartLoaded(cart)),
    );
  }

  Future<void> _onRemoveProductFromCart(
    RemoveProductFromCart event,
    Emitter<CartState> emit,
  ) async {
    final result = await removeFromCart(event.productId);

    result.fold(
      (failure) => emit(CartError(failure.message)),
      (cart) => emit(CartLoaded(cart)),
    );
  }

  Future<void> _onUpdateCartItemQuantity(
    UpdateCartItemQuantity event,
    Emitter<CartState> emit,
  ) async {
    final result = await updateCartItemQuantity(
      uc.UpdateCartItemQuantityParams(
        productId: event.productId,
        quantity: event.quantity,
      ),
    );

    result.fold(
      (failure) => emit(CartError(failure.message)),
      (cart) => emit(CartLoaded(cart)),
    );
  }

  Future<void> _onClearCart(ClearCart event, Emitter<CartState> emit) async {
    emit(CartLoading());
    final result = await clearCartUseCase();
    result.fold(
      (failure) => emit(CartError(failure.message)),
      (_) => emit(CartLoaded(const Cart())),
    );
  }
}
