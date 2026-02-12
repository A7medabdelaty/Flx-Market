import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flx_market/Core/error_handling/failure.dart';
import 'package:flx_market/Services/home/domain/entities/home_entities.dart';
import 'package:flx_market/Services/products/domain/repositories/products_repository.dart';

// Events
abstract class VendorProductsEvent {}

class LoadVendorProductsEvent extends VendorProductsEvent {
  final String ownerId;
  LoadVendorProductsEvent(this.ownerId);
}

// States
abstract class VendorProductsState {}

class VendorProductsInitial extends VendorProductsState {}

class VendorProductsLoading extends VendorProductsState {}

class VendorProductsLoaded extends VendorProductsState {
  final List<Product> products;
  VendorProductsLoaded(this.products);
}

class VendorProductsError extends VendorProductsState {
  final String message;
  VendorProductsError(this.message);
}

// Bloc
class VendorProductsBloc extends Bloc<VendorProductsEvent, VendorProductsState> {
  final ProductsRepository _repository;

  VendorProductsBloc(this._repository) : super(VendorProductsInitial()) {
    on<LoadVendorProductsEvent>(_onLoadVendorProducts);
  }

  Future<void> _onLoadVendorProducts(
    LoadVendorProductsEvent event,
    Emitter<VendorProductsState> emit,
  ) async {
    emit(VendorProductsLoading());
    final result = await _repository.getProductsByOwner(event.ownerId);
    result.fold(
      (failure) => emit(VendorProductsError(failure.message)),
      (products) => emit(VendorProductsLoaded(products)),
    );
  }
}
