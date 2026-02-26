import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../shared/domain/entities/product.dart';
import '../entities/home_category.dart';

/// Contrat du repository pour la feature Home.
abstract class HomeRepository {
  /// Récupère la liste des produits, optionnellement filtrés par catégorie.
  Future<Either<Failure, List<Product>>> getProducts({String? categoryId});

  /// Récupère la liste des catégories disponibles.
  Future<Either<Failure, List<HomeCategory>>> getCategories();

  /// Active/désactive le favori d'un produit.
  Future<Either<Failure, void>> toggleFavorite(String productId);

  /// Recherche de produits par mot-clé.
  Future<Either<Failure, List<Product>>> searchProducts(String query);

  /// Récupère les IDs des produits favoris actuels.
  Future<Either<Failure, Set<String>>> getFavoriteIds();
}
