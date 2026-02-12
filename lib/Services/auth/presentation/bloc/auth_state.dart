import 'package:firebase_auth/firebase_auth.dart';
import 'package:flx_market/Services/auth/domain/entities/user.dart' as domain;

abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthAuthenticated extends AuthState {
  final domain.User user;

  AuthAuthenticated(this.user);
}

class AuthPasswordResetSent extends AuthState {}

class AuthNeedsRoleSelection extends AuthState {
  final UserCredential userCredential;

  AuthNeedsRoleSelection(this.userCredential);
}

class AuthUnauthenticated extends AuthState {}

class AuthFailure extends AuthState {
  final String message;

  AuthFailure(this.message);
}
