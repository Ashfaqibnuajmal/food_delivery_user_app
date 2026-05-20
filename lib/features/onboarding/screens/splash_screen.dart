import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_user_app/core/routes/app_routes.dart';
import 'package:food_user_app/features/auth/bloc/auth_bloc_bloc.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    context.read<AuthBlocBloc>().add(AuthCheckEvent());
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocConsumer<AuthBlocBloc, AuthBlocState>(
        listener: (context, state) {
          if (state is WelcomeState) {
            Navigator.of(context).pushReplacementNamed(AppRoutes.onboarding);
          } else if (state is Unauthenticated) {
            Navigator.of(context).pushReplacementNamed(AppRoutes.login);
          } else if (state is Authenticated) {
            Navigator.of(context).pushReplacementNamed(AppRoutes.home);
          } else if (state is ErrorAuth) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text("Error: ${state.error}")));
          }
        },
        builder: (context, state) {
          return Center(
            child: Image.asset(
              "assets/brand_logo.png",
              width: size.width * 0.75,
              fit: BoxFit.contain,
            ),
          );
        },
      ),
    );
  }
}
