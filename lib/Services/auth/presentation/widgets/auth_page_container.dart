import 'package:flutter/material.dart';
import 'package:flx_market/Core/extensions/build_context_extension.dart';

class AuthPageContainer extends StatelessWidget {
  final Widget child;
  final Widget? heading;
  final Widget? topContent;
  final Widget? footer;

  const AuthPageContainer({
    super.key,
    required this.child,
    this.heading,
    this.topContent,
    this.footer,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: context.spacing * 2,
            vertical: context.spacing * 2,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (heading != null) ...[
                heading!,
                SizedBox(height: context.hp(0.05)),
              ],
              if (topContent != null) ...[
                topContent!,
                SizedBox(height: context.spacing * 2),
              ],
              SizedBox(
                width: double.infinity,
                child: child,
              ),
              if (footer != null) ...[
                SizedBox(height: context.hp(0.05)),
                footer!,
              ],
            ],
          ),
        ),
      ),
    );
  }
}
