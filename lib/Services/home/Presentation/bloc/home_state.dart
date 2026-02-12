import '../../domain/entities/home_entities.dart';

abstract class HomeState {}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final List<Category> categories;
  final List<Product> recommendedProducts;

  HomeLoaded({
    required this.categories,
    required this.recommendedProducts,
  });
}

class HomeError extends HomeState {
  final String message;

  HomeError(this.message);
}
