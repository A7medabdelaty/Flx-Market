import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/auth_bloc.dart';
import '../bloc/auth_state.dart';
import '../../../../routes/route_constants.dart';

abstract class BaseAuthPage extends StatefulWidget {
  const BaseAuthPage({super.key});
}

abstract class BaseAuthPageState<T extends BaseAuthPage> extends State<T>
    with TickerProviderStateMixin {
  final formKey = GlobalKey<FormState>();

  @protected
  Widget buildForm(BuildContext context);

  @protected
  String get title;

  String _getUserFriendlyErrorMessage(String error) {
    final lowerError = error.toLowerCase();
    if (lowerError.contains('user-not-found') ||
        lowerError.contains('user not found')) {
      return 'No account found with this email. Please check your email or sign up.';
    } else if (lowerError.contains('wrong-password') ||
        lowerError.contains('wrong password') ||
        lowerError.contains('invalid-credential')) {
      return 'Incorrect password. Please try again or reset your password.';
    } else if (lowerError.contains('invalid-email')) {
      return 'Please enter a valid email address.';
    } else if (lowerError.contains('user-disabled')) {
      return 'This account has been disabled. Please contact support.';
    } else if (lowerError.contains('too-many-requests')) {
      return 'Too many failed attempts. Please try again later.';
    } else if (lowerError.contains('email-already-in-use') ||
        lowerError.contains('already in use')) {
      return 'An account already exists with this email. Please sign in instead.';
    } else if (lowerError.contains('weak-password')) {
      return 'Password is too weak. Please use at least 6 characters.';
    } else if (lowerError.contains('network-request-failed') ||
        lowerError.contains('network')) {
      return 'Connection error. Please check your internet connection and try again.';
    } else if (lowerError.contains('invalid-verification-code')) {
      return 'Invalid verification code. Please try again.';
    } else if (lowerError.contains('session-expired')) {
      return 'Session expired. Please sign in again.';
    } else if (lowerError.contains(
      'account-exists-with-different-credential',
    )) {
      return 'An account already exists with this email using a different sign-in method.';
    } else if (lowerError.contains('popup-closed-by-user') ||
        lowerError.contains('canceled')) {
      return 'Sign-in was canceled. Please try again.';
    } else if (lowerError.contains('operation-not-allowed')) {
      return 'This sign-in method is not enabled. Please contact support.';
    }
    return 'Something went wrong. Please try again.';
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthFailure) {
          final userFriendlyMessage = _getUserFriendlyErrorMessage(
            state.message,
          );
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(userFriendlyMessage)));
        } else if (state is AuthAuthenticated) {
          onAuthenticationSuccess(context);
        } else if (state is AuthNeedsRoleSelection) {
          Navigator.pushReplacementNamed(
            context,
            RouteConstants.completeProfile,
          );
        }
      },
      builder: (context, state) => buildForm(context),
    );
  }

  @protected
  void onAuthenticationSuccess(BuildContext context);
}
