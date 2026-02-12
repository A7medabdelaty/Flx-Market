import 'dart:io';
import '../../domain/entities/user_role.dart';

abstract class AuthEvent {}

class AuthSignInWithEmailEvent extends AuthEvent {
  final String email;
  final String password;

  AuthSignInWithEmailEvent({required this.email, required this.password});
}

class AuthSignUpWithEmailEvent extends AuthEvent {
  final String email;
  final String password;
  final String name;
  final String phone;
  final UserRole role;

  AuthSignUpWithEmailEvent({
    required this.email,
    required this.password,
    required this.name,
    required this.phone,
    required this.role,
  });
}

class AuthSignInWithGoogleEvent extends AuthEvent {}

class AuthSignOutEvent extends AuthEvent {}

class AuthCheckStatusEvent extends AuthEvent {}

class AuthCompleteProfileEvent extends AuthEvent {
  final UserRole role;

  AuthCompleteProfileEvent(this.role);
}

class AuthUpdateProfileEvent extends AuthEvent {
  final String name;
  final String phone;

  final File? imageFile;

  AuthUpdateProfileEvent({required this.name, required this.phone, this.imageFile});
}

class AuthResetPasswordEvent extends AuthEvent {
  final String email;

  AuthResetPasswordEvent(this.email);
}

class AuthErrorEvent extends AuthEvent {
  final String message;

  AuthErrorEvent(this.message);
}
