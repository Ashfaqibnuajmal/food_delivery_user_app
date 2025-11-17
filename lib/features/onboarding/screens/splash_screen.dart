import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_user_app/core/routes/app_routes.dart';
import 'package:food_user_app/core/widgets/loading.dart';
import 'package:food_user_app/features/auth/bloc/auth_bloc_bloc.dart';

// Initial screen to check auth state and navigate accordingly
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Trigger auth check on app start
    context.read<AuthBlocBloc>().add(AuthCheckEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocConsumer<AuthBlocBloc, AuthBlocState>(
        // Listen for state changes and navigate
        listener: (context, state) {
          if (state is WelcomeState) {
            Navigator.of(context).pushReplacementNamed(AppRoutes.onboarding);
          } else if (state is Unauthenticated) {
            Navigator.of(context).pushReplacementNamed(AppRoutes.login);
          } else if (state is Authenticated) {
            Navigator.of(context).pushReplacementNamed(AppRoutes.home);
          } else if (state is ErrorAuth) {
            // Show error snackbar if auth check fails
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text("Error: ${state.error}")));
          }
        },
        // Show loading UI while checking auth state
        builder: (context, state) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // App logo
                Image.asset(
                  "assets/Logo.jpeg",
                  height: 200,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 50),
                // Custom loading indicator
                const LoadingIndicator(isSplash: true),
              ],
            ),
          );
        },
      ),
    );
  }
}
