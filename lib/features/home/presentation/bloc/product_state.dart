part of 'product_bloc.dart';

abstract class ProductState extends Equatable {
  const ProductState();

  @override
  List<Object?> get props => [];
}

class ProductInitial extends ProductState {}

class ProductLoading extends ProductState {}

class ProductLoaded extends ProductState {
  final List<Product> products;
  final List<Category> categories;
  final String? selectedCategoryId;

  const ProductLoaded(
    this.products,
    this.categories, [
    this.selectedCategoryId,
  ]);

  @override
  List<Object?> get props => [products, categories, selectedCategoryId];
}

class ProductError extends ProductState {
  final String message;

  const ProductError(this.message);

  @override
  List<Object?> get props => [message];
}
