import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/wishlist_repository.dart';
import 'wishlist_event.dart';
import 'wishlist_state.dart';

class WishlistBloc extends Bloc<WishlistEvent, WishlistState> {
  final WishlistRepository _wishlistRepository;

  WishlistBloc({required WishlistRepository wishlistRepository})
      : _wishlistRepository = wishlistRepository,
        super(WishlistInitial()) {
    on<LoadWishlistEvent>(_onLoadWishlist);
    on<ToggleWishlistEvent>(_onToggleWishlist);
  }

  Future<void> _onLoadWishlist(
    LoadWishlistEvent event,
    Emitter<WishlistState> emit,
  ) async {
    if (state is! WishlistLoaded) {
      emit(WishlistLoading());
    }
    final result = await _wishlistRepository.getWishlist();
    result.fold(
      (failure) => emit(WishlistError(failure.message)),
      (products) => emit(WishlistLoaded(products)),
    );
  }

  Future<void> _onToggleWishlist(
    ToggleWishlistEvent event,
    Emitter<WishlistState> emit,
  ) async {
    // Keep current state to fallback or strict loading? 
    // We don't want to emit loading for a toggle necessarily if we are in a list, 
    // but here we are managing the Wishlist Page state mostly.
    
    // Check if item is currently in wishlist (repo check)
    final isFavorite = await _wishlistRepository.isFavorite(event.product.id);
      
    if (isFavorite) {
        final result = await _wishlistRepository.removeFromWishlist(event.product.id);
        result.fold(
            (l) => emit(WishlistError(l.message)), // Or Show Snackbar via Listener
            (r) => add(LoadWishlistEvent()),
        );
    } else {
        final result = await _wishlistRepository.addToWishlist(event.product);
        result.fold(
            (l) => emit(WishlistError(l.message)),
            (r) => add(LoadWishlistEvent()),
        );
    }
  }
}
