import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_user_app/core/theme/app_color.dart';
import 'package:food_user_app/features/bottom_nav/cubit/main_navigation_bar_cubit.dart';
import 'package:food_user_app/features/bottom_nav/presentation/widgets/cart_badge.dart';
import 'package:food_user_app/features/cart/controller/cart_controller.dart';
import 'package:food_user_app/features/cart/logic/bloc/cart_bloc.dart';
import 'package:food_user_app/features/cart/logic/bloc/cart_state.dart';
import 'package:food_user_app/features/cart/presentation/screens/cart_screen.dart';
import 'package:food_user_app/features/favorites/presentation/screens/favorites_screen.dart';
import 'package:food_user_app/features/home/presentation/screens/home_screen.dart';
import 'package:food_user_app/features/profile/screens/profile_screens.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({super.key});

  final List<Widget> _pages = const [
    HomeScreen(),
    FavoritesScreen(),
    CartScreen(),
    ProfileScreens(),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => BottomNavCubit(),
      child: BlocBuilder<BottomNavCubit, int>(
        builder: (context, selectedIndex) {
          return Scaffold(
            backgroundColor: Colors.white,
            body: _pages[selectedIndex],
            bottomNavigationBar: BlocBuilder<CartBloc, CartState>(
              builder: (context, state) {
                final cartCount = CartController.getCartItemsCount(context);
                return BottomNavigationBar(
                  backgroundColor: Colors.white,
                  items: [
                    BottomNavigationBarItem(
                      icon: Icon(Icons.home),
                      label: 'Home',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.favorite),
                      label: 'Favorites',
                    ),
                    BottomNavigationBarItem(
                      icon: cartBadge(cartCount),
                      label: 'Cart',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.person),
                      label: 'Profile',
                    ),
                  ],
                  currentIndex: selectedIndex,
                  selectedItemColor: AppColors.primaryOrange,
                  unselectedItemColor: Colors.grey,
                  onTap: (index) {
                    context.read<BottomNavCubit>().updateIndex(index);
                  },
                  type: BottomNavigationBarType.fixed,
                );
              },
            ),
          );
        },
      ),
    );
  }
}
