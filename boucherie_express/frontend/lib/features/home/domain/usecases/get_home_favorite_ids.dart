import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../repositories/home_repository.dart';

/// Cas d'utilisation : récupérer les IDs des produits favoris.
@lazySingleton
class GetHomeFavoriteIds {
  final HomeRepository repository;

  const GetHomeFavoriteIds(this.repository);

  Future<Either<Failure, Set<String>>> call() {
    return repository.getFavoriteIds();
  }
}
