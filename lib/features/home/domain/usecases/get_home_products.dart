import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../../../products/domain/entities/product.dart';
import '../repositories/home_repository.dart';

/// Cas d'utilisation : récupérer les produits (avec filtre catégorie optionnel).
@lazySingleton
class GetHomeProducts {
  final HomeRepository repository;

  const GetHomeProducts(this.repository);

  Future<Either<Failure, List<Product>>> call({String? categoryId}) {
    return repository.getProducts(categoryId: categoryId);
  }
}
