import 'package:dartz/dartz.dart';

import '../../../../core/error_handling/failure.dart';
import '../../../home/domain/entities/home_entities.dart';

abstract class WishlistRepository {
  Future<Either<Failure, List<Product>>> getWishlist();
  Future<Either<Failure, Unit>> addToWishlist(Product product);
  Future<Either<Failure, Unit>> removeFromWishlist(String productId);
  Future<bool> isFavorite(String productId);
}
