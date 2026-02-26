import 'package:injectable/injectable.dart';
import '../../../home/data/datasources/home_local_datasource.dart';
import '../../../shared/domain/entities/product.dart';

/// Source de données locale pour les favoris.
///
/// Délègue à [HomeLocalDataSource] pour garantir une source de vérité unique
/// partagée avec la feature Home. Prête à être remplacée par une API REST.
abstract class FavoritesLocalDataSource {
  /// Récupère tous les produits marqués comme favoris.
  Future<List<Product>> getFavorites();

  /// Retire un produit des favoris.
  Future<void> removeFavorite(String productId);
}

@LazySingleton(as: FavoritesLocalDataSource)
class FavoritesLocalDataSourceImpl implements FavoritesLocalDataSource {
  final HomeLocalDataSource _homeDataSource;

  FavoritesLocalDataSourceImpl(this._homeDataSource);

  @override
  Future<List<Product>> getFavorites() async {
    return _homeDataSource.getFavoriteProducts();
  }

  @override
  Future<void> removeFavorite(String productId) async {
    await _homeDataSource.toggleFavorite(productId);
  }
}
