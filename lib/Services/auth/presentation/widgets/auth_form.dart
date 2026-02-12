import 'package:flutter/material.dart';

class AuthForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final List<Widget> children;
  final Animation<double>? animation;

  const AuthForm({
    super.key,
    required this.formKey,
    required this.children,
    this.animation,
  });

  @override
  Widget build(BuildContext context) {
    Widget form = Form(
      key: formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: children,
      ),
    );

    if (animation != null) {
      return AnimatedBuilder(
        animation: animation!,
        builder:
            (context, child) => Transform.translate(
              offset: Offset(0, animation!.value),
              child: child,
            ),
        child: form,
      );
    }

    return form;
  }
}
