import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../products/domain/entities/product.dart';
import '../repositories/favorites_repository.dart';

@injectable
class ToggleFavorite implements UseCase<void, Product> {
  final FavoritesRepository repository;

  ToggleFavorite(this.repository);

  @override
  Future<Either<Failure, void>> call(Product product) async {
    return await repository.toggleFavorite(product);
  }
}
