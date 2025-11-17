// import 'package:flutter/material.dart';
// import 'package:inde_app/core/theme/app_color.dart';
// import 'package:inde_app/features/cart/screens/cart_screen.dart';
// import 'package:inde_app/features/favorites/screens/favorites_screen.dart';
// import 'package:inde_app/features/home/screens/home_screen.dart';

// import 'package:inde_app/features/profile/screens/profile_screens.dart';

// class BottomNavBar extends StatefulWidget {
//   const BottomNavBar({super.key});

//   @override
//   // ignore: library_private_types_in_public_api
//   _BottomNavBarExampleState createState() => _BottomNavBarExampleState();
// }

// class _BottomNavBarExampleState extends State<BottomNavBar> {
//   int _selectedIndex = 0;

//   final List<Widget> _pages = const [
//     HomeScreen(),
//     FavoritesScreen(),
//     CartScreen(),
//     ProfileScreens(),
//   ];

//   void _onItemTapped(int index) {
//     setState(() {
//       _selectedIndex = index;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: _pages[_selectedIndex],
//       bottomNavigationBar: BottomNavigationBar(
//         backgroundColor: Colors.white,
//         items: const [
//           BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
//           BottomNavigationBarItem(
//               icon: Icon(Icons.favorite), label: 'Favorites'),
//           BottomNavigationBarItem(
//               icon: Icon(Icons.shopping_cart), label: 'Cart'),
//           BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
//         ],
//         currentIndex: _selectedIndex,
//         selectedItemColor: AppColors.primaryOrange,
//         unselectedItemColor: Colors.grey,
//         onTap: _onItemTapped,
//         type: BottomNavigationBarType.fixed,
//       ),
//     );
//   }
// }
