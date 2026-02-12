import 'package:flutter/material.dart';
import 'package:flx_market/Core/widgets/custom_button.dart';

import '../bloc/auth_state.dart';

class AuthSubmitButton extends StatelessWidget {
  final AuthState state;
  final String label;
  final VoidCallback onPressed;

  const AuthSubmitButton({
    super.key,
    required this.state,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return CustomButton(
      onPressed: onPressed,
      text: label,
      isLoading: state is AuthLoading,
    );
  }
}
