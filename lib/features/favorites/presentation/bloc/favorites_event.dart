part of 'favorites_bloc.dart';

/// Événements du FavoritesBloc.
sealed class FavoritesEvent extends Equatable {
  const FavoritesEvent();

  @override
  List<Object?> get props => [];
}

/// Demande de chargement des favoris.
final class FavoritesLoadRequested extends FavoritesEvent {
  const FavoritesLoadRequested();
}

/// Demande de suppression d'un favori.
final class FavoritesRemoveRequested extends FavoritesEvent {
  final String productId;
  const FavoritesRemoveRequested(this.productId);

  @override
  List<Object?> get props => [productId];
}

/// Toggle favori (ajouter/retirer) depuis les écrans produits.
/// Compatible avec l'ancienne API pour product_card et product_details_screen.
final class FavoritesToggleRequested extends FavoritesEvent {
  final Product product;
  const FavoritesToggleRequested(this.product);

  @override
  List<Object?> get props => [product];
}
