import 'dart:io';

import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flx_market/Core/constants/firestore_collections.dart';
import 'package:flx_market/Core/error_handling/failure.dart';
import 'package:flx_market/Core/services/firebase/firebase_auth_helper.dart';
import 'package:flx_market/Core/services/firebase/firestore_service.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../domain/entities/user.dart' as domain;
import '../../domain/entities/user_role.dart' as domain;
import '../../domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuthHelper _authHelper;
  final FirestoreService _firestoreService;
  final FirebaseAuth _firebaseAuth;

  AuthRepositoryImpl()
    : _authHelper = FirebaseAuthHelper.instance,
      _firestoreService = FirestoreService.instance,
      _firebaseAuth = FirebaseAuth.instance;

  @override
  Future<Either<Failure, UserCredential>> signUpWithEmail(
    String email,
    String password,
    String name,
    String phone,
    domain.UserRole role,
  ) async {
    try {
      final result = await _authHelper.signUpWithEmail(email, password);

      if (result.user == null) {
        return Left(ServerFailure('Authentication failed: null user returned'));
      }

      try {
        await _createUserInFirestore(
          result.user!.uid,
          name,
          email,
          phone,
          role,
        );
        return Right(result);
      } catch (e) {
        await result.user!.delete();
        return Left(
          ServerFailure('Failed to create user profile: ${e.toString()}'),
        );
      }
    } catch (e) {
      if (e is FirebaseAuthException) {
        return Left(ServerFailure(e.message ?? 'Authentication failed'));
      }
      return Left(ServerFailure(e.toString()));
    }
  }

  Future<void> _createUserInFirestore(
    String uid,
    String name,
    String email,
    String phone,
    domain.UserRole role,
  ) async {
    final user = domain.User(
      id: uid,
      name: name,
      email: email,
      phone: phone,
      role: role,
      createdAt: DateTime.now(),
    );
    await _firestoreService.create(
      FirestoreCollections.users,
      uid,
      user.toMap(),
    );
  }

  @override
  Stream<User?> get authStateChanges => _authHelper.authStateChanges;

  @override
  User? get currentUser => _authHelper.currentUser;

  @override
  Future<Either<Failure, UserCredential>> signInWithEmail(
    String email,
    String password,
  ) async {
    try {
      final result = await _authHelper.signInWithEmail(email, password);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> signOut() async {
    try {
      await _authHelper.signOut();
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserCredential>> signInWithGoogle() async {
    try {
      final googleSignIn = GoogleSignIn.instance;
      // Initialize GoogleSignIn with serverClientId as required by v7.2.0
      try {
        await googleSignIn.initialize(
          serverClientId:
              '713792125410-gjt1v7je90f76rs4rmjlpvte8rmp9rd2.apps.googleusercontent.com',
        );
      } catch (e) {
        // Log initialization error if needed
      }

      final GoogleSignInAccount? googleUser = await googleSignIn.authenticate();

      if (googleUser == null) {
        return Left(ServerFailure('Google Sign-In cancelled by user'));
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final String? idToken = googleAuth.idToken;
      if (idToken == null) {
        return Left(ServerFailure('Missing Google ID token'));
      }

      final credential = GoogleAuthProvider.credential(idToken: idToken);

      final userCredential = await FirebaseAuth.instance.signInWithCredential(
        credential,
      );

      final user = userCredential.user;
      if (user == null) {
        return Left(ServerFailure('Firebase user is null'));
      }

      return Right(userCredential);
    } on FirebaseAuthException catch (e) {
      return Left(ServerFailure(e.message ?? 'Firebase auth error'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<bool> checkUserExists(String uid) async {
    final doc = await _firestoreService.get(FirestoreCollections.users, uid);
    return doc.exists;
  }

  @override
  Future<Either<Failure, void>> createUserProfile(
    UserCredential credential,
    domain.UserRole role,
  ) async {
    try {
      final user = credential.user!;
      await _createUserInFirestore(
        user.uid,
        user.displayName ?? 'No Name',
        user.email ?? '',
        user.phoneNumber ?? '',
        role,
      );
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, domain.User>> getUserProfile(String uid) async {
    try {
      final doc = await _firestoreService.get(FirestoreCollections.users, uid);
      if (doc.exists && doc.data() != null) {
        return Right(domain.User.fromMap(doc.data() as Map<String, dynamic>));
      } else {
        return Left(ServerFailure('User profile not found'));
      }
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, domain.User>> updateUserProfile(
    domain.User user, {
    dynamic imageFile,
  }) async {
    try {
      String? imageUrl = user.profileImage;

      if (imageFile != null && imageFile is File) {
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

      final updatedUser = user.copyWith(profileImage: imageUrl);

      await _firestoreService.update(
        FirestoreCollections.users,
        updatedUser.id,
        updatedUser.toMap(),
      );
      return Right(updatedUser);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> sendPasswordResetEmail(String email) async {
    try {
      final projectId = _firebaseAuth.app.options.projectId;
      print('Firebase Project ID: $projectId');
      print('Sending password reset email to: $email');
      await _firebaseAuth.sendPasswordResetEmail(email: email);
      print('Password reset email sent successfully');
      return const Right(null);
    } on FirebaseAuthException catch (e) {
      return Left(
        ServerFailure(e.message ?? 'Failed to send password reset email'),
      );
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
