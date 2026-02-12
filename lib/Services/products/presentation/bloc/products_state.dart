import 'package:equatable/equatable.dart';
import 'package:flx_market/Services/home/domain/entities/home_entities.dart';

abstract class ProductsState extends Equatable {
  const ProductsState();

  @override
  List<Object> get props => [];
}

class ProductsInitial extends ProductsState {}

class ProductsLoading extends ProductsState {}

class ProductsLoaded extends ProductsState {
  final List<Product> products;
  final bool isSearching;

  const ProductsLoaded({required this.products, this.isSearching = false});

  @override
  List<Object> get props => [products, isSearching];
}

class ProductsError extends ProductsState {
  final String message;

  const ProductsError(this.message);

  @override
  List<Object> get props => [message];
}
