import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthHelper {
  static FirebaseAuthHelper? _instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseAuthHelper._();
  static FirebaseAuthHelper get instance {
    _instance ??= FirebaseAuthHelper._();
    return _instance!;
  }

  User? get currentUser => _auth.currentUser;

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  Future<UserCredential> signInWithEmail(String email, String password) async {
    try {
      return await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      throw _handleAuthException(e);
    }
  }

  Future<UserCredential> signUpWithEmail(String email, String password) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw Exception('Failed to create account: $e');
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  Exception _handleAuthException(dynamic e) {
    if (e is FirebaseAuthException) {
      final errorMessages = {
        'user-not-found': 'No user found for that email.',
        'wrong-password': 'Wrong password provided.',
        'email-already-in-use': 'Email is already in use.',
        'invalid-email': 'The email address is not valid.',
        'weak-password': 'The password provided is too weak.',
        'operation-not-allowed': 'Email/password accounts are not enabled.',
        'user-disabled': 'This user account has been disabled.',
      };
      return Exception(
        errorMessages[e.code] ?? e.message ?? 'Authentication failed.',
      );
    }
    return Exception('Something went wrong.');
  }
}
