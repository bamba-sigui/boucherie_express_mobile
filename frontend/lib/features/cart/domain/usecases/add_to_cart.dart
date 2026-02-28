import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../shared/domain/entities/product.dart';
import '../entities/cart.dart';
import '../repositories/cart_repository.dart';

@lazySingleton
class AddToCart implements UseCase<Cart, AddToCartParams> {
  final CartRepository repository;

  AddToCart(this.repository);

  @override
  Future<Either<Failure, Cart>> call(AddToCartParams params) {
    return repository.addItem(
      params.product,
      params.quantity,
      params.preparationOption,
    );
  }
}

class AddToCartParams extends Equatable {
  final Product product;
  final int quantity;
  final String preparationOption;

  const AddToCartParams({
    required this.product,
    required this.quantity,
    required this.preparationOption,
  });

  @override
  List<Object?> get props => [product, quantity, preparationOption];
}
