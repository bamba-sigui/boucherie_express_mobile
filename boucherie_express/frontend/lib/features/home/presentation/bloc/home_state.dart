part of 'home_bloc.dart';

/// États du HomeBloc.
sealed class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object?> get props => [];
}

/// État initial
final class HomeInitial extends HomeState {
  const HomeInitial();
}

/// Chargement en cours
final class HomeLoading extends HomeState {
  const HomeLoading();
}

/// Données chargées avec succès
final class HomeLoaded extends HomeState {
  final List<Product> products;
  final List<HomeCategory> categories;
  final String? selectedCategoryId;
  final Set<String> favoriteIds;
  final String searchQuery;
  final bool isSearching;

  const HomeLoaded({
    required this.products,
    required this.categories,
    this.selectedCategoryId,
    this.favoriteIds = const {},
    this.searchQuery = '',
    this.isSearching = false,
  });

  HomeLoaded copyWith({
    List<Product>? products,
    List<HomeCategory>? categories,
    String? Function()? selectedCategoryId,
    Set<String>? favoriteIds,
    String? searchQuery,
    bool? isSearching,
  }) {
    return HomeLoaded(
      products: products ?? this.products,
      categories: categories ?? this.categories,
      selectedCategoryId: selectedCategoryId != null
          ? selectedCategoryId()
          : this.selectedCategoryId,
      favoriteIds: favoriteIds ?? this.favoriteIds,
      searchQuery: searchQuery ?? this.searchQuery,
      isSearching: isSearching ?? this.isSearching,
    );
  }

  @override
  List<Object?> get props => [
    products,
    categories,
    selectedCategoryId,
    favoriteIds,
    searchQuery,
    isSearching,
  ];
}

/// Erreur
final class HomeError extends HomeState {
  final String message;
  const HomeError(this.message);

  @override
  List<Object?> get props => [message];
}
