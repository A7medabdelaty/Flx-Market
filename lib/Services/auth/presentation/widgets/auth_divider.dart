import 'package:flutter/material.dart';
import 'package:flx_market/Core/extensions/build_context_extension.dart';

class AuthDivider extends StatelessWidget {
  final String text;

  const AuthDivider({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Divider(
            color: Colors.grey.shade300,
            thickness: 1,
            endIndent: context.spacing,
          ),
        ),
        Text(
          text,
          style: TextStyle(
            color: Colors.grey.shade600,
            fontSize: context.sp(14),
          ),
        ),
        Expanded(
          child: Divider(
            color: Colors.grey.shade300,
            thickness: 1,
            indent: context.spacing,
          ),
        ),
      ],
    );
  }
}
