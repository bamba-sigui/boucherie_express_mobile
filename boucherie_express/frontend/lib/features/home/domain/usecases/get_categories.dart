import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../shared/domain/entities/category.dart';
import '../repositories/product_repository.dart';

@lazySingleton
class GetCategories implements UseCaseNoParams<List<Category>> {
  final ProductRepository repository;

  GetCategories(this.repository);

  @override
  Future<Either<Failure, List<Category>>> call() {
    return repository.getCategories();
  }
}
