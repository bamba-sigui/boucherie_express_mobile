import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../shared/domain/entities/product.dart';
import '../repositories/product_repository.dart';

@lazySingleton
class GetAllProducts implements UseCaseNoParams<List<Product>> {
  final ProductRepository repository;

  GetAllProducts(this.repository);

  @override
  Future<Either<Failure, List<Product>>> call() {
    return repository.getAllProducts();
  }
}
