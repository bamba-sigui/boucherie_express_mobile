import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/cart.dart';
import '../repositories/cart_repository.dart';

@lazySingleton
class GetCart implements UseCaseNoParams<Cart> {
  final CartRepository repository;

  GetCart(this.repository);

  @override
  Future<Either<Failure, Cart>> call() {
    return repository.getCart();
  }
}
