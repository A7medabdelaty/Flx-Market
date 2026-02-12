import 'package:flutter/material.dart';

import '../extensions/build_context_extension.dart';

class ResponsiveLayout extends StatelessWidget {
  final Widget mobile;
  final Widget? tablet;
  final Widget? desktop;

  const ResponsiveLayout({
    super.key,
    required this.mobile,
    this.tablet,
    this.desktop,
  });

  @override
  Widget build(BuildContext context) {
    if (context.isDesktop) {
      return desktop ?? tablet ?? mobile;
    }
    if (context.isTablet) {
      return tablet ?? mobile;
    }
    return mobile;
  }
}
