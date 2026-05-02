import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/cart_repository.dart';

@lazySingleton
class ClearCart implements UseCaseNoParams<void> {
  final CartRepository repository;

  ClearCart(this.repository);

  @override
  Future<Either<Failure, void>> call() {
    return repository.clearCart();
  }
}
