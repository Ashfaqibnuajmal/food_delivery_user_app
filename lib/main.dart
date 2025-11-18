import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_user_app/core/blocs/category/food_category_filter_cubit.dart';
import 'package:food_user_app/core/blocs/image/image_bloc.dart';
import 'package:food_user_app/core/blocs/search/search_bloc.dart';
import 'package:food_user_app/core/blocs/search/search_event.dart';
import 'package:food_user_app/core/constant/firebase_options.dart';
import 'package:food_user_app/core/routes/app_routes.dart';
import 'package:food_user_app/core/services/image_services.dart';
import 'package:food_user_app/features/auth/bloc/auth_bloc_bloc.dart';
import 'package:food_user_app/features/auth/presentation/screens/forgot_password.dart';
import 'package:food_user_app/features/auth/presentation/screens/login.dart';
import 'package:food_user_app/features/auth/presentation/screens/sign_up.dart';
import 'package:food_user_app/features/bottom_nav/presentation/screens/main_navigation.dart';
import 'package:food_user_app/features/cart/logic/bloc/cart_bloc.dart';
import 'package:food_user_app/features/cart/logic/cubit/cart/cart_quantity_cubit.dart';
import 'package:food_user_app/features/cart/logic/cubit/cart/drink_selection_cubit.dart';
import 'package:food_user_app/features/cart/logic/cubit/checkout/checkout_cubit.dart';
import 'package:food_user_app/features/cart/logic/cubit/location/location_cubit.dart';
import 'package:food_user_app/features/favorites/bloc/favorite_bloc.dart';
import 'package:food_user_app/features/home/logic/bloc/ai_chat_bloc.dart';
import 'package:food_user_app/features/home/logic/cubit/food_portion_cubit.dart';
import 'package:food_user_app/features/home/logic/cubit/today_offer_cubit.dart';
import 'package:food_user_app/features/onboarding/screens/intro_screen.dart';
import 'package:food_user_app/features/onboarding/screens/splash_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => FoodSearchBloc()..add(const SetFoodItems([])),
        ),
        BlocProvider(create: (context) => FoodCategoryFilterCubit()),
        BlocProvider(create: (context) => ImageBloc(ImageServices())),
        BlocProvider(create: (context) => DrinkSelectionCubit()),
        BlocProvider(create: (context) => LocationCubit()),
        BlocProvider(create: (context) => CheckoutCubit()),
        BlocProvider(create: (context) => FoodPortionCubit(initialHalf: false)),
        BlocProvider(create: (context) => CartQuantityCubit()),
        BlocProvider(create: (context) => CartBloc()),
        BlocProvider(create: (context) => FavoriteBloc()),
        BlocProvider(create: (context) => TodayOfferCubit()),
        BlocProvider(create: (context) => AuthBlocBloc()),
        BlocProvider(create: (context) => AiChatBloc()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        initialRoute: AppRoutes.splash,
        routes: {
          AppRoutes.splash: (context) => const SplashScreen(),
          AppRoutes.onboarding: (context) => const OnboardingScreens(),
          AppRoutes.login: (context) => Login(),
          AppRoutes.signUp: (context) => const SignUp(),
          AppRoutes.home: (context) => const BottomNavBar(),
          AppRoutes.forgotPassword: (context) => ForgotPassword(),
        },
      ),
    );
  }
}
