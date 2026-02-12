import 'dart:io';

import 'package:dartz/dartz.dart';

import '../../../../Core/error_handling/failure.dart';
import '../../../home/domain/entities/home_entities.dart';

abstract class ProductsRepository {
  Future<Either<Failure, List<Product>>> getAllProducts();
  Future<Either<Failure, List<Product>>> searchProducts(String query);
  Future<Either<Failure, List<Product>>> getProductsByCategory(String category);
  Future<Either<Failure, List<Product>>> getProductsByOwner(String ownerId);
  Future<Either<Failure, Unit>> addProduct(Product product, File? imageFile);
}
