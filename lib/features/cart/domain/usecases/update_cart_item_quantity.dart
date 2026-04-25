import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/cart.dart';
import '../repositories/cart_repository.dart';

@lazySingleton
class UpdateCartItemQuantity
    implements UseCase<Cart, UpdateCartItemQuantityParams> {
  final CartRepository repository;

  UpdateCartItemQuantity(this.repository);

  @override
  Future<Either<Failure, Cart>> call(UpdateCartItemQuantityParams params) {
    return repository.updateItemQuantity(params.productId, params.quantity);
  }
}

class UpdateCartItemQuantityParams extends Equatable {
  final String productId;
  final int quantity;

  const UpdateCartItemQuantityParams({
    required this.productId,
    required this.quantity,
  });

  @override
  List<Object?> get props => [productId, quantity];
}
