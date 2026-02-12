import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flx_market/Core/error_handling/failure.dart';
import '../entities/user_role.dart';
import '../entities/user.dart' as domain;

abstract class AuthRepository {
  Future<Either<Failure, UserCredential>> signInWithEmail(
    String email,
    String password,
  );
  Future<Either<Failure, UserCredential>> signInWithGoogle();
  Future<Either<Failure, UserCredential>> signUpWithEmail(
    String email,
    String password,
    String name,
    String phone,
    UserRole role,
  );
  Future<Either<Failure, void>> signOut();
  Stream<User?> get authStateChanges;
  User? get currentUser;
  Future<bool> checkUserExists(String uid);
  Future<Either<Failure, void>> createUserProfile(UserCredential credential, UserRole role);
  Future<Either<Failure, domain.User>> getUserProfile(String uid);
  Future<Either<Failure, domain.User>> updateUserProfile(domain.User user, {dynamic imageFile});
  Future<Either<Failure, void>> sendPasswordResetEmail(String email);
}
