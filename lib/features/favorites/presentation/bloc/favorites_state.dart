part of 'favorites_bloc.dart';

/// États du FavoritesBloc.
sealed class FavoritesState extends Equatable {
  const FavoritesState();

  @override
  List<Object?> get props => [];
}

/// État initial.
final class FavoritesInitial extends FavoritesState {
  const FavoritesInitial();
}

/// Chargement en cours.
final class FavoritesLoading extends FavoritesState {
  const FavoritesLoading();
}

/// Favoris chargés avec succès.
final class FavoritesLoaded extends FavoritesState {
  final List<Product> favorites;

  const FavoritesLoaded({required this.favorites});

  @override
  List<Object?> get props => [favorites];
}

/// Erreur lors du chargement.
final class FavoritesError extends FavoritesState {
  final String message;

  const FavoritesError(this.message);

  @override
  List<Object?> get props => [message];
}
