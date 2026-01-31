import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../domain/entities/category.dart';
import '../../domain/entities/product.dart';
import '../../domain/usecases/get_all_products.dart';
import '../../domain/usecases/get_categories.dart';

part 'product_event.dart';
part 'product_state.dart';

@injectable
class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final GetAllProducts getAllProducts;
  final GetCategories getCategories;

  ProductBloc(this.getAllProducts, this.getCategories)
    : super(ProductInitial()) {
    on<LoadProducts>(_onLoadProducts);
    on<LoadCategories>(_onLoadCategories);
    on<FilterByCategory>(_onFilterByCategory);
    on<SearchProducts>(_onSearchProducts);
  }

  List<Product> _allProducts = [];
  List<Category> _categories = [];

  Future<void> _onLoadProducts(
    LoadProducts event,
    Emitter<ProductState> emit,
  ) async {
    emit(ProductLoading());

    final result = await getAllProducts();

    result.fold((failure) => emit(ProductError(failure.message)), (products) {
      _allProducts = products;
      emit(ProductLoaded(products, _categories));
    });
  }

  Future<void> _onLoadCategories(
    LoadCategories event,
    Emitter<ProductState> emit,
  ) async {
    final result = await getCategories();

    result.fold((failure) => emit(ProductError(failure.message)), (categories) {
      _categories = categories;
      if (state is ProductLoaded) {
        emit(ProductLoaded(_allProducts, categories));
      }
    });
  }

  void _onFilterByCategory(FilterByCategory event, Emitter<ProductState> emit) {
    if (event.categoryId == null) {
      emit(ProductLoaded(_allProducts, _categories));
    } else {
      final filtered = _allProducts
          .where((product) => product.category == event.categoryId)
          .toList();
      emit(ProductLoaded(filtered, _categories, event.categoryId));
    }
  }

  void _onSearchProducts(SearchProducts event, Emitter<ProductState> emit) {
    if (event.query.isEmpty) {
      emit(ProductLoaded(_allProducts, _categories));
    } else {
      final filtered = _allProducts
          .where(
            (product) =>
                product.name.toLowerCase().contains(
                  event.query.toLowerCase(),
                ) ||
                product.description.toLowerCase().contains(
                  event.query.toLowerCase(),
                ),
          )
          .toList();
      emit(ProductLoaded(filtered, _categories));
    }
  }
}
