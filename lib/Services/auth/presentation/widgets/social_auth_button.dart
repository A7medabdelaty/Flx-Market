import 'package:flutter/material.dart';
import 'package:flx_market/Core/constants/assets_paths.dart';
import 'package:flx_market/Core/extensions/build_context_extension.dart';

class SocialAuthButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final String iconPath;

  const SocialAuthButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.iconPath = AssetsPaths.googleLogo,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFF3F6FF), // Light blueish background
          elevation: 0,
          padding: EdgeInsets.symmetric(vertical: context.hp(0.015)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        onPressed: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              iconPath,
              height: 24,
              width: 24,
            ),
            SizedBox(width: context.spacing),
            Text(
              text,
              style: TextStyle(
                color: Colors.black87,
                fontSize: context.sp(14),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
