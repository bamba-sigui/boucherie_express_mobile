import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../repositories/home_repository.dart';

/// Cas d'utilisation : basculer l'état favori d'un produit.
@lazySingleton
class ToggleProductFavorite {
  final HomeRepository repository;

  const ToggleProductFavorite(this.repository);

  Future<Either<Failure, void>> call(String productId) {
    return repository.toggleFavorite(productId);
  }
}
