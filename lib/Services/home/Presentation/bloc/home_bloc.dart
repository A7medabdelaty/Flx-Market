import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/home_repository.dart';
import 'home_event.dart';
import 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final HomeRepository _homeRepository;

  HomeBloc({required HomeRepository homeRepository})
    : _homeRepository = homeRepository,
      super(HomeInitial()) {
    on<LoadHomeDataEvent>(_onLoadHomeData);
    on<SeedHomeDataEvent>(_onSeedHomeData);
  }

  Future<void> _onLoadHomeData(
    LoadHomeDataEvent event,
    Emitter<HomeState> emit,
  ) async {
    emit(HomeLoading());

    final categoriesResult = await _homeRepository.getCategories();
    final productsResult = await _homeRepository.getRecommendedProducts();

    categoriesResult.fold(
      (failure) => emit(HomeError(failure.message)),
      (categories) {
        productsResult.fold(
          (failure) => emit(HomeError(failure.message)),
          (products) {
            // If empty, try seeding and reloading
            if (categories.isEmpty && products.isEmpty) {
              add(SeedHomeDataEvent());
            } else {
              emit(
                HomeLoaded(
                  categories: categories,
                  recommendedProducts: products,
                ),
              );
            }
          },
        );
      },
    );
  }

  Future<void> _onSeedHomeData(
    SeedHomeDataEvent event,
    Emitter<HomeState> emit,
  ) async {
    // Only emit loading if not already loading? But logic flow here implies it comes from load data check
    // Ensure we don't loop infinitely if seeding fails, but for now simple retry
    final result = await _homeRepository.seedInitialData();
    result.fold(
      (failure) => emit(HomeError('Seeding failed: ${failure.message}')),
      (_) => add(LoadHomeDataEvent()),
    );
  }
}
