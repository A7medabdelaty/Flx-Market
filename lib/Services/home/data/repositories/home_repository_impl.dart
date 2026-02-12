import 'package:dartz/dartz.dart';
import 'package:flx_market/Core/constants/firestore_collections.dart';
import 'package:flx_market/Core/error_handling/failure.dart';
import 'package:flx_market/Core/services/firebase/firestore_service.dart';
import '../../domain/entities/home_entities.dart';
import '../../domain/repositories/home_repository.dart';
import '../models/home_models.dart';

class HomeRepositoryImpl implements HomeRepository {
  final FirestoreService _firestoreService;

  HomeRepositoryImpl() : _firestoreService = FirestoreService.instance;

  @override
  Future<Either<Failure, List<Category>>> getCategories() async {
    try {
      final snapshot = await _firestoreService.getAll(
        FirestoreCollections.categories,
      );
      final categories =
          snapshot.docs
              .map(
                (doc) =>
                    CategoryModel.fromMap(doc.data() as Map<String, dynamic>, doc.id),
              )
              .toList();
      return Right(categories);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Product>>> getRecommendedProducts() async {
    try {
      final snapshot = await _firestoreService.getAll(
        FirestoreCollections.products,
      );
      final products =
          snapshot.docs
              .map(
                (doc) =>
                    ProductModel.fromMap(doc.data() as Map<String, dynamic>, doc.id),
              )
              .toList();
      return Right(products);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> seedInitialData() async {
    try {
      // Seed Categories
      final catSnapshot = await _firestoreService.getAll(
        FirestoreCollections.categories,
      );
      if (catSnapshot.docs.isEmpty) {
        final categories = [
          {'name': 'Mobile', 'iconPath': 'assets/images/mobile_icon.png'},
          {'name': 'Real Estate', 'iconPath': 'assets/images/real_estate.png'},
          {'name': 'Cars', 'iconPath': 'assets/images/cars.png'},
          {'name': 'Electronics', 'iconPath': 'assets/images/electronics.png'},
        ];

        for (var cat in categories) {
          await _firestoreService.add(FirestoreCollections.categories, cat);
        }
      }

      // Seed Products
      final prodSnapshot = await _firestoreService.getAll(
        FirestoreCollections.products,
      );
      if (prodSnapshot.docs.isEmpty) {
        final products = [
          {
            'name': 'Modern Apartment',
            'location': '6th of October City Phase 5, Giza',
            'imageUrl': 'https://firebasestorage.googleapis.com/v0/b/flx-market.appspot.com/o/apartment.jpg?alt=media', // Placeholder
            'price': 2500000.0,
            'isFeatured': true,
            'isFavorite': false,
          },
          {
            'name': 'iPhone 15 Pro',
            'location': 'Cairo, Egypt',
            'imageUrl': 'https://firebasestorage.googleapis.com/v0/b/flx-market.appspot.com/o/iphone.jpg?alt=media', // Placeholder
            'price': 50000.0,
            'isFeatured': false,
            'isFavorite': true,
          },
        ];

        for (var prod in products) {
          await _firestoreService.add(FirestoreCollections.products, prod);
        }
      }

      return const Right(null);
    } catch (e) {
      return Left(ServerFailure('Seeding failed: ${e.toString()}'));
    }
  }
}
