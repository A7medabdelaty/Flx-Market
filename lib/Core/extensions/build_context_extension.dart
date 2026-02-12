import 'package:flutter/material.dart';

extension BuildContextExtension on BuildContext {
  // Screen size helpers
  Size get screenSize => MediaQuery.of(this).size;
  double get width => screenSize.width;
  double get height => screenSize.height;

  // Device type checks
  bool get isMobile => width < 600;
  bool get isTablet => width >= 600 && width < 1100;
  bool get isDesktop => width >= 1100;

  // Orientation helpers
  bool get isLandscape =>
      MediaQuery.of(this).orientation == Orientation.landscape;
  bool get isPortrait =>
      MediaQuery.of(this).orientation == Orientation.portrait;

  // Responsive dimensions
  double wp(double percent) => width * percent;
  double hp(double percent) => height * percent;

  // Padding helpers
  EdgeInsets get padding => MediaQuery.of(this).padding;
  double get bottomPadding => padding.bottom;
  double get topPadding => padding.top;

  // Font scaling
  double sp(double size) => size * (width / 375.0);

  // Responsive spacing
  double get spacing => width * 0.02;
}
