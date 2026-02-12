import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../../Core/services/firebase/base_firestore_service.dart';
import '../../../../Core/services/firebase/firestore_service.dart';
import '../../../../core/error_handling/failure.dart';
import '../../../home/data/models/home_models.dart';
import '../../../home/domain/entities/home_entities.dart';
import '../../domain/repositories/wishlist_repository.dart';

class WishlistRepositoryImpl implements WishlistRepository {
  final BaseFirestoreService _firestoreService;
  final FirebaseAuth _firebaseAuth;

  WishlistRepositoryImpl({
    BaseFirestoreService? firestoreService,
    FirebaseAuth? firebaseAuth,
  }) : _firestoreService = firestoreService ?? FirestoreService.instance,
       _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  String? get _userId => _firebaseAuth.currentUser?.uid;

  @override
  Future<Either<Failure, List<Product>>> getWishlist() async {
    try {
      final uid = _userId;
      if (uid == null) {
        return Left(ServerFailure('User not authenticated'));
      }

      final snapshot = await _firestoreService.getAll('users/$uid/wishlist');
      final products = snapshot.docs
          .map((doc) => ProductModel.fromMap(doc.data(), doc.id))
          .toList();
      return Right(products);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> addToWishlist(Product product) async {
    try {
      final uid = _userId;
      if (uid == null) {
        return Left(ServerFailure('User not authenticated'));
      }

      final productModel = ProductModel(
        id: product.id,
        name: product.name,
        location: product.location,
        imageUrl: product.imageUrl,
        price: product.price,
        isFeatured: product.isFeatured,
        isFavorite: true,
      );

      await _firestoreService.create(
        'users/$uid/wishlist',
        product.id,
        productModel.toMap(),
      );
      return Right(unit);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> removeFromWishlist(String productId) async {
    try {
      final uid = _userId;
      if (uid == null) {
        return Left(ServerFailure('User not authenticated'));
      }

      await _firestoreService.delete('users/$uid/wishlist', productId);
      return Right(unit);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<bool> isFavorite(String productId) async {
    try {
      final uid = _userId;
      if (uid == null) return false;

      final doc = await _firestoreService.get('users/$uid/wishlist', productId);
      return doc.exists;
    } catch (e) {
      return false;
    }
  }
}
