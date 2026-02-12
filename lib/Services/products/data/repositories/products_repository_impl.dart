import 'dart:io';

import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:dartz/dartz.dart';
import 'package:flx_market/Core/error_handling/failure.dart';
import 'package:flx_market/Core/services/firebase/firestore_service.dart';
import 'package:flx_market/Services/home/domain/entities/home_entities.dart';
import 'package:flx_market/Services/products/domain/repositories/products_repository.dart';

import '../../../../Core/services/firebase/base_firestore_service.dart';
import '../../../home/data/models/home_models.dart';

class ProductsRepositoryImpl implements ProductsRepository {
  final BaseFirestoreService _firestoreService;

  ProductsRepositoryImpl() : _firestoreService = FirestoreService.instance;

  @override
  Future<Either<Failure, List<Product>>> getAllProducts() async {
    try {
      final snapshot = await _firestoreService.getAll('products');
      final products = snapshot.docs
          .map((doc) => ProductModel.fromMap(doc.data(), doc.id))
          .toList();
      return Right(products);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Product>>> searchProducts(String query) async {
    try {
      final allProductsResult = await getAllProducts();
      return allProductsResult.fold((failure) => Left(failure), (products) {
        final filtered = products
            .where((p) => p.name.toLowerCase().contains(query.toLowerCase()))
            .toList();
        return Right(filtered);
      });
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Product>>> getProductsByCategory(
    String category,
  ) async {
    try {
      final snapshot = await _firestoreService.getAll('products');
      final products = snapshot.docs
          .map((doc) => ProductModel.fromMap(doc.data(), doc.id))
          .where((p) => p.category == category)
          .toList();
      return Right(products);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Product>>> getProductsByOwner(
    String ownerId,
  ) async {
    try {
      final snapshot = await _firestoreService.getAll('products');
      final products = snapshot.docs
          .map((doc) => ProductModel.fromMap(doc.data(), doc.id))
          .where((p) => (p.ownerId == ownerId))
          .toList();
      return Right(products);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> addProduct(
    Product product,
    File? imageFile,
  ) async {
    try {
      String imageUrl = product.imageUrl;

      if (imageFile != null) {
        try {
          final cloudinary = CloudinaryPublic(
            'dbnbfjeqi',
            'productsImages',
            cache: false,
          );
          CloudinaryResponse response = await cloudinary.uploadFile(
            CloudinaryFile.fromFile(
              imageFile.path,
              resourceType: CloudinaryResourceType.Image,
            ),
          );
          imageUrl = response.secureUrl;
        } catch (e) {
          return Left(ServerFailure('Image Upload Failed: $e'));
        }
      }

      final productModel = ProductModel(
        id: product.id.isEmpty ? '' : product.id,
        name: product.name,
        location: product.location,
        imageUrl: imageUrl,
        price: product.price,
        description: product.description,
        isFeatured: product.isFeatured,
        isFavorite: product.isFavorite,
        ownerId: product.ownerId,
        category: product.category,
      );

      await _firestoreService.add('products', productModel.toMap());

      return const Right(unit);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
