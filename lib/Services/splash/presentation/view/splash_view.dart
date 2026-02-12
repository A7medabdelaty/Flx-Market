import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flx_market/Core/constants/assets_paths.dart';
import 'package:flx_market/Services/auth/presentation/bloc/auth_bloc.dart';
import 'package:flx_market/Services/auth/presentation/bloc/auth_event.dart';
import 'package:flx_market/Services/auth/presentation/bloc/auth_state.dart';
import 'package:flx_market/routes/route_constants.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashView>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _checkAuthStatus();
  }

  void _setupAnimations() {
    _controller = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    _controller.repeat();
  }

  void _checkAuthStatus() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted) {
        context.read<AuthBloc>().add(AuthCheckStatusEvent());
      }
    });
  }

  void _handleNavigation(BuildContext context, String route) {
    if (!_controller.isCompleted) {
      _controller.forward().then((_) {
        if (mounted) {
          Navigator.pushReplacementNamed(context, route);
        }
      });
    } else {
      Navigator.pushReplacementNamed(context, route);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthAuthenticated) {
            _handleNavigation(context, RouteConstants.home);
          } else if (state is AuthUnauthenticated) {
            _handleNavigation(context, RouteConstants.login);
          } else if (state is AuthNeedsRoleSelection) {
            _handleNavigation(context, RouteConstants.completeProfile);
          }
        },
        child: Center(
          child: SizedBox(
            child: Image.asset(AssetsPaths.splashScreen, fit: BoxFit.cover),
          ),
        ),
      ),
    );
  }
}
