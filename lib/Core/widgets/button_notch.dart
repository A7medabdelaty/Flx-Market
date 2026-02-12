import 'package:flutter/material.dart';
import 'package:flx_market/Core/constants/nav_colors.dart';

class ButtonNotch extends CustomPainter {
  final Color bgColor;
  final Color dotColor;

  ButtonNotch({
    this.bgColor = NavColors.navBgColor,
    this.dotColor = NavColors.dotColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    var dotPoint = Offset(size.width / 2, 2);

    var paintBg = Paint()
      ..color = bgColor
      ..style = PaintingStyle.fill;
      
    var paintDot = Paint()
      ..color = dotColor
      ..style = PaintingStyle.fill;

    var path = Path();

    path.moveTo(0, 0);
    path.quadraticBezierTo(7.5, 0, 12, 5);
    path.quadraticBezierTo(size.width / 2, size.height / 2, size.width - 12, 5);
    path.quadraticBezierTo(size.width - 7.5, 0, size.width, 0);
    path.close();
    
    canvas.drawPath(path, paintBg);
    canvas.drawCircle(dotPoint, 6, paintDot);
  }

  @override
  bool shouldRepaint(covariant ButtonNotch oldDelegate) {
     return oldDelegate.bgColor != bgColor || oldDelegate.dotColor != dotColor;
  }
}
