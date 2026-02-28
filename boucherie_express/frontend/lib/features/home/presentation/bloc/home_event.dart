part of 'home_bloc.dart';

/// Événements du HomeBloc.
sealed class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object?> get props => [];
}

/// Charger les données initiales (catégories + produits).
final class HomeLoadRequested extends HomeEvent {
  const HomeLoadRequested();
}

/// Filtrer par catégorie sélectionnée (null = toutes).
final class HomeCategorySelected extends HomeEvent {
  final String? categoryId;
  const HomeCategorySelected(this.categoryId);

  @override
  List<Object?> get props => [categoryId];
}

/// Basculer le favori d'un produit.
final class HomeFavoriteToggled extends HomeEvent {
  final String productId;
  const HomeFavoriteToggled(this.productId);

  @override
  List<Object?> get props => [productId];
}

/// Rechercher des produits.
final class HomeSearchRequested extends HomeEvent {
  final String query;
  const HomeSearchRequested(this.query);

  @override
  List<Object?> get props => [query];
}

/// Effacer la recherche et revenir à la liste filtrée.
final class HomeSearchCleared extends HomeEvent {
  const HomeSearchCleared();
}

/// Rafraîchir les IDs favoris depuis la source de données.
/// Utilisé pour synchroniser après modification depuis l'onglet Favoris.
final class HomeFavoritesRefreshRequested extends HomeEvent {
  const HomeFavoritesRefreshRequested();
}

/// Appliquer les résultats d'un filtre externe (depuis FilterBloc).
final class HomeFilterApplied extends HomeEvent {
  final List<Product> filteredProducts;
  const HomeFilterApplied(this.filteredProducts);

  @override
  List<Object?> get props => [filteredProducts];
}

/// Réinitialiser les produits après un reset de filtre.
final class HomeFilterReset extends HomeEvent {
  const HomeFilterReset();
}
