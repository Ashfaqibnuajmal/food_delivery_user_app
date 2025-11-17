import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_user_app/core/routes/app_routes.dart';
import 'package:food_user_app/core/theme/text_style.dart';
import 'package:food_user_app/core/widgets/error_snackbar.dart';
import 'package:food_user_app/core/widgets/loading.dart';
import 'package:food_user_app/core/widgets/show_snack.dart';
import 'package:food_user_app/features/auth/bloc/auth_bloc_bloc.dart';
import 'package:food_user_app/features/auth/presentation/widgets/auth_redirect_text.dart';
import 'package:food_user_app/features/auth/presentation/widgets/button.dart';
import 'package:food_user_app/features/auth/presentation/widgets/confiorm_feild.dart';
import 'package:food_user_app/features/auth/presentation/widgets/divider_text.dart';
import 'package:food_user_app/features/auth/presentation/widgets/email.dart';
import 'package:food_user_app/features/auth/presentation/widgets/google_button.dart';
import 'package:food_user_app/features/auth/presentation/widgets/name_field.dart';
import 'package:food_user_app/features/auth/presentation/widgets/password_text_field.dart';
import 'package:food_user_app/features/auth/presentation/widgets/phone_number_field.dart';
import 'package:gap/gap.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController conformPassword = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBlocBloc, AuthBlocState>(
      listener: (context, state) {
        if (state is ErrorAuth) {
          if (Navigator.canPop(context)) Navigator.pop(context);
          ShowErrorSnackBar.showError(context, "Signin failed.");
        } else if (state is AuthBlocLoading) {
          showDialog(
            context: context,
            builder: (context) => const LoadingIndicator(),
          );
        } else if (state is Authenticated) {
          ShowSnackBar.show(context, "Welcome back! You’re now signed in!");
          Navigator.of(context).pushReplacementNamed(AppRoutes.home);
        }
      },
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          body: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Gap(40),
                    const Text('Sign Up', style: blackBoldBigTextStyle),
                    const Gap(10),
                    const Text(
                      'Add details for sign up.',
                      style: lightBlackTextStyle,
                    ),
                    const Gap(30),
                    NameField(controller: nameController),
                    const Gap(15),
                    EmailField(controller: emailController),
                    const Gap(15),
                    PhoneField(controller: phoneController),
                    const Gap(15),
                    PasswordField(controller: passwordController),
                    const Gap(15),
                    ConfirmPasswordField(
                      controller: conformPassword,
                      matchController: passwordController,
                    ),
                    const Gap(25),
                    Center(
                      child: PrimaryButton(
                        text: "Sign Up",
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            context.read<AuthBlocBloc>().add(
                              RegisterEvent(
                                phone: phoneController.text,
                                name: nameController.text,
                                email: emailController.text,
                                password: passwordController.text,
                              ),
                            );
                          }
                        },
                      ),
                    ),
                    const Gap(20),
                    const DividerWithText(text: 'Or SiLogingn With'),
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
                      actionText: "Login",
                      onPressed: () {
                        Navigator.of(context).pushNamed(AppRoutes.login);
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
