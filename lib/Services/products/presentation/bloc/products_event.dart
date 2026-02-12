import 'package:equatable/equatable.dart';

abstract class ProductsEvent extends Equatable {
  const ProductsEvent();

  @override
  List<Object> get props => [];
}

class LoadProductsEvent extends ProductsEvent {}

class SearchProductsEvent extends ProductsEvent {
  final String query;

  const SearchProductsEvent(this.query);

  @override
  List<Object> get props => [query];
}

class FilterProductsByCategoryEvent extends ProductsEvent {
  final String category;

  const FilterProductsByCategoryEvent(this.category);

  @override
  List<Object> get props => [category];
}
