import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../../../products/domain/entities/product.dart';
import '../repositories/favorites_repository.dart';

/// Use case : récupérer la liste des produits favoris.
@injectable
class GetFavorites {
  final FavoritesRepository repository;

  GetFavorites(this.repository);

  Future<Either<Failure, List<Product>>> call() async {
    return await repository.getFavorites();
  }
}
