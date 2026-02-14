part of 'filter_bloc.dart';

/// États du FilterBloc.
sealed class FilterState extends Equatable {
  const FilterState();

  @override
  List<Object?> get props => [];
}

/// État initial : aucun filtre appliqué.
final class FilterInitial extends FilterState {
  const FilterInitial();
}

/// Filtre en cours d'édition (pas encore appliqué).
///
/// Contient l'état courant du formulaire de filtre dans le bottom sheet.
final class FilterEditing extends FilterState {
  final ProductFilter currentFilter;

  const FilterEditing({required this.currentFilter});

  @override
  List<Object?> get props => [currentFilter];
}

/// Filtre appliqué avec succès — contient les produits filtrés.
final class FilterApplied extends FilterState {
  final ProductFilter appliedFilter;
  final List<Product> filteredProducts;

  const FilterApplied({
    required this.appliedFilter,
    required this.filteredProducts,
  });

  @override
  List<Object?> get props => [appliedFilter, filteredProducts];
}

/// Filtre réinitialisé — contient tous les produits.
final class FilterReset extends FilterState {
  final List<Product> allProducts;

  const FilterReset({required this.allProducts});

  @override
  List<Object?> get props => [allProducts];
}

/// Erreur lors de l'application du filtre.
final class FilterError extends FilterState {
  final String message;
  const FilterError(this.message);

  @override
  List<Object?> get props => [message];
}
