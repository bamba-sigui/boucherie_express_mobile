import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../products/domain/entities/product.dart';
import '../../domain/entities/product_filter.dart';
import '../../domain/usecases/apply_filter.dart';
import '../../domain/usecases/reset_filter.dart';

part 'filter_event.dart';
part 'filter_state.dart';

/// BLoC pour la feature Filter.
///
/// Gère l'état du formulaire de filtre et l'application des filtres.
/// Séparé du HomeBloc — communique via les événements dans MainScreen.
@injectable
class FilterBloc extends Bloc<FilterEvent, FilterState> {
  final ApplyFilter _applyFilter;
  final ResetFilter _resetFilter;

  /// Le filtre en cours d'édition dans le bottom sheet.
  ProductFilter _pendingFilter = ProductFilter.defaultFilter;

  FilterBloc(this._applyFilter, this._resetFilter)
    : super(const FilterInitial()) {
    on<FilterCategoryChanged>(_onCategoryChanged);
    on<FilterPriceRangeChanged>(_onPriceRangeChanged);
    on<FilterInStockToggled>(_onInStockToggled);
    on<FilterApplyRequested>(_onApplyRequested);
    on<FilterResetRequested>(_onResetRequested);
  }

  /// Le filtre actuellement en cours d'édition.
  ProductFilter get pendingFilter => _pendingFilter;

  void _onCategoryChanged(
    FilterCategoryChanged event,
    Emitter<FilterState> emit,
  ) {
    // Toggle : si la même catégorie est re-sélectionnée, on la désélectionne.
    if (_pendingFilter.category == event.category) {
      _pendingFilter = _pendingFilter.copyWith(category: () => null);
    } else {
      _pendingFilter = _pendingFilter.copyWith(category: () => event.category);
    }
    emit(FilterEditing(currentFilter: _pendingFilter));
  }

  void _onPriceRangeChanged(
    FilterPriceRangeChanged event,
    Emitter<FilterState> emit,
  ) {
    _pendingFilter = _pendingFilter.copyWith(
      minPrice: event.minPrice,
      maxPrice: event.maxPrice,
    );
    emit(FilterEditing(currentFilter: _pendingFilter));
  }

  void _onInStockToggled(
    FilterInStockToggled event,
    Emitter<FilterState> emit,
  ) {
    _pendingFilter = _pendingFilter.copyWith(inStock: event.inStock);
    emit(FilterEditing(currentFilter: _pendingFilter));
  }

  Future<void> _onApplyRequested(
    FilterApplyRequested event,
    Emitter<FilterState> emit,
  ) async {
    final result = await _applyFilter(_pendingFilter);

    result.fold(
      (failure) => emit(FilterError(failure.message)),
      (products) => emit(
        FilterApplied(
          appliedFilter: _pendingFilter,
          filteredProducts: products,
        ),
      ),
    );
  }

  Future<void> _onResetRequested(
    FilterResetRequested event,
    Emitter<FilterState> emit,
  ) async {
    _pendingFilter = ProductFilter.defaultFilter;

    final result = await _resetFilter();

    result.fold(
      (failure) => emit(FilterError(failure.message)),
      (products) => emit(FilterReset(allProducts: products)),
    );
  }
}
