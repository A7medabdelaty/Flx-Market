import 'package:flutter/material.dart';
import 'package:flx_market/Core/presentation/pages/error_view.dart';
import 'package:flx_market/Services/auth/presentation/pages/login_page.dart';
import 'package:flx_market/Services/auth/presentation/pages/register_page.dart';
import 'package:flx_market/Services/auth/presentation/pages/reset_password_page.dart';
import 'package:flx_market/Services/auth/presentation/pages/complete_profile_page.dart';
import 'package:flx_market/Services/home/Presentation/Views/main_page.dart';
import 'package:flx_market/Services/splash/presentation/view/splash_view.dart';
import 'package:flx_market/routes/route_constants.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;
    Widget page;
    bool useSlideTransition = true;

    switch (settings.name) {
      case RouteConstants.splash:
        page = const SplashView();
        useSlideTransition = false;
        break;

      case RouteConstants.home:
        page = const MainPage();
        break;

      case RouteConstants.login:
        page = const LoginPage();
        useSlideTransition = false;
        break;

      case RouteConstants.register:
        page = const RegisterPage();
        useSlideTransition = false;
        break;

      case RouteConstants.resetPassword:
        page = const ResetPasswordPage();
        break;

      case RouteConstants.completeProfile:
        page = const CompleteProfilePage();
        useSlideTransition = false;
        break;

      default:
        page = const ErrorView(message: 'Route not found');
    }

    if (useSlideTransition) {
      return PageRouteBuilder(
        settings: settings,
        pageBuilder: (context, animation, secondaryAnimation) => page,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.easeInOut;

          var tween = Tween(
            begin: begin,
            end: end,
          ).chain(CurveTween(curve: curve));

          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
      );
    }

    // Fade transition for auth pages
    return PageRouteBuilder(
      settings: settings,
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(opacity: animation, child: child);
      },
    );
  }
}
