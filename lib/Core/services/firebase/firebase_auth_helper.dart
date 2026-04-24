import 'package:firebase_auth/firebase_auth.dart';

extension FirebaseAuthExceptionX on FirebaseAuthException {
  String get readableMessage {
    switch (code) {
      case 'user-not-found':
        return 'No account found with this email. Please check your spelling or sign up.';
      case 'wrong-password':
        return 'Incorrect password. Please try again or reset your password.';
      case 'invalid-credential':
        return 'The email or password you entered is incorrect. Please try again.';
      case 'email-already-in-use':
        return 'This email is already registered. Please log in instead.';
      case 'invalid-email':
        return 'Please enter a valid email address.';
      case 'weak-password':
        return 'Your password is too weak. Please use at least 6 characters.';
      case 'operation-not-allowed':
        return 'Email/password login is not currently enabled.';
      case 'user-disabled':
        return 'This account has been temporarily disabled. Please contact support.';
      case 'too-many-requests':
        return 'Too many failed login attempts. Please try again later.';
      case 'network-request-failed':
        return 'Network error. Please check your internet connection.';
      case 'invalid-verification-code':
        return 'Invalid verification code. Please try again.';
      case 'session-expired':
        return 'Session expired. Please sign in again.';
      case 'account-exists-with-different-credential':
        return 'An account already exists with this email using a different sign-in method.';
      case 'popup-closed-by-user':
      case 'canceled':
        return 'Sign-in was canceled. Please try again.';
      default:
        return message ?? 'An unexpected authentication error occurred.';
    }
  }
}

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
    return await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<UserCredential> signUpWithEmail(String email, String password) async {
    return await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
