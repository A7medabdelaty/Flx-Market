import 'package:dartz/dartz.dart';
import 'package:flx_market/Core/error_handling/failure.dart';

import '../entities/home_entities.dart';

abstract class HomeRepository {
  Future<Either<Failure, List<Category>>> getCategories();
  Future<Either<Failure, List<Product>>> getRecommendedProducts();
  Future<Either<Failure, void>> seedInitialData();
}
