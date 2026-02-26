import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../shared/domain/entities/product.dart';
import '../../domain/entities/home_category.dart';
import '../../domain/usecases/get_home_categories.dart';
import '../../domain/usecases/get_home_favorite_ids.dart';
import '../../domain/usecases/get_home_products.dart';
import '../../domain/usecases/search_home_products.dart';
import '../../domain/usecases/toggle_product_favorite.dart';

part 'home_event.dart';
part 'home_state.dart';

/// BLoC principal de l'écran d'accueil.
///
/// Gère le chargement des produits, le filtrage par catégorie,
/// la recherche et les favoris.
@injectable
class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final GetHomeProducts _getHomeProducts;
  final GetHomeCategories _getHomeCategories;
  final ToggleProductFavorite _toggleProductFavorite;
  final SearchHomeProducts _searchHomeProducts;
  final GetHomeFavoriteIds _getHomeFavoriteIds;

  HomeBloc(
    this._getHomeProducts,
    this._getHomeCategories,
    this._toggleProductFavorite,
    this._searchHomeProducts,
    this._getHomeFavoriteIds,
  ) : super(const HomeInitial()) {
    on<HomeLoadRequested>(_onLoadRequested);
    on<HomeCategorySelected>(_onCategorySelected);
    on<HomeFavoriteToggled>(_onFavoriteToggled);
    on<HomeSearchRequested>(_onSearchRequested);
    on<HomeSearchCleared>(_onSearchCleared);
    on<HomeFavoritesRefreshRequested>(_onFavoritesRefreshRequested);
    on<HomeFilterApplied>(_onFilterApplied);
    on<HomeFilterReset>(_onFilterReset);
  }

  Future<void> _onLoadRequested(
    HomeLoadRequested event,
    Emitter<HomeState> emit,
  ) async {
    emit(const HomeLoading());

    final categoriesResult = await _getHomeCategories();
    final productsResult = await _getHomeProducts();
    final favResult = await _getHomeFavoriteIds();

    // Récupérer les favoris (set vide en cas d'erreur).
    final favoriteIds = favResult.fold((_) => <String>{}, (ids) => ids);

    categoriesResult.fold((failure) => emit(HomeError(failure.message)), (
      categories,
    ) {
      productsResult.fold(
        (failure) => emit(HomeError(failure.message)),
        (products) => emit(
          HomeLoaded(
            products: products,
            categories: categories,
            favoriteIds: favoriteIds,
          ),
        ),
      );
    });
  }

  Future<void> _onCategorySelected(
    HomeCategorySelected event,
    Emitter<HomeState> emit,
  ) async {
    final currentState = state;
    if (currentState is! HomeLoaded) return;

    emit(
      currentState.copyWith(
        selectedCategoryId: () => event.categoryId,
        isSearching: false,
        searchQuery: '',
      ),
    );

    final result = await _getHomeProducts(categoryId: event.categoryId);
    result.fold((failure) => emit(HomeError(failure.message)), (products) {
      final updatedState = state;
      if (updatedState is HomeLoaded) {
        emit(updatedState.copyWith(products: products));
      }
    });
  }

  Future<void> _onFavoriteToggled(
    HomeFavoriteToggled event,
    Emitter<HomeState> emit,
  ) async {
    final currentState = state;
    if (currentState is! HomeLoaded) return;

    final updatedFavorites = Set<String>.from(currentState.favoriteIds);
    if (updatedFavorites.contains(event.productId)) {
      updatedFavorites.remove(event.productId);
    } else {
      updatedFavorites.add(event.productId);
    }

    emit(currentState.copyWith(favoriteIds: updatedFavorites));
    await _toggleProductFavorite(event.productId);
  }

  Future<void> _onSearchRequested(
    HomeSearchRequested event,
    Emitter<HomeState> emit,
  ) async {
    final currentState = state;
    if (currentState is! HomeLoaded) return;

    if (event.query.isEmpty) {
      add(const HomeSearchCleared());
      return;
    }

    emit(currentState.copyWith(isSearching: true, searchQuery: event.query));

    final result = await _searchHomeProducts(event.query);
    result.fold((failure) => emit(HomeError(failure.message)), (products) {
      final updatedState = state;
      if (updatedState is HomeLoaded) {
        emit(updatedState.copyWith(products: products));
      }
    });
  }

  Future<void> _onSearchCleared(
    HomeSearchCleared event,
    Emitter<HomeState> emit,
  ) async {
    final currentState = state;
    if (currentState is! HomeLoaded) return;

    emit(currentState.copyWith(isSearching: false, searchQuery: ''));

    final result = await _getHomeProducts(
      categoryId: currentState.selectedCategoryId,
    );
    result.fold((failure) => emit(HomeError(failure.message)), (products) {
      final updatedState = state;
      if (updatedState is HomeLoaded) {
        emit(updatedState.copyWith(products: products));
      }
    });
  }

  /// Remplace la liste de produits par les résultats filtrés.
  void _onFilterApplied(HomeFilterApplied event, Emitter<HomeState> emit) {
    final currentState = state;
    if (currentState is! HomeLoaded) return;

    emit(
      currentState.copyWith(
        products: event.filteredProducts,
        selectedCategoryId: () => null,
        isSearching: false,
        searchQuery: '',
      ),
    );
  }

  /// Recharge tous les produits après un reset de filtre.
  Future<void> _onFilterReset(
    HomeFilterReset event,
    Emitter<HomeState> emit,
  ) async {
    final currentState = state;
    if (currentState is! HomeLoaded) return;

    final result = await _getHomeProducts();
    result.fold((failure) => emit(HomeError(failure.message)), (products) {
      final updatedState = state;
      if (updatedState is HomeLoaded) {
        emit(
          updatedState.copyWith(
            products: products,
            selectedCategoryId: () => null,
            isSearching: false,
            searchQuery: '',
          ),
        );
      }
    });
  }

  /// Synchronise les favoris depuis la source de données.
  /// Appelé quand on revient sur l'onglet Home après un changement
  /// dans l'onglet Favoris.
  Future<void> _onFavoritesRefreshRequested(
    HomeFavoritesRefreshRequested event,
    Emitter<HomeState> emit,
  ) async {
    final currentState = state;
    if (currentState is! HomeLoaded) return;

    final result = await _getHomeFavoriteIds();
    result.fold(
      (_) {}, // silently ignore errors
      (favoriteIds) {
        final updatedState = state;
        if (updatedState is HomeLoaded) {
          emit(updatedState.copyWith(favoriteIds: favoriteIds));
        }
      },
    );
  }
}
