import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';

import '../../domain/repositories/products_repository.dart';
import 'products_event.dart';
import 'products_state.dart';

class ProductsBloc extends Bloc<ProductsEvent, ProductsState> {
  final ProductsRepository _productsRepository;

  ProductsBloc({required ProductsRepository productsRepository})
    : _productsRepository = productsRepository,
      super(ProductsInitial()) {
    on<LoadProductsEvent>(_onLoadProducts);
    on<SearchProductsEvent>(
      _onSearchProducts,
      transformer: (events, mapper) {
        return events
            .debounceTime(Duration(milliseconds: 300))
            .switchMap(mapper);
      },
    );
    on<FilterProductsByCategoryEvent>(_onFilterByCategory);
  }

  Future<void> _onLoadProducts(
    LoadProductsEvent event,
    Emitter<ProductsState> emit,
  ) async {
    emit(ProductsLoading());
    final result = await _productsRepository.getAllProducts();
    result.fold(
      (failure) => emit(ProductsError(failure.message)),
      (products) => emit(ProductsLoaded(products: products)),
    );
  }

  Future<void> _onSearchProducts(
    SearchProductsEvent event,
    Emitter<ProductsState> emit,
  ) async {
    if (event.query.isEmpty) {
      add(LoadProductsEvent());
      return;
    }

    emit(ProductsLoading());
    final result = await _productsRepository.searchProducts(event.query);
    result.fold(
      (failure) => emit(ProductsError(failure.message)),
      (products) => emit(ProductsLoaded(products: products, isSearching: true)),
    );
  }

  Future<void> _onFilterByCategory(
    FilterProductsByCategoryEvent event,
    Emitter<ProductsState> emit,
  ) async {
    emit(ProductsLoading());
    final result = await _productsRepository.getProductsByCategory(event.category);
    result.fold(
      (failure) => emit(ProductsError(failure.message)),
      (products) => emit(ProductsLoaded(products: products, isSearching: true)),
    );
  }
}
