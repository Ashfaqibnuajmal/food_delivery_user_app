import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_user_app/core/routes/app_routes.dart';
import 'package:food_user_app/core/theme/text_style.dart';
import 'package:food_user_app/core/widgets/error_snackbar.dart';
import 'package:food_user_app/core/widgets/loading.dart';
import 'package:food_user_app/core/widgets/show_snack.dart';
import 'package:food_user_app/core/widgets/text_link.dart';
import 'package:food_user_app/features/auth/bloc/auth_bloc_bloc.dart';
import 'package:food_user_app/features/auth/presentation/widgets/auth_redirect_text.dart';
import 'package:food_user_app/features/auth/presentation/widgets/button.dart';
import 'package:food_user_app/features/auth/presentation/widgets/divider_text.dart';
import 'package:food_user_app/features/auth/presentation/widgets/email.dart';
import 'package:food_user_app/features/auth/presentation/widgets/google_button.dart';
import 'package:food_user_app/features/auth/presentation/widgets/password_text_field.dart';
import 'package:gap/gap.dart';

class Login extends StatelessWidget {
  Login({super.key});

  final emailController = TextEditingController();

  final passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBlocBloc, AuthBlocState>(
      listener: (context, state) {
        if (state is ErrorAuth) {
          if (Navigator.canPop(context)) Navigator.pop(context);
          ShowErrorSnackBar.showError(
            context,
            "Login failed. Please try again",
          );
        } else if (Navigator.canPop(context)) {
          Navigator.pop(context);
        }
        if (state is AuthBlocLoading) {
          showDialog(
            context: context,
            builder: (context) => const LoadingIndicator(),
          );
        } else if (state is Authenticated) {
          ShowSnackBar.show(context, "Welcome back . You're now logged in!");
          Navigator.of(context).pushReplacementNamed(AppRoutes.home);
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Gap(40),
                    const Text('Login', style: blackBoldBigTextStyle),
                    const Gap(10),
                    const Text(
                      'Add details for login.',
                      style: lightBlackTextStyle,
                    ),
                    const Gap(80),
                    EmailField(controller: emailController),
                    const Gap(15),
                    PasswordField(controller: passwordController),
                    TextLink(
                      text: "Forgot Password?",
                      onPressed: () {
                        Navigator.pushNamed(context, AppRoutes.forgotPassword);
                      },
                    ),
                    const Gap(35),
                    Center(
                      child: PrimaryButton(
                        text: "Log In",
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            context.read<AuthBlocBloc>().add(
                              LoginEvent(
                                email: emailController.text,
                                password: passwordController.text,
                              ),
                            );
                          }
                        },
                      ),
                    ),
                    const Gap(50),
                    const DividerWithText(text: 'Or Sign With'),
                    const Gap(20),
                    Center(
                      child: GoogleButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (context) => const LoadingIndicator(),
                          );
                          context.read<AuthBlocBloc>().add(GoogleSignInEvent());
                        },
                      ),
                    ),
                    const Gap(20),
                    isUserSignin(
                      questionText: "Already have an account?",
                      actionText: "Sign Up",
                      onPressed: () {
                        Navigator.of(context).pushNamed(AppRoutes.signUp);
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
