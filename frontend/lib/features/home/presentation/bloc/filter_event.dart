part of 'filter_bloc.dart';

/// Événements du FilterBloc.
sealed class FilterEvent extends Equatable {
  const FilterEvent();

  @override
  List<Object?> get props => [];
}

/// Modifier la catégorie sélectionnée dans le filtre.
final class FilterCategoryChanged extends FilterEvent {
  final String? category;
  const FilterCategoryChanged(this.category);

  @override
  List<Object?> get props => [category];
}

/// Modifier le range de prix.
final class FilterPriceRangeChanged extends FilterEvent {
  final double minPrice;
  final double maxPrice;

  const FilterPriceRangeChanged({
    required this.minPrice,
    required this.maxPrice,
  });

  @override
  List<Object?> get props => [minPrice, maxPrice];
}

/// Modifier le toggle disponibilité (en stock).
final class FilterInStockToggled extends FilterEvent {
  final bool inStock;
  const FilterInStockToggled(this.inStock);

  @override
  List<Object?> get props => [inStock];
}

/// Appliquer les filtres actuels et récupérer les produits filtrés.
final class FilterApplyRequested extends FilterEvent {
  const FilterApplyRequested();
}

/// Réinitialiser tous les filtres aux valeurs par défaut.
final class FilterResetRequested extends FilterEvent {
  const FilterResetRequested();
}
