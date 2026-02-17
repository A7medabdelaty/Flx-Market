import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flx_market/Core/constants/assets_paths.dart';
import 'package:flx_market/Services/auth/presentation/pages/base_auth_page.dart';
import 'package:flx_market/Services/auth/presentation/widgets/auth_divider.dart';
import 'package:flx_market/Services/auth/presentation/widgets/auth_form.dart';
import 'package:flx_market/Services/auth/presentation/widgets/auth_page_container.dart';
import 'package:flx_market/Services/auth/presentation/widgets/auth_submit_button.dart';
import 'package:flx_market/Services/auth/presentation/widgets/social_auth_button.dart';

import '../../../../routes/route_constants.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import '../mixins/fade_animation_mixin.dart';
import '../widgets/auth_text_field.dart';

class LoginPage extends BaseAuthPage {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends BaseAuthPageState<LoginPage>
    with FadeAnimationMixin {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _stayLoggedIn = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  String get title => 'Login';

  @override
  Widget buildForm(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        return AuthPageContainer(
          heading: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [Container(), Image.asset(AssetsPaths.logo, height: 40)],
          ),
          topContent: Column(
            children: [
              const Text(
                'Login',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 32),
              SocialAuthButton(
                text: 'Sign in with Google',
                onPressed: () {
                  context.read<AuthBloc>().add(AuthSignInWithGoogleEvent());
                },
              ),
              const SizedBox(height: 32),
              const AuthDivider(text: 'or sign in with'),
            ],
          ),
          footer: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Don\'t have an Account? ',
                style: TextStyle(color: Colors.black87),
              ),
              GestureDetector(
                onTap: () =>
                    Navigator.pushNamed(context, RouteConstants.register),
                child: Text(
                  'Sign up here',
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          child: AuthForm(
            formKey: formKey,
            animation: fadeAnimation,
            children: [
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Email Address',
                  style: TextStyle(color: Colors.black87),
                ),
              ),
              const SizedBox(height: 8),
              AuthTextField(
                controller: _emailController,
                hintText: 'abc@example.com',
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Please enter your email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Password',
                    style: TextStyle(color: Colors.black87),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pushNamed(
                      context,
                      RouteConstants.resetPassword,
                    ),
                    child: Text(
                      'Forgot Password',
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              AuthTextField(
                controller: _passwordController,
                hintText: '********',
                isPassword: true,
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Please enter your password';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  SizedBox(
                    height: 24,
                    width: 24,
                    child: Checkbox(
                      value: _stayLoggedIn,
                      activeColor: Colors.teal, // Matching design color roughly
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                      onChanged: (value) {
                        setState(() => _stayLoggedIn = value ?? false);
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Keep me signed in',
                    style: TextStyle(color: Colors.black87),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              AuthSubmitButton(
                state: state,
                label: 'Login',
                onPressed: () {
                  if (formKey.currentState?.validate() ?? false) {
                    context.read<AuthBloc>().add(
                      AuthSignInWithEmailEvent(
                        email: _emailController.text,
                        password: _passwordController.text,
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void onAuthenticationSuccess(BuildContext context) {
    Navigator.pushReplacementNamed(context, RouteConstants.home);
  }
}
