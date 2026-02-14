import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../entities/home_category.dart';
import '../repositories/home_repository.dart';

/// Cas d'utilisation : récupérer les catégories pour l'écran d'accueil.
@lazySingleton
class GetHomeCategories {
  final HomeRepository repository;

  const GetHomeCategories(this.repository);

  Future<Either<Failure, List<HomeCategory>>> call() {
    return repository.getCategories();
  }
}
